//
//  AppDelegate.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import UIKit
import FirebaseCore

//@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate ??
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    /*
     UISceneSession 객체 = scene의 고유의 런타임 인스턴스를 관리함
     scene을 추적하는 session -> session 안에는 고유한 식별자와 scene의 구성 세부사항이 들어있음
     
     현재 업데이트(iOS 13) 이후
     multi-scene, mutli-window가 가능해짐
     
     AppDelegate가 하는 일 (ios 13이후)
     1. 앱의 가장 중요한 데이터 구조를 초기화 하는 것
     2. 앱의 scene을 환경설정 하는 것
     3. 앱 밖에서 발생한 알림에 대응하는 것
     4. 특정한 scenes, views, view controllers에 한정되지 않고 앱 자체를 타겟하는 이벤트에 대응하는 것
     5. 애플 푸쉬 알림 서브스와 같이 실행 시 요구되는 모든 서비스를 등록하는 것
     */
    var appTerminate: (() -> Void)? = nil
    
    // application의 setup을 여기에서 진행한다.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("application : didFinishLaunchingWithOptions")
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self // notification
        return true
    }

    // application이 새로운 scene/window를 제공하려고 할 때 불리는 메소드
    func application(_ application: UIApplication, configurationForConnecting connectionSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("application : configurationForConnecting")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectionSceneSession.role)
    }
    
    // 세로모드
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // 사용자가 scene을 버릴 때 불린다.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("application : didDiscardSceneSessions")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        self.appTerminate?()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("applicationDidFinishLaunching")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userNotificationCenter")
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter")
        completionHandler()
    }
}

