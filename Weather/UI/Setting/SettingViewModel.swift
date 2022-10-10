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
        self.isUseGps = Defaults.allowGPS
        self.isUseNoti = Defaults.useNoti
        self.isAvailableGPSToggle = checkPermission() == .allow
        super.init(coordinator)
    }
    
    func onAppear() {
        setDisplayTime()
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
    }
    
    func onClickPolicy() {
        self.coordinator?.presentPolicyView()
    }
    
    func onclickDevInfo() {
        self.coordinator?.presentDevInfoView()
    }
    
    func onClickNotiTimeSetting() {
        self.coordinator?.presentNotiSettingView(callback: {[weak self] res in
            self?.onAppear()
        })
    }
    
    func onClickGPSToggle() {
        let status = checkPermission()
        if status != .allow {
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
