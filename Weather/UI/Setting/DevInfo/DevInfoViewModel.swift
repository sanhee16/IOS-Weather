//
//  DevInfoViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/08.
//

import Foundation
import Combine
import UIKit

class DevInfoViewModel: BaseViewModel {
    @Published var git: String = "https://github.com/sanhee16"
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClickUrl() {
        if let url = URL(string: git) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}
