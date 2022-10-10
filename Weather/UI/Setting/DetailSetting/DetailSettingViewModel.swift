//
//  DetailSettingViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//

import Foundation
import Combine
import UIKit

typealias DetailItem = (type: WeatherDetail, isOn: Bool)

class DetailSettingViewModel: BaseViewModel {
    @Published var isOnFeelLike: DetailItem = (type: .feelLike, isOn: true)
    @Published var isOnWindSpeed: DetailItem = (type: .windSpeed, isOn: true)
    @Published var isOnPressure: DetailItem = (type: .pressure, isOn: true)
    @Published var isOnHumidity: DetailItem = (type: .humidity, isOn: true)
    @Published var isOnUV: DetailItem = (type: .uv, isOn: true)
    @Published var isOnCloud: DetailItem = (type: .cloud, isOn: true)
    
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        self.updateView()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    private func updateView() {
        self.isOnFeelLike = (type: .feelLike, isOn: Defaults.isUseDetailFeelLike)
        self.isOnWindSpeed = (type: .windSpeed, isOn: Defaults.isUseDetailWindSpeed)
        self.isOnPressure = (type: .pressure, isOn: Defaults.isUseDetailPressure)
        self.isOnHumidity = (type: .humidity, isOn: Defaults.isUseDetailHumidity)
        self.isOnUV = (type: .uv, isOn: Defaults.isUseDetailUV)
        self.isOnCloud = (type: .cloud, isOn: Defaults.isUseDetailCloud)
    }
    
    func updateStatus(_ type: WeatherDetail) {
        switch type {
        case .feelLike: Defaults.isUseDetailFeelLike = !Defaults.isUseDetailFeelLike
        case .windSpeed: Defaults.isUseDetailWindSpeed = !Defaults.isUseDetailWindSpeed
        case .pressure: Defaults.isUseDetailPressure = !Defaults.isUseDetailPressure
        case .humidity: Defaults.isUseDetailHumidity = !Defaults.isUseDetailHumidity
        case .uv: Defaults.isUseDetailUV = !Defaults.isUseDetailUV
        case .cloud: Defaults.isUseDetailCloud = !Defaults.isUseDetailCloud
        }
        updateView()
    }
}
