//
//  SplashViewModel.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import Foundation
import Combine
import RealmSwift
import CoreLocation
import Lottie
import UserNotifications


class SplashViewModel: BaseViewModel {
    private let realm: Realm = try! Realm()
    private var locationManager: CLLocationManager
    private var timerRepeat: Timer?
    
    override init(_ coordinator: AppCoordinator) {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init(coordinator)
        
    }
    
    func onAppear() {
        if !Defaults.launchBefore { //최초 실행시 지역 data를 local DB에 담는다.
//            locationManager.requestWhenInUseAuthorization()
//            print("onStart : \(checkPermission())")
            //MARK: 최초실행 Setting
            Defaults.isUseDetailFeelLike = true
            Defaults.isUseDetailCloud = true
            Defaults.isUseDetailHumidity = true
            Defaults.isUseDetailUV = true
            Defaults.isUseDetailPressure = true
            Defaults.isUseDetailWindSpeed = true
            
            let data = realm.objects(CityLocationInfo.self).sorted(byKeyPath: "idx", ascending: true)
            if data.isEmpty {
                addLocations()
                startRepeatTimer()
            } else {
                //MARK: wait for noti permission
                startRepeatTimer()
            }
            
        } else {
            self.onStartSplashTimer()
        }
    }
    
    func onStartSplashTimer() {
        //TODO: 3초로 변경하기!!
        //TODO: main -> changeMain
//        self.coordinator?.presentBoardMainView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.coordinator?.presentMain()
        }
    }
    
    // 반복 타이머 시작
    func startRepeatTimer() {
        timerRepeat = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerFireRepeat(timer:)), userInfo: "check permission", repeats: true)
    }
    
    // 반복 타이머 실행
    @objc func timerFireRepeat(timer: Timer) {
        if timer.userInfo != nil {
            
            let center = UNUserNotificationCenter.current()

            center.getNotificationSettings {[weak self] status in
                print(status.alertSetting)
                print(status.authorizationStatus)
                
                switch status.authorizationStatus {
                case .notDetermined: break
                default:
                    self?.stopRepeatTimer()
                }
            }
        }
    }
    
    
    // 반복 타이머 종료
    func stopRepeatTimer() {
        if let timer = timerRepeat {
            if timer.isValid {
                timer.invalidate()
            }
            timerRepeat = nil
            // timer 종료되고 작업 시작
            onStartSplashTimer()
        }
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func addLocations() {
        try! realm.write {
            realm.add(CityLocationInfo(1, city1: "강원도", city2: "강릉시", longitude: 128.8784972, latitude: 37.74913611))
            realm.add(CityLocationInfo(2, city1: "강원도", city2: "고성군", longitude: 128.4701639, latitude: 38.37796111))
            realm.add(CityLocationInfo(3, city1: "강원도", city2: "동해시", longitude: 129.1166333, latitude: 37.52193056))
            realm.add(CityLocationInfo(4, city1: "강원도", city2: "삼척시", longitude: 129.1674889, latitude: 37.44708611))
            realm.add(CityLocationInfo(5, city1: "강원도", city2: "속초시", longitude: 128.5941667, latitude: 38.204275))
            realm.add(CityLocationInfo(6, city1: "강원도", city2: "양구군", longitude: 127.9922444, latitude: 38.10729167))
            realm.add(CityLocationInfo(7, city1: "강원도", city2: "양양군", longitude: 128.6213556, latitude: 38.07283333))
            realm.add(CityLocationInfo(8, city1: "강원도", city2: "영월군", longitude: 128.4640194, latitude: 37.18086111))
            realm.add(CityLocationInfo(9, city1: "강원도", city2: "원주시", longitude: 127.9220556, latitude: 37.33908333))
            realm.add(CityLocationInfo(10, city1: "강원도", city2: "인제군", longitude: 128.1726972, latitude: 38.06697222))
            realm.add(CityLocationInfo(11, city1: "강원도", city2: "정선군", longitude: 128.6630861, latitude: 37.37780833))
            realm.add(CityLocationInfo(12, city1: "강원도", city2: "철원군", longitude: 127.3157333, latitude: 38.14405556))
            realm.add(CityLocationInfo(13, city1: "강원도", city2: "춘천시", longitude: 127.7323111, latitude: 37.87854167))
            realm.add(CityLocationInfo(14, city1: "강원도", city2: "태백시", longitude: 128.9879972, latitude: 37.16122778))
            realm.add(CityLocationInfo(15, city1: "강원도", city2: "평창군", longitude: 128.3923528, latitude: 37.36791667))
            realm.add(CityLocationInfo(16, city1: "강원도", city2: "홍천군", longitude: 127.8908417, latitude: 37.69442222))
            realm.add(CityLocationInfo(17, city1: "강원도", city2: "화천군", longitude: 127.7103556, latitude: 38.10340833))
            realm.add(CityLocationInfo(18, city1: "강원도", city2: "횡성군", longitude: 127.9872222, latitude: 37.48895833))
            realm.add(CityLocationInfo(19, city1: "경기도", city2: "가평군", longitude: 127.5117778, latitude: 37.82883056))
            realm.add(CityLocationInfo(20, city1: "경기도", city2: "강화군", longitude: 126.49, latitude: 37.74385833))
            realm.add(CityLocationInfo(21, city1: "경기도", city2: "고양시", longitude: 126.7770556, latitude: 37.65590833))
            realm.add(CityLocationInfo(22, city1: "경기도", city2: "과천시", longitude: 126.9898, latitude: 37.42637222))
            realm.add(CityLocationInfo(23, city1: "경기도", city2: "광명시", longitude: 126.8667083, latitude: 37.47575))
            realm.add(CityLocationInfo(24, city1: "경기도", city2: "광주시", longitude: 127.2577861, latitude: 37.41450556))
            realm.add(CityLocationInfo(25, city1: "경기도", city2: "구리시", longitude: 127.1318639, latitude: 37.591625))
            realm.add(CityLocationInfo(26, city1: "경기도", city2: "군포시", longitude: 126.9375, latitude: 37.35865833))
            realm.add(CityLocationInfo(27, city1: "경기도", city2: "김포시", longitude: 126.7177778, latitude: 37.61245833))
            realm.add(CityLocationInfo(28, city1: "경기도", city2: "남양주시", longitude: 127.2186333, latitude: 37.63317778))
            realm.add(CityLocationInfo(29, city1: "경기도", city2: "동두천시", longitude: 127.0626528, latitude: 37.90091667))
            realm.add(CityLocationInfo(30, city1: "경기도", city2: "부천시", longitude: 126.766, latitude: 37.5035917))
            realm.add(CityLocationInfo(31, city1: "경기도", city2: "성남시", longitude: 127.1477194, latitude: 37.44749167))
            realm.add(CityLocationInfo(32, city1: "경기도", city2: "수원시", longitude: 127.0122222, latitude: 37.30101111))
            realm.add(CityLocationInfo(33, city1: "경기도", city2: "시흥시", longitude: 126.8050778, latitude: 37.37731944))
            realm.add(CityLocationInfo(34, city1: "경기도", city2: "안산시", longitude: 126.8468194, latitude: 37.29851944))
            realm.add(CityLocationInfo(35, city1: "경기도", city2: "안성시", longitude: 127.2818444, latitude: 37.005175))
            realm.add(CityLocationInfo(36, city1: "경기도", city2: "안양시", longitude: 126.9533556, latitude: 37.3897))
            realm.add(CityLocationInfo(37, city1: "경기도", city2: "양주시", longitude: 127.0478194, latitude: 37.78245))
            realm.add(CityLocationInfo(38, city1: "경기도", city2: "양평군", longitude: 127.4898861, latitude: 37.48893611))
            realm.add(CityLocationInfo(39, city1: "경기도", city2: "여주군", longitude: 127.652958, latitude: 37.324606))
            realm.add(CityLocationInfo(40, city1: "경기도", city2: "여주시", longitude: 127.6396222, latitude: 37.29535833))
            realm.add(CityLocationInfo(41, city1: "경기도", city2: "연천군", longitude: 127.0770667, latitude: 38.09336389))
            realm.add(CityLocationInfo(42, city1: "경기도", city2: "오산시", longitude: 127.0796417, latitude: 37.14691389))
            realm.add(CityLocationInfo(43, city1: "경기도", city2: "옹진군", longitude: 126.6388889, latitude: 37.443725))
            realm.add(CityLocationInfo(44, city1: "경기도", city2: "용인시", longitude: 127.2038444, latitude: 37.23147778))
            realm.add(CityLocationInfo(45, city1: "경기도", city2: "의왕시", longitude: 126.9703889, latitude: 37.34195))
            realm.add(CityLocationInfo(46, city1: "경기도", city2: "의정부시", longitude: 127.0358417, latitude: 37.73528889))
            realm.add(CityLocationInfo(47, city1: "경기도", city2: "이천시", longitude: 127.4432194, latitude: 37.27543611))
            realm.add(CityLocationInfo(48, city1: "경기도", city2: "파주시", longitude: 126.7819528, latitude: 37.75708333))
            realm.add(CityLocationInfo(49, city1: "경기도", city2: "평택시", longitude: 127.1146556, latitude: 36.98943889))
            realm.add(CityLocationInfo(50, city1: "경기도", city2: "포천시", longitude: 127.2024194, latitude: 37.89215556))
            realm.add(CityLocationInfo(51, city1: "경기도", city2: "하남시", longitude: 127.217, latitude: 37.53649722))
            realm.add(CityLocationInfo(52, city1: "경기도", city2: "화성시", longitude: 126.8335306, latitude: 37.19681667))
            realm.add(CityLocationInfo(53, city1: "경기도", city2: "인천시청", longitude: 126.7059186, latitude: 37.45617301))
            realm.add(CityLocationInfo(54, city1: "경상도", city2: "거제시", longitude: 128.6233556, latitude: 34.87735833))
            realm.add(CityLocationInfo(55, city1: "경상도", city2: "거창군", longitude: 127.9116556, latitude: 35.683625))
            realm.add(CityLocationInfo(56, city1: "경상도", city2: "경산시", longitude: 128.7434639, latitude: 35.82208889))
            realm.add(CityLocationInfo(57, city1: "경상도", city2: "경주시", longitude: 129.2270222, latitude: 35.85316944))
            realm.add(CityLocationInfo(58, city1: "경상도", city2: "고령군", longitude: 128.2650222, latitude: 35.72298611))
            realm.add(CityLocationInfo(59, city1: "경상도", city2: "고성군", longitude: 128.3245417, latitude: 34.9699))
            realm.add(CityLocationInfo(60, city1: "경상도", city2: "구미시", longitude: 128.3467778, latitude: 36.11655))
            realm.add(CityLocationInfo(61, city1: "경상도", city2: "군위군", longitude: 128.5750778, latitude: 36.23999722))
            realm.add(CityLocationInfo(62, city1: "경상도", city2: "기장군", longitude: 129.224475, latitude: 35.24135))
            realm.add(CityLocationInfo(63, city1: "경상도", city2: "김천시", longitude: 128.1158, latitude: 36.13689722))
            realm.add(CityLocationInfo(64, city1: "경상도", city2: "김해시", longitude: 128.8916667, latitude: 35.22550556))
            realm.add(CityLocationInfo(65, city1: "경상도", city2: "남해군", longitude: 127.8944667, latitude: 34.83455833))
            realm.add(CityLocationInfo(66, city1: "경상도", city2: "달성군", longitude: 128.433275, latitude: 35.77168056))
            realm.add(CityLocationInfo(67, city1: "경상도", city2: "마산시", longitude: 128.567863 , latitude: 35.196874))
            realm.add(CityLocationInfo(68, city1: "경상도", city2: "문경시", longitude: 128.1890194, latitude: 36.58363056))
            realm.add(CityLocationInfo(69, city1: "경상도", city2: "밀양시", longitude: 128.7489444, latitude: 35.50077778))
            realm.add(CityLocationInfo(70, city1: "경상도", city2: "봉화군", longitude: 128.734875, latitude: 36.89026111))
            realm.add(CityLocationInfo(71, city1: "경상도", city2: "사천시", longitude: 128.0667778, latitude: 35.00028333))
            realm.add(CityLocationInfo(72, city1: "경상도", city2: "산청군", longitude: 127.8756194, latitude: 35.41249167))
            realm.add(CityLocationInfo(73, city1: "경상도", city2: "상주시", longitude: 128.1612639, latitude: 36.40796944))
            realm.add(CityLocationInfo(74, city1: "경상도", city2: "성주군", longitude: 128.2851528, latitude: 35.91621111))
            realm.add(CityLocationInfo(75, city1: "경상도", city2: "안동시", longitude: 128.7316222, latitude: 36.56546389))
            realm.add(CityLocationInfo(76, city1: "경상도", city2: "양산시", longitude: 129.0394111, latitude: 35.33192778))
            realm.add(CityLocationInfo(77, city1: "경상도", city2: "영덕군", longitude: 129.3683556, latitude: 36.41210278))
            realm.add(CityLocationInfo(78, city1: "경상도", city2: "영양군", longitude: 129.1146222, latitude: 36.664275))
            realm.add(CityLocationInfo(79, city1: "경상도", city2: "영주시", longitude: 128.6263444, latitude: 36.80293611))
            realm.add(CityLocationInfo(80, city1: "경상도", city2: "영천시", longitude: 128.940775, latitude: 35.97005278))
            realm.add(CityLocationInfo(81, city1: "경상도", city2: "예천군", longitude: 128.4550222, latitude: 36.65495000))
            realm.add(CityLocationInfo(82, city1: "경상도", city2: "울릉군", longitude: 130.9037889, latitude: 37.48057500))
            realm.add(CityLocationInfo(83, city1: "경상도", city2: "울주군", longitude: 129.2971639, latitude: 35.53073889))
            realm.add(CityLocationInfo(84, city1: "경상도", city2: "울진군", longitude: 129.4027861, latitude: 36.99018611))
            realm.add(CityLocationInfo(85, city1: "경상도", city2: "의령군", longitude: 128.2638222, latitude: 35.31911944))
            realm.add(CityLocationInfo(86, city1: "경상도", city2: "의성군", longitude: 128.6993639, latitude: 36.34975833))
            realm.add(CityLocationInfo(87, city1: "경상도", city2: "진주시", longitude: 128.1100000, latitude: 35.17703333))
            realm.add(CityLocationInfo(88, city1: "경상도", city2: "진해시", longitude: 128.710081 , latitude: 35.1330600))
            realm.add(CityLocationInfo(89, city1: "경상도", city2: "창녕군", longitude: 128.4945333, latitude: 35.54153611))
            realm.add(CityLocationInfo(90, city1: "경상도", city2: "창원시", longitude: 128.6401544, latitude: 35.2540033))
            realm.add(CityLocationInfo(91, city1: "경상도", city2: "청도군", longitude: 128.7362000, latitude: 35.64431111))
            realm.add(CityLocationInfo(92, city1: "경상도", city2: "청송군", longitude: 129.0594000, latitude: 36.43329167))
            realm.add(CityLocationInfo(93, city1: "경상도", city2: "칠곡군", longitude: 128.4037972, latitude: 35.99254722))
            realm.add(CityLocationInfo(94, city1: "경상도", city2: "통영시", longitude: 128.4352778, latitude: 34.85125833))
            realm.add(CityLocationInfo(95, city1: "경상도", city2: "포항시", longitude: 129.3616667, latitude: 36.00568611))
            realm.add(CityLocationInfo(96, city1: "경상도", city2: "하동군", longitude: 127.7534306, latitude: 35.06420278))
            realm.add(CityLocationInfo(97, city1: "경상도", city2: "함안군", longitude: 128.4087083, latitude: 35.26940556))
            realm.add(CityLocationInfo(98, city1: "경상도", city2: "함양군", longitude: 127.7274194, latitude: 35.51746944))
            realm.add(CityLocationInfo(99, city1: "경상도", city2: "합천군", longitude: 128.1679306, latitude: 35.56361667))
            realm.add(CityLocationInfo(100, city1: "경상도", city2: "부산시", longitude: 129.075, latitude: 35.1798))
            realm.add(CityLocationInfo(101, city1: "경상도", city2: "대구시", longitude: 128.6017, latitude: 35.8715))
            realm.add(CityLocationInfo(102, city1: "경상도", city2: "울산시", longitude: 129.3123, latitude: 35.546))
            realm.add(CityLocationInfo(103, city1: "광주시", city2: "광산구", longitude: 126.793668, latitude: 35.13995836))
            realm.add(CityLocationInfo(104, city1: "광주시", city2: "남구", longitude: 126.9025572, latitude: 35.13301749))
            realm.add(CityLocationInfo(105, city1: "광주시", city2: "동구", longitude: 126.9230903, latitude: 35.14627776))
            realm.add(CityLocationInfo(106, city1: "광주시", city2: "북구", longitude: 126.9010806, latitude: 35.1812138))
            realm.add(CityLocationInfo(107, city1: "광주시", city2: "서구", longitude: 126.8895063, latitude: 35.1525164))
            realm.add(CityLocationInfo(108, city1: "대구시", city2: "달서구", longitude: 128.5350639, latitude: 35.82692778))
            realm.add(CityLocationInfo(109, city1: "대구시", city2: "수성구", longitude: 128.6328667, latitude: 35.85520833))
            realm.add(CityLocationInfo(110, city1: "대구시", city2: "남구", longitude: 128.597702, latitude: 35.84621351))
            realm.add(CityLocationInfo(111, city1: "대구시", city2: "달서구", longitude: 128.5325905, latitude: 35.82997744))
            realm.add(CityLocationInfo(112, city1: "대구시", city2: "달성군", longitude: 128.4313995, latitude: 35.77475029))
            realm.add(CityLocationInfo(113, city1: "대구시", city2: "동구", longitude: 128.6355584, latitude: 35.88682728))
            realm.add(CityLocationInfo(114, city1: "대구시", city2: "북구", longitude: 128.5828924, latitude: 35.8858646))
            realm.add(CityLocationInfo(115, city1: "대구시", city2: "서구", longitude: 128.5591601, latitude: 35.87194054))
            realm.add(CityLocationInfo(116, city1: "대구시", city2: "수성구", longitude: 128.6307011, latitude: 35.85835148))
            realm.add(CityLocationInfo(117, city1: "대구시", city2: "중구", longitude: 128.6061745, latitude: 35.86952722))
            realm.add(CityLocationInfo(118, city1: "대전시", city2: "대덕구", longitude: 127.4170933, latitude: 36.35218384))
            realm.add(CityLocationInfo(119, city1: "대전시", city2: "동구", longitude: 127.4548596, latitude: 36.31204028))
            realm.add(CityLocationInfo(120, city1: "대전시", city2: "서구", longitude: 127.3834158, latitude: 36.35707299))
            realm.add(CityLocationInfo(121, city1: "대전시", city2: "유성구", longitude: 127.3561363, latitude: 36.36405586))
            realm.add(CityLocationInfo(122, city1: "대전시", city2: "중구", longitude: 127.421381, latitude: 36.32582989))
            realm.add(CityLocationInfo(123, city1: "부산시", city2: "강서구", longitude: 128.9829083, latitude: 35.20916389))
            realm.add(CityLocationInfo(124, city1: "부산시", city2: "금정구", longitude: 129.0943194, latitude: 35.24007778))
            realm.add(CityLocationInfo(125, city1: "부산시", city2: "남구", longitude: 129.0865, latitude: 35.13340833))
            realm.add(CityLocationInfo(126, city1: "부산시", city2: "동구", longitude: 129.059175, latitude: 35.13589444))
            realm.add(CityLocationInfo(127, city1: "부산시", city2: "동래구", longitude: 129.0858556, latitude: 35.20187222))
            realm.add(CityLocationInfo(128, city1: "부산시", city2: "부산진구", longitude: 129.0553194, latitude: 35.15995278))
            realm.add(CityLocationInfo(129, city1: "부산시", city2: "북구", longitude: 128.992475, latitude: 35.19418056))
            realm.add(CityLocationInfo(130, city1: "부산시", city2: "사상구", longitude: 128.9933333, latitude: 35.14946667))
            realm.add(CityLocationInfo(131, city1: "부산시", city2: "사하구", longitude: 128.9770417, latitude: 35.10142778))
            realm.add(CityLocationInfo(132, city1: "부산시", city2: "서구", longitude: 129.0263778, latitude: 35.09483611))
            realm.add(CityLocationInfo(133, city1: "부산시", city2: "수영구", longitude: 129.115375, latitude: 35.14246667))
            realm.add(CityLocationInfo(134, city1: "부산시", city2: "연제구", longitude: 129.082075, latitude: 35.17318611))
            realm.add(CityLocationInfo(135, city1: "부산시", city2: "영도구", longitude: 129.0701861, latitude: 35.08811667))
            realm.add(CityLocationInfo(136, city1: "부산시", city2: "중구", longitude: 129.0345083, latitude: 35.10321667))
            realm.add(CityLocationInfo(137, city1: "부산시", city2: "해운대구", longitude: 129.1658083, latitude: 35.16001944))
            realm.add(CityLocationInfo(138, city1: "부산시", city2: "기장군", longitude: 129.2222873, latitude: 35.24477541))
            realm.add(CityLocationInfo(139, city1: "서울", city2: "강남구", longitude: 127.0495556, latitude: 37.514575))
            realm.add(CityLocationInfo(140, city1: "서울", city2: "강동구", longitude: 127.1258639, latitude: 37.52736667))
            realm.add(CityLocationInfo(141, city1: "서울", city2: "강북구", longitude: 127.0277194, latitude: 37.63695556))
            realm.add(CityLocationInfo(142, city1: "서울", city2: "강서구", longitude: 126.851675, latitude: 37.54815556))
            realm.add(CityLocationInfo(143, city1: "서울", city2: "관악구", longitude: 126.9538444, latitude: 37.47538611))
            realm.add(CityLocationInfo(144, city1: "서울", city2: "광진구", longitude: 127.0845333, latitude: 37.53573889))
            realm.add(CityLocationInfo(145, city1: "서울", city2: "구로구", longitude: 126.8895972, latitude: 37.49265))
            realm.add(CityLocationInfo(146, city1: "서울", city2: "금천구", longitude: 126.9041972, latitude: 37.44910833))
            realm.add(CityLocationInfo(147, city1: "서울", city2: "노원구", longitude: 127.0583889, latitude: 37.65146111))
            realm.add(CityLocationInfo(148, city1: "서울", city2: "도봉구", longitude: 127.0495222, latitude: 37.66583333))
            realm.add(CityLocationInfo(149, city1: "서울", city2: "동대문구", longitude: 127.0421417, latitude: 37.571625))
            realm.add(CityLocationInfo(150, city1: "서울", city2: "동작구", longitude: 126.941575, latitude: 37.50965556))
            realm.add(CityLocationInfo(151, city1: "서울", city2: "마포구", longitude: 126.9105306, latitude: 37.56070556))
            realm.add(CityLocationInfo(152, city1: "서울", city2: "서대문구", longitude: 126.9388972, latitude: 37.57636667))
            realm.add(CityLocationInfo(153, city1: "서울", city2: "서초구", longitude: 127.0348111, latitude: 37.48078611))
            realm.add(CityLocationInfo(154, city1: "서울", city2: "성동구", longitude: 127.039, latitude: 37.56061111))
            realm.add(CityLocationInfo(155, city1: "서울", city2: "성북구", longitude: 127.0203333, latitude: 37.58638333))
            realm.add(CityLocationInfo(156, city1: "서울", city2: "송파구", longitude: 127.1079306, latitude: 37.51175556))
            realm.add(CityLocationInfo(157, city1: "서울", city2: "양천구", longitude: 126.8687083, latitude: 37.51423056))
            realm.add(CityLocationInfo(158, city1: "서울", city2: "영등포구", longitude: 126.8983417, latitude: 37.52361111))
            realm.add(CityLocationInfo(159, city1: "서울", city2: "용산구", longitude: 126.9675222, latitude: 37.53609444))
            realm.add(CityLocationInfo(160, city1: "서울", city2: "은평구", longitude: 126.9312417, latitude: 37.59996944))
            realm.add(CityLocationInfo(161, city1: "서울", city2: "종로구", longitude: 126.9816417, latitude: 37.57037778))
            realm.add(CityLocationInfo(162, city1: "서울", city2: "중구", longitude: 126.9996417, latitude: 37.56100278))
            realm.add(CityLocationInfo(163, city1: "서울", city2: "중랑구", longitude: 127.0947778, latitude: 37.60380556))
            realm.add(CityLocationInfo(164, city1: "울산시", city2: "남구", longitude: 129.3301754, latitude: 35.54404265))
            realm.add(CityLocationInfo(165, city1: "울산시", city2: "동구", longitude: 129.4166919, latitude: 35.50516996))
            realm.add(CityLocationInfo(166, city1: "울산시", city2: "북구", longitude: 129.361245, latitude: 35.58270783))
            realm.add(CityLocationInfo(167, city1: "울산시", city2: "울주군", longitude: 129.2424748, latitude: 35.52230648))
            realm.add(CityLocationInfo(168, city1: "울산시", city2: "중구", longitude: 129.3328162, latitude: 35.56971228))
            realm.add(CityLocationInfo(169, city1: "인천시", city2: "강화군", longitude: 126.4878417, latitude: 37.74692907))
            realm.add(CityLocationInfo(170, city1: "인천시", city2: "계양구", longitude: 126.737744, latitude: 37.53770728))
            realm.add(CityLocationInfo(171, city1: "인천시", city2: "남구", longitude: 126.6502972, latitude: 37.46369169))
            realm.add(CityLocationInfo(172, city1: "인천시", city2: "남동구", longitude: 126.7309669, latitude: 37.44971062))
            realm.add(CityLocationInfo(173, city1: "인천시", city2: "동구", longitude: 126.6432441, latitude: 37.47401607))
            realm.add(CityLocationInfo(174, city1: "인천시", city2: "미추홀구", longitude: 126.6502972, latitude: 37.46369169))
            realm.add(CityLocationInfo(175, city1: "인천시", city2: "부평구", longitude: 126.7219068, latitude: 37.50784204))
            realm.add(CityLocationInfo(176, city1: "인천시", city2: "서구", longitude: 126.6759616, latitude: 37.54546372))
            realm.add(CityLocationInfo(177, city1: "인천시", city2: "연수구", longitude: 126.6782658, latitude: 37.41038125))
            realm.add(CityLocationInfo(178, city1: "인천시", city2: "중구", longitude: 126.6217617, latitude: 37.47384843))
            realm.add(CityLocationInfo(179, city1: "전라도", city2: "강진군", longitude: 126.7691972, latitude: 34.63891111))
            realm.add(CityLocationInfo(180, city1: "전라도", city2: "고창군", longitude: 126.7041083, latitude: 35.43273889))
            realm.add(CityLocationInfo(181, city1: "전라도", city2: "고흥군", longitude: 127.2870556, latitude: 34.60806944))
            realm.add(CityLocationInfo(182, city1: "전라도", city2: "곡성군", longitude: 127.2941083, latitude: 35.27895556))
            realm.add(CityLocationInfo(183, city1: "전라도", city2: "광양시", longitude: 127.6981778, latitude: 34.93753611))
            realm.add(CityLocationInfo(184, city1: "전라도", city2: "구례군", longitude: 127.4649333, latitude: 35.19945833))
            realm.add(CityLocationInfo(185, city1: "전라도", city2: "군산시", longitude: 126.7388444, latitude: 35.96464167))
            realm.add(CityLocationInfo(186, city1: "전라도", city2: "김제시", longitude: 126.8827528, latitude: 35.800575))
            realm.add(CityLocationInfo(187, city1: "전라도", city2: "나주시", longitude: 126.7128667, latitude: 35.01283889))
            realm.add(CityLocationInfo(188, city1: "전라도", city2: "남원시", longitude: 127.3925, latitude: 35.41325556))
            realm.add(CityLocationInfo(189, city1: "전라도", city2: "담양군", longitude: 126.9901639, latitude: 35.318125))
            realm.add(CityLocationInfo(190, city1: "전라도", city2: "목포시", longitude: 126.3944194, latitude: 34.80878889))
            realm.add(CityLocationInfo(191, city1: "전라도", city2: "무안군", longitude: 126.4837, latitude: 34.98736944))
            realm.add(CityLocationInfo(192, city1: "전라도", city2: "무주군", longitude: 127.6628667, latitude: 36.00382778))
            realm.add(CityLocationInfo(193, city1: "전라도", city2: "보성군", longitude: 127.0820889, latitude: 34.76833333))
            realm.add(CityLocationInfo(194, city1: "전라도", city2: "부안군", longitude: 126.7356778, latitude: 35.72853333))
            realm.add(CityLocationInfo(195, city1: "전라도", city2: "순창군", longitude: 127.1396306, latitude: 35.37138889))
            realm.add(CityLocationInfo(196, city1: "전라도", city2: "순천시", longitude: 127.4893306, latitude: 34.94760556))
            realm.add(CityLocationInfo(197, city1: "전라도", city2: "신안군", longitude: 126.3817306, latitude: 34.78981111))
            realm.add(CityLocationInfo(198, city1: "전라도", city2: "여수시", longitude: 127.6643861, latitude: 34.75731111))
            realm.add(CityLocationInfo(199, city1: "전라도", city2: "영광군", longitude: 126.5140861, latitude: 35.27416667))
            realm.add(CityLocationInfo(200, city1: "전라도", city2: "영암군", longitude: 126.6986194, latitude: 34.79698889))
            realm.add(CityLocationInfo(201, city1: "전라도", city2: "완도군", longitude: 126.7570972, latitude: 34.30785278))
            realm.add(CityLocationInfo(202, city1: "전라도", city2: "완주군", longitude: 127.1495972, latitude: 35.84296944))
            realm.add(CityLocationInfo(203, city1: "전라도", city2: "익산시", longitude: 126.9598528, latitude: 35.945275))
            realm.add(CityLocationInfo(204, city1: "전라도", city2: "임실군", longitude: 127.2847528, latitude: 35.60806389))
            realm.add(CityLocationInfo(205, city1: "전라도", city2: "장성군", longitude: 126.786975, latitude: 35.29881111))
            realm.add(CityLocationInfo(206, city1: "전라도", city2: "장수군", longitude: 127.5233, latitude: 35.64429722))
            realm.add(CityLocationInfo(207, city1: "전라도", city2: "장흥군", longitude: 126.9091083, latitude: 34.678525))
            realm.add(CityLocationInfo(208, city1: "전라도", city2: "전주시", longitude: 127.1219194, latitude: 35.80918889))
            realm.add(CityLocationInfo(209, city1: "전라도", city2: "정읍시", longitude: 126.8581111, latitude: 35.56687222))
            realm.add(CityLocationInfo(210, city1: "전라도", city2: "진도군", longitude: 126.2655444, latitude: 34.48375))
            realm.add(CityLocationInfo(211, city1: "전라도", city2: "진안군", longitude: 127.4269667, latitude: 35.78871944))
            realm.add(CityLocationInfo(212, city1: "전라도", city2: "함평군", longitude: 126.5186194, latitude: 35.06274444))
            realm.add(CityLocationInfo(213, city1: "전라도", city2: "해남군", longitude: 126.6012889, latitude: 34.57043611))
            realm.add(CityLocationInfo(214, city1: "전라도", city2: "화순군", longitude: 126.9885667, latitude: 35.06148056))
            realm.add(CityLocationInfo(215, city1: "전라도", city2: "광주시", longitude: 127.2551569, latitude: 37.42949814))
            realm.add(CityLocationInfo(216, city1: "제주도", city2: "서귀포시", longitude: 126.5125556, latitude: 33.25235))
            realm.add(CityLocationInfo(217, city1: "제주도", city2: "제주시", longitude: 126.5332083, latitude: 33.49631111))
            realm.add(CityLocationInfo(218, city1: "충청도", city2: "갈매로", longitude: 128.6035528, latitude: 35.86854167))
            realm.add(CityLocationInfo(219, city1: "충청도", city2: "계룡시", longitude: 127.2509306, latitude: 36.27183611))
            realm.add(CityLocationInfo(220, city1: "충청도", city2: "고운동", longitude: 127.236112, latitude: 36.519901))
            realm.add(CityLocationInfo(221, city1: "충청도", city2: "공주시", longitude: 127.1211194, latitude: 36.44361389))
            realm.add(CityLocationInfo(222, city1: "충청도", city2: "괴산군", longitude: 127.7888306, latitude: 36.81243056))
            realm.add(CityLocationInfo(223, city1: "충청도", city2: "국책연구원1로", longitude: 127.29562, latitude: 36.488994))
            realm.add(CityLocationInfo(224, city1: "충청도", city2: "금남면", longitude: 127.28035, latitude: 36.463826))
            realm.add(CityLocationInfo(225, city1: "충청도", city2: "금산군", longitude: 127.4903083, latitude: 36.10586944))
            realm.add(CityLocationInfo(226, city1: "충청도", city2: "나리1로", longitude: 126.613277, latitude: 36.891878))
            realm.add(CityLocationInfo(227, city1: "충청도", city2: "나리로", longitude: 126.613277, latitude: 36.891878))
            realm.add(CityLocationInfo(228, city1: "충청도", city2: "남세종로", longitude: 127.289448, latitude: 36.479522))
            realm.add(CityLocationInfo(229, city1: "충청도", city2: "노을3로", longitude: 127.258565, latitude: 36.47944))
            realm.add(CityLocationInfo(230, city1: "충청도", city2: "논산시", longitude: 127.1009111, latitude: 36.18420278))
            realm.add(CityLocationInfo(231, city1: "충청도", city2: "누리로", longitude: 127.252375, latitude: 36.475097))
            realm.add(CityLocationInfo(232, city1: "충청도", city2: "다솜1로", longitude: 127.254501, latitude: 36.516156))
            realm.add(CityLocationInfo(233, city1: "충청도", city2: "다정남로", longitude: 127.241922, latitude: 36.493402))
            realm.add(CityLocationInfo(234, city1: "충청도", city2: "다정동", longitude: 127.234917, latitude: 36.500442))
            realm.add(CityLocationInfo(235, city1: "충청도", city2: "다정북로", longitude: 127.255849, latitude: 36.49573))
            realm.add(CityLocationInfo(236, city1: "충청도", city2: "다정중앙로", longitude: 127.246898, latitude: 36.496682))
            realm.add(CityLocationInfo(237, city1: "충청도", city2: "단양군", longitude: 128.3678417, latitude: 36.98178056))
            realm.add(CityLocationInfo(238, city1: "충청도", city2: "달빛1로", longitude: 127.2463, latitude: 36.509374))
            realm.add(CityLocationInfo(239, city1: "충청도", city2: "달빛로", longitude: 127.25066, latitude: 36.508065))
            realm.add(CityLocationInfo(240, city1: "충청도", city2: "당진군", longitude: 127.684597, latitude: 36.881997))
            realm.add(CityLocationInfo(241, city1: "충청도", city2: "당진시", longitude: 126.6302528, latitude: 36.89075))
            realm.add(CityLocationInfo(242, city1: "충청도", city2: "대평로", longitude: 127.282581, latitude: 36.469407))
            realm.add(CityLocationInfo(243, city1: "충청도", city2: "도담동", longitude: 127.2623972, latitude: 36.51731111))
            realm.add(CityLocationInfo(244, city1: "충청도", city2: "도움1로", longitude: 127.247611, latitude: 36.502796))
            realm.add(CityLocationInfo(245, city1: "충청도", city2: "도움3로", longitude: 127.249982, latitude: 36.504689))
            realm.add(CityLocationInfo(246, city1: "충청도", city2: "마음로", longitude: 127.232222, latitude: 36.518492))
            realm.add(CityLocationInfo(247, city1: "충청도", city2: "마음안1로", longitude: 127.236121, latitude: 36.517357))
            realm.add(CityLocationInfo(248, city1: "충청도", city2: "마음안로", longitude: 127.236121, latitude: 36.517357))
            realm.add(CityLocationInfo(249, city1: "충청도", city2: "만남로", longitude: 127.160304, latitude: 36.822626))
            realm.add(CityLocationInfo(250, city1: "충청도", city2: "보듬2로", longitude: 127.265305, latitude: 36.51288))
            realm.add(CityLocationInfo(251, city1: "충청도", city2: "보듬3로", longitude: 127.265305, latitude: 36.51288))
            realm.add(CityLocationInfo(252, city1: "충청도", city2: "보듬4로", longitude: 127.265305, latitude: 36.51288))
            realm.add(CityLocationInfo(253, city1: "충청도", city2: "보람동", longitude: 127.28094, latitude: 36.478112))
            realm.add(CityLocationInfo(254, city1: "충청도", city2: "보람동로", longitude: 127.28094, latitude: 36.478112))
            realm.add(CityLocationInfo(255, city1: "충청도", city2: "보람로", longitude: 127.28094, latitude: 36.478112))
            realm.add(CityLocationInfo(256, city1: "충청도", city2: "보령시", longitude: 126.6148861, latitude: 36.330575))
            realm.add(CityLocationInfo(257, city1: "충청도", city2: "보은군", longitude: 127.7316083, latitude: 36.48653333))
            realm.add(CityLocationInfo(258, city1: "충청도", city2: "부강면", longitude: 127.370376, latitude: 36.527112))
            realm.add(CityLocationInfo(259, city1: "충청도", city2: "부여군", longitude: 126.9118639, latitude: 36.27282222))
            realm.add(CityLocationInfo(260, city1: "충청도", city2: "새롬남로", longitude: 127.254403, latitude: 36.479121))
            realm.add(CityLocationInfo(261, city1: "충청도", city2: "새롬동", longitude: 127.254403, latitude: 36.479121))
            realm.add(CityLocationInfo(262, city1: "충청도", city2: "새롬북로", longitude: 127.254403, latitude: 36.479121))
            realm.add(CityLocationInfo(263, city1: "충청도", city2: "새롬중앙로", longitude: 127.254403, latitude: 36.479121))
            realm.add(CityLocationInfo(264, city1: "충청도", city2: "서산시", longitude: 126.4521639, latitude: 36.78209722))
            realm.add(CityLocationInfo(265, city1: "충청도", city2: "서천군", longitude: 126.6938889, latitude: 36.07740556))
            realm.add(CityLocationInfo(266, city1: "충청도", city2: "소담동", longitude: 127.3000509, latitude: 36.488897))
            realm.add(CityLocationInfo(267, city1: "충청도", city2: "소정면", longitude: 127.1582525, latitude: 36.7223175))
            realm.add(CityLocationInfo(268, city1: "충청도", city2: "시청대로", longitude: 127.296956, latitude: 36.484202))
            realm.add(CityLocationInfo(269, city1: "충청도", city2: "아름동", longitude: 127.2482222, latitude: 36.51204167))
            realm.add(CityLocationInfo(270, city1: "충청도", city2: "아산시", longitude: 127.0046417, latitude: 36.78710556))
            realm.add(CityLocationInfo(271, city1: "충청도", city2: "연기군", longitude: 127.282781, latitude: 36.474616))
            realm.add(CityLocationInfo(272, city1: "충청도", city2: "연기면", longitude: 127.2737741, latitude: 36.5418737))
            realm.add(CityLocationInfo(273, city1: "충청도", city2: "연동면", longitude: 127.3268658, latitude: 36.5590889))
            realm.add(CityLocationInfo(274, city1: "충청도", city2: "연서면", longitude: 127.2716217, latitude: 36.592587))
            realm.add(CityLocationInfo(275, city1: "충청도", city2: "영동군", longitude: 127.7856111, latitude: 36.17205833))
            realm.add(CityLocationInfo(276, city1: "충청도", city2: "예산군", longitude: 126.850875, latitude: 36.67980556))
            realm.add(CityLocationInfo(277, city1: "충청도", city2: "옥천군", longitude: 127.5736333, latitude: 36.30355))
            realm.add(CityLocationInfo(278, city1: "충청도", city2: "음성군", longitude: 127.6926222, latitude: 36.93740556))
            realm.add(CityLocationInfo(279, city1: "충청도", city2: "장군면", longitude: 127.2056006, latitude: 36.4967934))
            realm.add(CityLocationInfo(280, city1: "충청도", city2: "전의면", longitude: 127.1955125, latitude: 36.6812513))
            realm.add(CityLocationInfo(281, city1: "충청도", city2: "절재로", longitude: 127.262509, latitude: 36.50843))
            realm.add(CityLocationInfo(282, city1: "충청도", city2: "제천시", longitude: 128.1931528, latitude: 37.12976944))
            realm.add(CityLocationInfo(283, city1: "충청도", city2: "조치원읍", longitude: 127.298399, latitude: 36.604528))
            realm.add(CityLocationInfo(284, city1: "충청도", city2: "종촌동", longitude: 127.247612, latitude: 36.5119569))
            realm.add(CityLocationInfo(285, city1: "충청도", city2: "증평군", longitude: 127.5832889, latitude: 36.78218056))
            realm.add(CityLocationInfo(286, city1: "충청도", city2: "진천군", longitude: 127.4376444, latitude: 36.85253889))
            realm.add(CityLocationInfo(287, city1: "충청도", city2: "천안시", longitude: 127.1524667, latitude: 36.804125))
            realm.add(CityLocationInfo(288, city1: "충청도", city2: "청양군", longitude: 126.8042556, latitude: 36.45626944))
            realm.add(CityLocationInfo(289, city1: "충청도", city2: "청원군", longitude: 127.431119, latitude: 36.549748))
            realm.add(CityLocationInfo(290, city1: "충청도", city2: "청주시", longitude: 127.5117306, latitude: 36.58399722))
            realm.add(CityLocationInfo(291, city1: "충청도", city2: "충주시", longitude: 127.9281444, latitude: 36.98818056))
            realm.add(CityLocationInfo(292, city1: "충청도", city2: "태안군", longitude: 126.299975, latitude: 36.74266667))
            realm.add(CityLocationInfo(293, city1: "충청도", city2: "한누리대로", longitude: 127.289926, latitude: 36.48545))
            realm.add(CityLocationInfo(294, city1: "충청도", city2: "홍성군", longitude: 126.6629083, latitude: 36.59836111))
            realm.add(CityLocationInfo(295, city1: "충청도", city2: "대전시", longitude: 127.3848616, latitude: 36.3506295))
//            Defaults.launchBefore = true
        }
    }
}
