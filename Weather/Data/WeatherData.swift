//
//  WeatherData.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/06.
//

import Foundation
import RealmSwift
import UIKit

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

enum WeatherType {
    case clearSky
    case fewClouds
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderStorm
    case snow
    case mist
    case unknown
    
    //TODO: 배경 색상 정하기!
//    var color: UIColor {
//        switch self {
//        case .clearSky: return
//        case .fewClouds: return
//        case .scatteredClouds: return
//        case .brokenClouds: return
//        case .showerRain: return
//        case .rain: return
//        case .thunderStorm: return
//        case .snow: return
//        case .mist: return
//        case .unknown: return
//        }
//    }
    
    var description: String {
        switch self {
        case .clearSky: return "맑고 화창한 날씨!"
        case .fewClouds: return "약간의 구름이 있어요"
        case .scatteredClouds: return "해가 안 보일 수 있어요"
        case .brokenClouds: return "매우 흐린 날씨입니다"
        case .showerRain: return "구름이 많고 비가 옵니다"
        case .rain: return "해가 뜨지만 비도 와요!"
        case .thunderStorm: return "천둥번개가 쳐요!"
        case .snow: return "눈이 옵니다!"
        case .mist: return "안개가 끼니 주의하세요"
        case .unknown: return ""
        }
    }
}
