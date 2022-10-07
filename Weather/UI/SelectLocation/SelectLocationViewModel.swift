//
//  SelectLocationViewModel.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine

class SelectLocationViewModel: BaseViewModel {
    override init() {
        super.init()
        
    }
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        self.onStartTimer()
    }
    
    func onStartTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.coordinator?.presentMain()
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}
