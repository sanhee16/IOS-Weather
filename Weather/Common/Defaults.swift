//
//  Defaults.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation

class Defaults {
    
    private static let LAUNCH_BEFORE = "LAUNCH_BEFORE"
    public static var launchBefore: Bool {
        get {
            UserDefaults.standard.bool(forKey: LAUNCH_BEFORE)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: LAUNCH_BEFORE)
        }
    }
    
    private static let ALLOW_GPS = "ALLOW_GPS"
    public static var allowGPS: Bool {
        get {
            UserDefaults.standard.bool(forKey: ALLOW_GPS)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: ALLOW_GPS)
        }
    }
    
    private static let USE_NOTI = "USE_NOTI"
    public static var useNoti: Bool {
        get {
            UserDefaults.standard.bool(forKey: USE_NOTI)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: USE_NOTI)
        }
    }
    
    private static let NOTI_TIME = "NOTI_TIME"
    public static var notiTime: Int {
        get {
            UserDefaults.standard.integer(forKey: NOTI_TIME)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: NOTI_TIME)
        }
    }
    
    private static let CURRENT_LATITUDE = "CURRENT_LATITUDE"
    public static var currentLatitude: Double {
        get {
            UserDefaults.standard.double(forKey: CURRENT_LATITUDE)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: CURRENT_LATITUDE)
        }
    }
    
    private static let CURRENT_LONGITUDE = "CURRENT_LONGITUDE"
    public static var currentLongitude: Double {
        get {
            UserDefaults.standard.double(forKey: CURRENT_LONGITUDE)
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: CURRENT_LONGITUDE)
        }
    }
    
    private static let CURRENT_CITY = "CURRENT_CITY"
    public static var currentCity: String {
        get {
            UserDefaults.standard.string(forKey: CURRENT_CITY) ?? ""
        }
        set(value) {
            UserDefaults.standard.setValue(value, forKey: CURRENT_CITY)
        }
    }
}
