//
//  MainViewModel.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine
import RealmSwift
import SwiftUIPager
import CoreLocation


class MainViewModel: BaseViewModel {
    @Published var page: Page = .withIndex(0)
    var locationManager: CLLocationManager
    var myLocation: CLLocation? = nil
    private let realm: Realm = try! Realm()
    @Published var myLocations: [MyLocation] = []
    @Published var isLoading: Bool = true
    @Published var usingLocation: Bool = false
    @Published var weatherInfo: [MyLocation: WeatherResponse] = [:]
    private var api: Api = Api.instance

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
    }
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        super.init(coordinator)
    }
    
    func loadMyLocations() {
        self.isLoading = true
        self.myLocations.removeAll()
        let data = realm.objects(MyLocation.self).sorted(byKeyPath: "idx", ascending: true)
        for item in data {
            self.myLocations.append(item)
        }
        self.isLoading = false
    }

    func onAppear() {
        loadAllData()
    }
    
    func loadAllData() {
        let status = checkPermission()
        self.usingLocation = status == .allow
        if status == .allow {
            getCurrentLocationAndLoadData()
        } else {
            loadMyLocations()
        }
    }
    
    func onClickRefresh() {
        loadAllData()
    }
    
    func getWeather() {
        guard let apiKey = Bundle.main.WEATHER_API_KEY else { return }
        print("api key: \(apiKey)")
        for data in myLocations {
            self.api.getWeather(apiKey, lat: data.latitude, lon: data.longitude)
                .run(in: &self.subscription) {[weak self] response in
                    guard let self = self else { return }
                    self.weatherInfo[data] = response
                } err: { err in
                    print(err)
                } complete: {
                    print("complete")
                }
        }
    }
    
    func onClickSelectLocation() {
        self.coordinator?.presentSelectLocationView()
    }
    
    private func getCurrentLocationAndLoadData() {
        print("getCurrentLocation")
        
        if let coor = locationManager.location?.coordinate {
            self.isLoading = true
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            self.myLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            // getCityInfo
            getCity()
        }
    }
    
    private func getCity() {
        if let coor = locationManager.location?.coordinate {
            self.isLoading = true
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            let latitude = coor.latitude
            let longitude = coor.longitude
            if let myLocation = myLocation {
                geocoder.reverseGeocodeLocation(myLocation, preferredLocale: locale) { [weak self] placemarks, _ in
                    guard let placemarks = placemarks,
                          let address = placemarks.last
                    else { return }
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self, let address = address.locality else { return }
                        // addToMyLoactions
                        var idx: Int? = nil
                        var isUpdate: Bool = false
                        for i in self.realm.objects(MyLocation.self) {
                            if i.indexOfDB == nil {
                                idx = i.idx
                                isUpdate = true
                                break
                            }
                        }
                        if idx == nil {
                            if let lastLocation = self.realm.objects(MyLocation.self).last {
                                idx = lastLocation.idx + 1
                            } else {
                                idx = 0
                            }
                        }
                        try! self.realm.write {
                            guard let idx = idx else { return }
                            if isUpdate {
                                self.realm.add(MyLocation(idx, cityName: address, indexOfDB: nil, longitude: longitude, latitude: latitude), update: .modified)
                            } else {
                                self.realm.add(MyLocation(idx, cityName: address, indexOfDB: nil, longitude: longitude, latitude: latitude))
                            }
                            self.loadMyLocations()
                        }
                    }
                }
            }
        }
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onClickSetting() {
        self.coordinator?.presentSettingView()
    }
}
