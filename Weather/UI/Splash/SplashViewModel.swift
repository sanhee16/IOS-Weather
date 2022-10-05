//
//  SplashViewModel.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine

class SplashViewModel: BaseViewModel {
    override init() {
        super.init()
        
    }
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        // API_KEY for https://api.openweathermap.org
        let key = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String
        print("key : \(key)")
    }
    
    func onStartTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // TODO: move to mainView
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}
