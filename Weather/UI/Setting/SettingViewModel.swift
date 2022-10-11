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
    var locationManager: CLLocationManager
    
    @Published var isAvailableGPSToggle: Bool = false
    private var currentNotiTime: TimeUnit? = nil
    @Published var displayTime: String? = nil
    @Published var isUseGps: Bool {
        didSet {
            Defaults.allowGPS = isUseGps
        }
    }
    @Published var isUseNoti: Bool {
        didSet {
            Defaults.useNoti = isUseNoti
            setDisplayTime()
        }
    }
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.isUseGps = Defaults.allowGPS && checkLocationPermission() == .allow
        self.isUseNoti = Defaults.useNoti
        self.isAvailableGPSToggle = checkLocationPermission() == .allow
        super.init(coordinator)
    }
    
    func onAppear() {
        setDisplayTime()
        
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.isUseGps = Defaults.allowGPS && checkLocationPermission() == .allow
        self.isUseNoti = Defaults.useNoti
        self.isAvailableGPSToggle = checkLocationPermission() == .allow
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func setDisplayTime() {
        currentNotiTime = getTime()
        if let time = currentNotiTime {
            displayTime = "\(time.diff) \(time.hour)시 \(time.minute)분"
        } else {
            displayTime = nil
        }
    }
    
    func getTime() -> TimeUnit? {
        let notiTime = Defaults.notiTime
        if notiTime > 0 {
            return notiTime.getTimeUnit()
        } else {
            let currentTime = Date().timeIntervalSince1970
            Defaults.notiTime = Int(currentTime)
            return Defaults.notiTime.getTimeUnit()
        }
    }
    
    //functions
    func onClickDetailSetting() {
        self.coordinator?.presentDetailSettingViewModel()
    }
    
    func onClickContact() {
        //TODO: test with device
//        self.coordinator?.presentSendEmailView()
        
        if MFMailComposeViewController.canSendMail() {
            print("send Email")
            var version: String? {
                guard let dictionary = Bundle.main.infoDictionary,
                      let version = dictionary["CFBundleShortVersionString"] as? String,
                      let build = dictionary["CFBundleVersion"] as? String else {return nil}
                
                let versionAndBuild: String = "vserion: \(version), build: \(build)"
                return versionAndBuild
            }
            let appVersion = version ?? "unknown"
            let messageBody =
"""
<p>
-----------------------------------------<br/>
App-Version : \(appVersion)<br/>
-----------------------------------------<br/>
</p>
"""
            self.coordinator?.sendEmail(messageBody)
        } else {
            // show failure alert
            self.coordinator?.presentAlertView(.ok, description: "이메일을 보낼 수 있는 설정이 되어있지 않습니다.\n메일 앱에서 계정 연결 후, 메일 사용을 허용해 주세요.")
        }
    }
    
    func onClickPolicy() {
        self.coordinator?.presentPolicyView()
    }
    
    func onclickDevInfo() {
        self.coordinator?.presentDevInfoView()
    }
    
    func onClickCheckPermission() {
        self.coordinator?.presentCheckPermissionView(){ [weak self] in
            self?.onAppear()
        }
    }
    
    func onClickNotiTimeSetting() {
        self.coordinator?.presentNotiSettingView(){[weak self] _ in
            self?.onAppear()
        }
    }
    
    func onClickGPSToggle() {
        let status = checkLocationPermission()
        if status != .allow {
            self.coordinator?.presentCheckPermissionView() { [weak self] in
                self?.onAppear()
            }
        }
    }
}
