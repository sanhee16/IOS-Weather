//
//  AppCoordinator.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI

class AppCoordinator: Coordinator, Terminatable {
    // UIWindow = 화면에 나타나는 View를 묶고, UI의 배경을 제공하고, 이벤트 처리행동을 제공하는 객체 = View들을 담는 컨테이너
    let window: UIWindow
    
    init(window: UIWindow) { // SceneDelegate에서 호출
        self.window = window
        super.init() // Coordinator init
        let navigationController = UINavigationController()
        self.navigationController = navigationController // Coordinator의 navigationController
        self.window.rootViewController = navigationController // window의 rootViewController
        window.makeKeyAndVisible()
    }
    
    // Terminatable
    func appTerminate() {
        print("app Terminate")
        for vc in self.childViewControllers {
            print("terminate : \(type(of: vc))")
            (vc as? Terminatable)?.appTerminate()
        }
        if let navigation = self.navigationController as? UINavigationController {
            for vc in navigation.viewControllers {
                (vc as? Terminatable)?.appTerminate()
            }
        } else {
            
        }
        print("terminate : \(type(of: self.navigationController))")
        (self.navigationController as? Terminatable)?.appTerminate()
    }
    
    func startSplash() {
        //TODO: splashView
        print("start SplashView")
        let vc = SplashView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentMain() {
        let vc = MainView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentSelectLocationView() {
        let vc = SelectLocationView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentSettingView() {
        let vc = SettingView.vc(self)
        self.present(vc, animated: true)
    }
    
    // setting
    func presentPolicyView() {
        let vc = PolicyView.vc(self)
        self.present(vc, animated: true)
    }
    func presentDevInfoView() {
        let vc = DevInfoView.vc(self)
        self.present(vc, animated: true)
    }
    func presentSendEmailView() {
        let vc = SendEmailView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentAlertView(_ type: AlertType, title: String? = nil, description: String? = nil, callback: ((Bool) -> ())? = nil) {
        let vc = AlertView.vc(self, type: type, title: title, description: description, callback: callback)
        self.present(vc, animated: true)
    }
    
    func presentNotiSettingView(callback: ((Bool) -> ())? = nil) {
        let vc = NotiSettingView.vc(self, callback: callback)
        self.present(vc, animated: true)
    }
    
    func presentDetailSettingViewModel() {
        let vc = DetailSettingView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentCheckPermissionView(onDismiss: @escaping ()->()) {
        let vc = CheckPermissionView.vc(self)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentBoardMainView(weatherType: WeatherType = .clearSky) {
        let vc = BoardMainView.vc(self, weatherType: weatherType)
        self.present(vc, animated: true)
    }
    
    //MARK: change
    //TODO: main을 change로 변경 필요!!
}
