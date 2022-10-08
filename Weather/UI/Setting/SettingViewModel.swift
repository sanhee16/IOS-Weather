//
//  SettingViewModel.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation
import Combine
import RealmSwift
import MessageUI
import SwiftUI
import CoreLocation

class SettingViewModel: BaseViewModel {
//    - [필수] 현재 위치정보 사용(사용 중 / 사용 안 함), 문의하기, 개인 정보 처리 방침, 개발자 정보
//    - [선택] 자동 새로고침 시간 간격, 알림, 온도 단위(섭씨 기본값) 강수 단위, 풍속 단위, 시간 형식, 날짜 형식
    @Published var isUseGps: Bool = false
    var locationManager: CLLocationManager
    
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        super.init(coordinator)
    }
    
    func onAppear() {
        print("onAppear")
        self.resetGpsStatus()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    //functions
    func onClickContact() {
        //TODO: test with device
//        self.coordinator?.presentSendEmailView()
    }
    
    func onClickPolicy() {
        self.coordinator?.presentPolicyView()
    }
    
    func onclickDevInfo() {
        self.coordinator?.presentDevInfoView()
    }
    
    func toggleGPS() {
        print("toggleGPS")
        let status = checkPermission()
        if status == .allow {
            isUseGps = false
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        print("isUseGps: \(isUseGps)")
    }
    
    func resetGpsStatus() {
        isUseGps = checkPermission() == .allow
    }
    // email
    
}
