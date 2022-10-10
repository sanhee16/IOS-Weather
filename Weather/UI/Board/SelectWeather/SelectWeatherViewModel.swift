//
//  SelectWeatherViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//

import Foundation
import Combine
import UIKit
import CoreLocation

class SelectWeatherViewModel: BaseViewModel {
    @Published var list: [WeatherType] = [.clearSky, .fewClouds, .scatteredClouds, .brokenClouds, .showerRain, .rain, .thunderStorm, .snow, .mist]
    @Published var selectedItem: WeatherType? = nil
    private var callback: (WeatherType) -> ()
    
    init(_ coordinator: AppCoordinator, callback: @escaping (WeatherType) -> ()) {
        self.callback = callback
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onSelectItem(_ item: WeatherType) {
        if self.selectedItem == item {
            self.selectedItem = nil
        } else {
            self.selectedItem = item
        }
    }
    
    func onClickSelect() {
        guard let selectedItem = selectedItem else {
            return
        }
        self.dismiss(animated: true) { [weak self] in
            self?.callback(selectedItem)
        }
    }
}

