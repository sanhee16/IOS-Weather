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
