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


realm.add(Memo(idx, title: title, content: content, date: Date().timeIntervalSince1970, image: image), update: .modified)
