//
//  CheckPermissionViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//

import Foundation
import Combine
import UIKit
import CoreLocation

class CheckPermissionViewModel: BaseViewModel {
    @Published var noti: Bool = false
    @Published var location: Bool = false
    private var locationManager: CLLocationManager
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init(coordinator)
    }
    
    func onAppear() {
        loadCurrentStatus()
    }
    
    private func loadCurrentStatus() {
        //MARK: location check
        let locationStatus = checkLocationPermission()
        switch locationStatus {
        case .allow:
            location = true
            break
        default: location = false
        }
        
        //MARK: noti check
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings {[weak self] notiStatus in
            DispatchQueue.main.async {
                switch notiStatus.authorizationStatus {
                case .authorized:
                    self?.noti = true
                    break
                default: self?.noti = false
                }
            }
        }
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func moveToSettingUrl() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
