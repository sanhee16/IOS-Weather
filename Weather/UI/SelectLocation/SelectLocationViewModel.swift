//
//  SelectLocationViewModel.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine
import RealmSwift
import UIKit
import SwiftUIPager
import SwiftUI

enum SeletedStatus {
    case existed
    case selected
    case none
    
    var textColor: Color {
        switch self {
        case .existed: return .white
        case .selected: return .white
        case .none: return .gray100
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .existed: return .gray60
        case .selected: return .blue80
        case .none: return .white
        }
    }
    
    var borderColor: Color {
        switch self {
        case .existed: return .gray100
        case .selected: return .darkblue80
        case .none: return .darkblue80
        }
    }
}

struct LocationItem {
    var location: CityLocationInfo
    var selectedStatus: SeletedStatus
}

extension LocationItem: Equatable {
    static func == (lhs: LocationItem, rhs: LocationItem) -> Bool {
        return
        lhs.location.longitude == rhs.location.longitude &&
        lhs.location.latitude == rhs.location.latitude
    }
}
class SelectLocationViewModel: BaseViewModel {
    @Published var myLocations: [MyLocation] = []
    @Published var allLocations: [String: [LocationItem]] = [:]
    @Published var specificLocations: [LocationItem] = []
    @Published var selectedLocation: LocationItem? = nil
    
    //TODO: 나중에 enum으로 바꿀 수 있으면 바꾸자, realm 도 같이
    @Published var cityList: [String] = ["강원도", "경기도", "경상도", "광주시", "대구시", "대전시", "부산시", "서울", "울산시", "인천시", "전라도", "제주도", "충청도"]
    @Published var selectedCityIdx: Int? = nil
    @Published var isLoading: Bool = true
    private let realm: Realm = try! Realm()
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        loadAllData()
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func loadAllData() {
        self.isLoading = true
        loadMyLocations()
        loadAllLocations()
        self.isLoading = false
    }
    
    func loadMyLocations() {
        self.myLocations.removeAll()
        let data = realm.objects(MyLocation.self).sorted(byKeyPath: "idx", ascending: true)
        for item in data {
            self.myLocations.append(item)
        }
    }
    
    func loadAllLocations() {
        self.selectedLocation = nil
        self.selectedCityIdx = nil
        self.allLocations.removeAll()
        self.specificLocations.removeAll()
        let data = realm.objects(CityLocationInfo.self).sorted(byKeyPath: "idx", ascending: true)
        for item in data {
            var selectedStatus: SeletedStatus = .none
            for mine in myLocations {
                if let myIdx = mine.indexOfDB, myIdx == item.idx {
                    selectedStatus = .existed
                    break
                }
            }
            
            if allLocations[item.city1] == nil {
                allLocations[item.city1] = []
            }
            allLocations[item.city1]?.append(LocationItem(location: item, selectedStatus: selectedStatus))
        }
    }
    
    func selectCity(_ idx: Int?) {
        self.selectedCityIdx = idx
        
        self.specificLocations.removeAll()
        if let selectedIdx = self.selectedCityIdx, let list = self.allLocations[cityList[selectedIdx]] {
            self.specificLocations.append(contentsOf: list)
            print(self.specificLocations.count)
        }
    }
    
    func selectLocation(_ item: LocationItem) {
        if item.selectedStatus == .existed { return }
        if let before = self.selectedLocation {
            for idx in self.specificLocations.indices {
                if self.specificLocations[idx] == before {
                    self.specificLocations[idx].selectedStatus = .none
                    break
                }
            }
        }
        
        if self.selectedLocation == item { // select해제
            self.selectedLocation = nil
        } else { // select하기
            self.selectedLocation = item
            for idx in self.specificLocations.indices {
                if self.specificLocations[idx] == self.selectedLocation {
                    self.specificLocations[idx].selectedStatus = .selected
                    break
                }
            }
        }
    }
    
    func addToMyLocation() {
        guard let item = self.selectedLocation else { return }
        var idx = 0
        if let lastLocation = realm.objects(MyLocation.self).last {
            idx = lastLocation.idx + 1
        }
        try! realm.write {
            realm.add(MyLocation(idx, cityName: "\(item.location.city1) \(item.location.city2)", indexOfDB: item.location.idx, longitude: item.location.longitude, latitude: item.location.latitude))
            self.loadAllData()
        }
    }
    
    func deleteMyLocation() {
        
    }
}
