//
//  WeatherData.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/06.
//

import Foundation
import RealmSwift
import UIKit
import SwiftUI

class CityLocationInfo: Object {
    @Persisted(primaryKey: true) var idx: Int
    @Persisted var city1: String
    @Persisted var city2: String
    @Persisted var longitude: Double
    @Persisted var latitude: Double

    convenience init(_ idx: Int, city1: String, city2: String, longitude: Double, latitude: Double) {
        self.init()
        self.idx = idx
        self.city1 = city1
        self.city2 = city2
        self.longitude = longitude
        self.latitude = latitude
    }
}

class MyLocation: Object {
    @Persisted(primaryKey: true) var idx: Int
    @Persisted var cityName: String
    @Persisted var indexOfDB: Int? // 제공된 것(index)인지, 사용자가 등록한 것(nil)인지 체크
    @Persisted var longitude: Double
    @Persisted var latitude: Double
    
    convenience init(_ idx: Int, cityName: String, indexOfDB: Int?, longitude: Double, latitude: Double) {
        self.init()
        self.idx = idx
        self.cityName = cityName
        self.indexOfDB = indexOfDB
        self.longitude = longitude
        self.latitude = latitude
    }
}

enum WeatherType: Int {
    case clearSky = 0
    case fewClouds = 1
    case scatteredClouds = 2
    case brokenClouds = 3
    case showerRain = 4
    case rain = 5
    case thunderStorm = 6
    case snow = 7
    case mist = 8
    case unknown = 9
    
    var textcolor: Color {
        switch self {
        case .clearSky: return Color(hex: "#0090CC").opacity(0.9)
        case .fewClouds: return Color(hex: "#377BFF").opacity(0.9)
        case .scatteredClouds: return .scatteredClouds90
        case .brokenClouds: return .brokenClouds90
        case .showerRain: return Color(hex: "#00C07B").opacity(0.9)
        case .rain: return .rain90
        case .thunderStorm: return Color(hex: "#4332AD").opacity(0.9)
        case .snow: return .gray90
        case .mist: return .gray90
        case .unknown: return .unknown90
        }
    }
    
    var color: Color {
        switch self {
        case .clearSky: return .clearSky60
        case .fewClouds: return .fewClouds60
        case .scatteredClouds: return .scatteredClouds60
        case .brokenClouds: return .brokenClouds60
        case .showerRain: return .showerRain60
        case .rain: return .rain60
        case .thunderStorm: return .thunderStorm60
        case .snow: return .snow60
        case .mist: return .mist60
        case .unknown: return .unknown60
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .clearSky: return .clearSky60
        case .fewClouds: return .fewClouds60
        case .scatteredClouds: return .scatteredClouds60
        case .brokenClouds: return .brokenClouds60
        case .showerRain: return .showerRain60
        case .rain: return .rain60
        case .thunderStorm: return .thunderStorm60
        case .snow: return .snow60
        case .mist: return .mist60
        case .unknown: return .unknown60
        }
    }
    
    var description: String {
        switch self {
        case .clearSky: return "맑고 화창한 날씨!"
        case .fewClouds: return "약간의 구름이 있어요"
        case .scatteredClouds: return "잔 구름이 많아요"
        case .brokenClouds: return "매우 흐린 날씨입니다"
        case .showerRain: return "구름이 많고 비가 와요"
        case .rain: return "우산을 챙기세요!"
        case .thunderStorm: return "천둥번개가 쳐요!"
        case .snow: return "눈이 옵니다!"
        case .mist: return "안개가 끼니 주의하세요"
        case .unknown: return ""
        }
    }
    
    var name: String {
        switch self {
        case .clearSky: return "맑음"
        case .fewClouds: return "약간 흐림"
        case .scatteredClouds: return "잔 구름"
        case .brokenClouds: return "매우 흐림"
        case .showerRain: return "흐리고 비"
        case .rain: return "비"
        case .thunderStorm: return "천둥번개"
        case .snow: return "눈"
        case .mist: return "안개"
        case .unknown: return ""
        }
    }
}

enum WeatherDetail {
    case feelLike
    case windSpeed
    case pressure
    case humidity
    case uv
    case cloud
    
    var name: String {
        switch self {
        case .feelLike: return "체감온도"
        case .windSpeed: return "풍속"
        case .pressure: return "기압"
        case .humidity: return "습도"
        case .uv: return "자외선"
        case .cloud: return "흐림 정도"
        }
    }
    
    var sample: String {
        switch self {
        case .feelLike: return ""
        case .windSpeed: return ""
        case .pressure: return ""
        case .humidity: return ""
        case .uv: return ""
        case .cloud: return ""
        }
    }
}
