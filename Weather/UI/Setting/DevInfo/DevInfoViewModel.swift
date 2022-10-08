//
//  DevInfoViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/08.
//

import Foundation
import Combine

class DevInfoViewModel: BaseViewModel {
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    
    func onClose() {
        self.dismiss()
    }
}
