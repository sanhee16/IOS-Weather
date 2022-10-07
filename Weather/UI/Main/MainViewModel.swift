//
//  MainViewModel.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine
import CoreLocation

class MainViewModel: BaseViewModel {
    var locationManager: CLLocationManager
    var myLocation: CLLocation? = nil

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
    }
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        super.init(coordinator)
    }

    func onAppear() {
        locationManager.requestWhenInUseAuthorization()
        getCurrentLocation()
        getLocation()
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
    
    private func getLocation() {
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
