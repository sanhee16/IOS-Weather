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
    @Published var weatherInfo: [MyLocation: WeatherResponse] = [:]
    private var api: Api = Api.instance

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
    }
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        super.init(coordinator)
        self.loadMyLocations()
    }
    
    func loadMyLocations() {
        self.myLocations.removeAll()
        let data = realm.objects(MyLocation.self).sorted(byKeyPath: "idx", ascending: true)
        for item in data {
            self.myLocations.append(item)
        }
    }

    func onAppear() {
        locationManager.requestWhenInUseAuthorization()
//        getCurrentLocation()
//        getLocation()
        getWeather()
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
    
    private func getCurrentLocation() {
        print("getCurrentLocation")
        
        if let coor = locationManager.location?.coordinate {
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            self.myLocation = CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    private func getCity() {
        if let coor = locationManager.location?.coordinate {
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            if let myLocation = myLocation {
                geocoder.reverseGeocodeLocation(myLocation, preferredLocale: locale) { [weak self] placemarks, _ in
                    guard let placemarks = placemarks,
                          let address = placemarks.last
                    else { return }
                    print("placemarks: \(placemarks)")
                    print("city: \(address.locality)") // 시,군
                    print("subLocality: \(address.subLocality)") // 구
                    DispatchQueue.main.async {
                        //TODO:
                    }
                }
            }
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}
