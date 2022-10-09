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
import UIKit
import SwiftUI
import Network


class MainViewModel: BaseViewModel {
    //TODO: 이거 설정 지우기, false로 해야 api 호출함
    private var IS_FOR_DEBUG_DUMMY: Bool = false
    
    @Published var page: Page = .withIndex(0)
    var locationManager: CLLocationManager
    var myLocation: CLLocation? = nil
    private let realm: Realm = try! Realm()
    @Published var isLoading: Bool = true
    
    @Published var myLocations: [MyLocation] = []
    @Published var weatherInfo: [MyLocation: WeatherResponse] = [:]
    @Published var backgroundColor: Color = .unknown60
    private var api: Api = Api.instance
    private var timerRepeat: Timer?

    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init(coordinator)
        print("allowGPS : \(Defaults.allowGPS)")
    }
    
    func loadMyLocations() {
        self.myLocations.removeAll()
        let data = realm.objects(MyLocation.self).sorted(byKeyPath: "idx", ascending: true)
        for item in data {
            if item.indexOfDB == nil {
                self.myLocations.append(item)
                break
            }
        }
        for item in data {
            if item.indexOfDB == nil { continue }
            self.myLocations.append(item)
        }
        
        self.myLocations.append(MyLocation(-1, cityName: "", indexOfDB: nil, longitude: 0.0, latitude: 0.0))
        //TODO: getWeather() 살리고 isloading 지우기, api 호출 너무 많이 해서 한거임
        if IS_FOR_DEBUG_DUMMY {
            self.isLoading = false
        } else {
            getWeather()
        }
    }

    func onAppear() {
        if !Defaults.launchBefore {
            firstLaunchLogic()
        } else {
            self.isLoading = true
            self.page = .first()
            loadAllData()
        }
    }
    
    func firstLaunchLogic() {
        if !Defaults.launchBefore { //최초 실행시 지역 data를 local DB에 담는다.
            Defaults.launchBefore = true
            locationManager.requestWhenInUseAuthorization()
            print("onStart : \(checkPermission())")
            self.startRepeatTimer()
        }
    }
    // 반복 타이머 시작
    func startRepeatTimer() {
        print("set timer")
        timerRepeat = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerFireRepeat(timer:)), userInfo: "check permission", repeats: true)
    }
    
    // 반복 타이머 실행
    @objc func timerFireRepeat(timer: Timer) {
        print("timer is running")
        if timer.userInfo != nil {
            let status = checkPermission()
            if status != .notYet {
                stopRepeatTimer()
            }
        }
    }
    
    
    // 반복 타이머 종료
    func stopRepeatTimer() {
        print("timer 종료")
        if let timer = timerRepeat {
            if timer.isValid {
                timer.invalidate()
            }
            timerRepeat = nil
            // timer 종료되고 작업 시작
            self.isLoading = true
            self.page = .first()
            loadAllData()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
        }
    }
    
    func loadAllData() {
        let allow = Defaults.allowGPS
        if allow {
            let status = checkPermission()
            if status != .allow {
                Defaults.allowGPS = false
                removeCurrentLocationOnDB()
                loadMyLocations()
            } else {
                getCurrentLocationAndLoadData()
            }
        } else {
            //TODO: realm에서 현재정보 있으면 지워야 함
            removeCurrentLocationOnDB()
            loadMyLocations()
        }
    }
    
    func removeCurrentLocationOnDB() {
        let data = realm.objects(MyLocation.self).sorted(byKeyPath: "idx", ascending: true)
        for item in data {
            if item.indexOfDB == nil {
                try! realm.write {
                    realm.delete(item)
                }
                return
            }
        }
    }
    
    
    func onClickRefresh() {
        loadAllData()
    }
    
    func getWeather() {
        //TODO: erase!
        self.weatherInfo.removeAll()
        if IS_FOR_DEBUG_DUMMY {
            if !dummy.isEmpty {
                print("dummy exist")
                self.weatherInfo = dummy
                self.isLoading = false
                return
            }
        }
        print("sandy dummy not exist")
        
        self.isLoading = true
        guard let apiKey = Bundle.main.WEATHER_API_KEY else { return }
        print("api key: \(apiKey)")
        for data in myLocations {
            if data.idx == -1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoading = false
                }
                break
            }
            self.api.getWeather(apiKey, lat: data.latitude, lon: data.longitude)
                .run(in: &self.subscription) {[weak self] response in
                    guard let self = self else { return }
                    self.weatherInfo[data] = response
                    //TODO: erase dummy
                    if self.IS_FOR_DEBUG_DUMMY {
                        dummy[data] = response
                    }
//                    print(self.weatherInfo)
                } err: { [weak self] err in
                    print(err)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.isLoading = false
                    }
                } complete: { [weak self] in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.isLoading = false
                    }
                    print("complete")
                }
        }
    }
    
    func onClickSelectLocation() {
        self.coordinator?.presentSelectLocationView()
    }
    
    private func getCurrentLocationAndLoadData() {
        if let coor = locationManager.location?.coordinate {
            self.isLoading = true
            let latitude = coor.latitude
            let longitude = coor.longitude
            print("위도 :\(latitude), 경도: \(longitude)")
            self.myLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            // 현재 위치 정보 db에 추가 혹은 업데이트
            saveCurrentLocationOnDB()
        }
    }
    
    private func saveCurrentLocationOnDB() {
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
                                print("isUpdate")
                                let copy = self.realm.create(MyLocation.self, value: MyLocation(idx, cityName: address, indexOfDB: nil, longitude: longitude, latitude: latitude), update: .modified)
                                self.realm.add(copy, update: .all)
                                
//                                self.realm.add(MyLocation(idx, cityName: address, indexOfDB: nil, longitude: longitude, latitude: latitude), update: .modified)
                            } else {
                                print("not update")
                                let copy = self.realm.create(MyLocation.self, value: MyLocation(idx, cityName: address, indexOfDB: nil, longitude: longitude, latitude: latitude))
                                self.realm.add(copy)
//                                self.realm.add(MyLocation(idx, cityName: address, indexOfDB: nil, longitude: longitude, latitude: latitude))
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
    
    func onPageChanged(_ index: Int) {
        withAnimation {
            if let color = weatherInfo[myLocations[index]]?.current.weather[0].icon.weatherType().color {
                self.backgroundColor = color
            } else {
                self.backgroundColor = .unknown60
            }
        }
    }
    
    func onClickGPS() {
        print("onClickGPS")
        let status = checkPermission()
        print("status: \(status)")
        if status == .allow {
            self.coordinator?.presentAlertView(.yesOrNo, title: "현재 위치 사용", description: "현재 위치의 정보를 불러오겠습니까?\n데이터는 저장되지 않습니다.") { [weak self] res in
                print(res)
                if res {
                    Defaults.allowGPS = true
                    self?.loadAllData()
                } else {
                    return
                }
            }
        } else {
            self.coordinator?.presentAlertView(.yesOrNo, title: "권한 설정 필요", description: "위치정보를 위해서는 권한설정이 필요합니다.\n앱 설정에서 위치정보를 항상 허용으로 바꾸어 주세요.", callback: {[weak self] res in
                if res {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })
        }
    }
}
