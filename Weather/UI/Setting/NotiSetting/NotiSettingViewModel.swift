//
//  NotiSettingViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/09.
//

import Foundation
import Combine


class NotiSettingViewModel: BaseViewModel {
    @Published var currentDate: Date = Date(timeIntervalSince1970: Double(Defaults.notiTime))
    private var callback: ((Bool)-> Void)?
    
    init(_ coordinator: AppCoordinator, callback: ((Bool)-> Void)?) {
        self.callback = callback
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClickOK() {
//        print("currentDate: \(currentDate.timeIntervalSince1970)")
        Defaults.notiTime = Int(currentDate.timeIntervalSince1970)
        if let callback = callback {
            callback(true)
            self.dismiss()
        } else {
            self.dismiss()
        }
    }
    
    func onClickCancel() {
        if let callback = callback {
            callback(false)
            self.dismiss()
        } else {
            self.dismiss()
        }
    }
    
    func onClose() {
        self.dismiss()
    }
}

