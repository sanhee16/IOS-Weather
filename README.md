# hackerton1-weather

# 제1회 iOS 1인 해커톤 - 주제 : 날씨 앱

## 프로젝트 목적
OpenAPI를 사용해서 날씨 정보를 받아오는 ios 앱을 만든다

### 외부 package
- realm
    - 지역 정보들을 담기위해 local db로 선택  
- firestore(firebase)
   - 날씨 게시판으로 통신할 수 있도록 firestore사용  
- swiftUIPager
    - 날씨 상세페이지(main)에서 지역별로 카드형식으로 스와이프 되도록 사용  
- lottie
    - splash, progressView를 띄울 때 사용  
- alamofire
    - api 통신 위해 사용  

### 기술 및 패턴
- MVVM
    - view에서는 view만 그리고, viewModel에서는 로직만 처리한다. view는 viewModel의 데이터(변수)를 관찰하고(Observe) 있다가 데이터가 변환되면 view도 자동으로 감지하고 변환된다.
    - 참고 : [observable in swift](https://munokkim.medium.com/swiftui%EC%9D%98-observableobject-%EC%82%AC%EC%9A%A9%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95-18c7c50242b5)
    - 참고 : [mvvm](https://adevait.com/ios/swift-tutorial-mvvm-des)
- coordinator pattern
    - viewcontroller대신 페이지 전환을 담당하도록 (관심사 분리) coordinator 패턴 채택  
    - 참고 : [coordinator pattern](https://zeddios.medium.com/coordinator-pattern-bf4a1bc46930)
- SwiftUI, UIKit
    - swiftui를 주로 사용하고, swiftui로는 안되는 email쓰기, multiTextField 등은 UIKit 사용
- Swift
- Combine
    - api 통신에 사용



----
### 파일 구조
<img src="/readme-images/structure1.png" width="200"> <img src="/readme-images/structure2.png" width="200"> <img src="/readme-images/structure3.png" width="200">   
##### 구성
- UI
    - view, viewmodel, customView
    - 페이지에 따른 group별로 묶어져 있다.
    <details markdown="1">
    <summary> 예시 </summary>
    
    페이지 별로 그룹으로 묶어 관리하고, view와 viewController가 한 세트  
    - view : viewModel을 관찰하고 있다가, 데이터 변환이 일어나면 view를 업데이트 한다.
    ```swift
    // view 는 viewmodel을 observe한다.
    typealias VM = BoardMainViewModel
    @ObservedObject var vm: VM
    
    // viewmodel에 있는 weatherList 데이터의 변경이 일어나면 자동으로 view를 그린다.
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .center, spacing: 0) {
            ForEach($vm.weatherList.wrappedValue.indices, id: \.self) { idx in
                let item = $vm.weatherList.wrappedValue[idx]
                topMenuItem(geometry, title: item.name, isSelected: idx == $vm.selectedIdx.wrappedValue, idx: idx)
            }
        }
        .padding([.leading, .trailing], 4)
    }
    ```
    
    - viewModel: 로직을 관리한다. 로직에서 데이터 변경이 일어나면, view에서 업데이트를 한다.  
    - baseViewModel은 ObservableObject protocol을 채택하고, 모든 viewModel들은 baseViewModel을 상속기 때문에 view에서 관찰이 가능.    
    ```swift
    // 선언
    @Published var weatherList: [WeatherType] = []

    // 데이터 업데이트
    self.weatherList.append(self.currentWeatherType)
    for i in savedList {
        if i == self.currentWeatherType { continue }
        self.weatherList.append(i)
    }
    ```
- Data
    - DataClass, Api Response Structure
    - custom data class나, api 결과를 받을 때 필요한 structure들이 정의되어 있다.  

    <details markdown="1">
    <summary> 예시 </summary>
    
    데이터 통신을 위한 코드  
    codable protocol을 사용해서 encoding, decoding이 용이하도록 했다.  
    - api 호출시 json encode/decode 위한 data class
    ```swift
    public struct WeatherResponse: Codable {
        var current: Current // Current
        var daily: [Daily] // Weekly

        enum CodingKeys: String, CodingKey {
            case current
            case daily
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            current = try values.decode(Current.self, forKey: .current)
            daily = try values.decode([Daily].self, forKey: .daily)
        }
    }
    ```  
    - realm에 저장하는 class
    ```swift
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

    ```
    - 일반 enum
    ```swift
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

    ```
    
    - api 호출 시 사용
    ```swift
    func getWeather(_ apiKey: String, lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        let params = [
            "lat": lat,
            "lon": lon,
            "exclude": "minutely,hourly,alerts",
            "appid": apiKey,
            "lang": "kr",
            "units": "metric"
        ] as Parameters
        
        return get("/data/3.0/onecall", host: "https://api.openweathermap.org/", parameters: params)
            .flatMap { response in
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }

    ```

    </details>
- Commom
    - Util, Extension, Api, UserDefaults
    - 공통적으로 사용되는 util, extension등을 만들어 두었다.
- Base
    - BaseViewModel, BaseViewController
    - viewModel과 viewController들이 상속받는 base를 만들어 두었다.

    <details markdown="1">
    <summary> 예시 </summary>
    
    viewModel에는 화면 전환을 위한 cooridnator와 Api통신을 위한 subscription을 가지고 있다.
    
    - BaseViewModel
    ```swift
    weak var coordinator: AppCoordinator? = nil
    var subscription = Set<AnyCancellable>()
    ```

    </details>
- coordinator
    - BaseCoordinator
    - coordinator pattern의 base. viewcontroller 대신에 여기서 present,change,dismiss등을 담당한다.  
    - coordinator 가 어떤 viewController를 띄우고, 스택에서 없앨지 결정을 한다.  

    <details markdown="1">
    <summary> 예시 </summary>

    coordinator가 viewcontroller를 다루는 방식
    - 정의
    ```swift
    func present(_ viewController: UIViewController, animated: Bool = true, onDismiss: (() -> Void)? = nil) {
        if let baseViewController = viewController as? Dismissible {
            baseViewController.attachDismissCallback(completion: onDismiss)
        }
        
        self.presentViewController.present(viewController, animated: animated)
        self.childViewControllers.append(viewController)
    }
    func dismiss(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        if self.childViewControllers.isEmpty {
            completion?()
            return
        }

        weak var dismissedVc = self.childViewControllers.removeLast()
        dismissedVc?.dismiss(animated: animated) {
            if let baseViewController = dismissedVc as? Dismissible,
               let completion = baseViewController.completion {
                completion()
            }
            completion?()
        }
    }
    ```
    - 사용 예시
    ```swift
    // coordinator에 어떤 viewController를 present할지 정의를 해둔다.
    func presentWriteBoardView(type: WeatherType = .clearSky) {
        let vc = WriteBoardView.vc(self, type: type)
        self.present(vc, animated: true)
    }
    
    func presentSelectWeatherView(callback: @escaping (WeatherType) -> ()) {
        let vc = SelectWeatherView.vc(self, callback: callback)
        self.present(vc, animated: true)
    }
    
    ```
    ```swift
    // viewmodel에서 coordinator를 사용해서 호출
    self.coordinator?.presentSelectWeatherView() {[weak self] type in // 특정 viewController를 present
        self?.coordinator?.presentWriteBoardView(type: type)
    }
    self.coordinator?.dismiss(animated, completion: completion) // 해당 viewController를 dismiss
    ```

    </details>
- Delegate
    - AppDelegate, SceneDelegate
    - 앱의 life cycle을 관리하는 delegate들이 있다.  


----
### 페이지 정보
1. 스플래시
2. 날씨 세부 정보 페이지
3. 설정 페이지
4. 지역 선택 페이지  
5. 날씨별 게시판 페이지  

### 스플래시
앱 최초 실행시 진행 작업, 로딩  
- 기능
    - 앱 최초 실행시 알림 권한 받기
    - local data 저장  

- 사용된 주요 기술
    - timer: 2초 정도 lottie띄우고 메인으로 넘어감
    - realm: 처음 실행 시 local db에 지역 정보 insert
    - lottie: splash 이미지 대신 lottie 띄움  

### 날씨 세부 정보 페이지 / 메인페이지
스플래시를 지나면 나오는 페이지  
날씨 세부정보를 카드형식(pager)로 알 수 있고, 다른 페이지로 연결되는 메인 페이지  
- 표시정보  
    - 현재 온도, 위치, 마지막 업데이트 시간, 현재 날씨 아이콘, 현재 날씨 설명
    - 오늘 날씨 최저 기온, 최고 기온
    - 오늘 날씨 기압, 습도, 풍속, 체감온도, 자외선, 흐림정도
    - 3시간 별 날씨 : 날짜(일/시간), 날씨 아이콘, 온도
    - 일주일 날씨 : 날짜(일), 날씨 아이콘, 날씨 정보, 풍속, 강수량, 최고기온, 최저기온  
    
- 기능
    - 날씨 새로고침
    - 스와이프로 선택한 지역 날씨 교체 가능
    - 현재위치 표시
    - 마지막 카드, 상단좌측 버튼에서 날씨 추가 가능
    - 설정페이지 이동
    - 현재 날씨 정보 허용
    - 날씨 게시판 이동  
    
- 사용된 주요 기술
    - pager: 카드 형식의 날씨 정보에 사용
    - combine: api 호출 시 사용
    - alamofire: api 호출해서 정보 받아옴
    - realm: 저장된 지역이 무엇이 있는지 확인한 후 정보 받아옴

### 설정 페이지
앱 설정 페이지  
앱 권한 관련, 앱 기능 관련을 확인할 수 있고, 앱 정보를 알 수 있다.  
- 기능
    - 현재 위치 정보 사용 on/off
    - 날씨 알림(notification) on/off
    - 날씨 알림 on 일 때, 날씨 알림 시간 설정
    - 날씨 세부 정보 표시 설정(on/off) : 기압, 습도, 풍속, 체감온도, 자외선, 흐림정도
    - 현재 앱 권한 사용여부 확인 -> 앱 설정페이지 이동 가능
    - 문의하기 -> email 전송
    - 개발자 정보 표시
    - 개인정보 처리 방침 표시

- 사용된 주요 기술
    - notification: 알림 설정 on/off 할 때 사용
    - userDefaults: 설정 정보(세부 날씨 표시, 알림 사용 여부, 현재위치 사용 여부 등)의 정보를 기록
    
### 지역 선택 페이지  
사전에 지정해둔 지역 중에서 선택할 수 있고, 사용자가 지역을 삭제/추가 할 수 있다.  
- 기능
    - 지역 추가  
    - 설정해둔 지역 삭제  

- 사용된 주요 기술
    - realm: 저장된 지역 불러오기, 사용자가 설정한 지역 삭제 및 추가시 realm DB에 저장  

### 날씨별 게시판 페이지
날씨 별로 유저들이 게시글을 올릴 수 있음. 커뮤니티성으로 음식, 장소, 음악, 옷차림, 활동등의 추천 정보를 올릴 수 있다.  
- 기능
    - 날씨별 게시판 조회
    - 게시글 쓰기  
    
- 사용된 주요 기술
    - firebase(firestore): fireStore사용해서 게시글 올리고, list 받아올 수 있음.  

----

### Trouble Shooting
1. realm 삭제 이슈  
<b>[문제]</b> realm은 객체를 받아서 db를 구성하는데, 삭제할 때 데이터는 지웠지만 참조가 끊어지지 않아 없는 값을 가리키는 참조 이슈가 발생해서 메모리관련 에러가 발생했다.  
<b>[해결방안]</b> 데이터를 추가할 때 객체를 넣지 않고 객체의 복사본을 넣어주는 방식으로 해결했다.   

<문제>
```swift
try! realm.write {
    self.realm.add(MyLocation.self, value: MyLocation(idx, cityName: "\(item.location.city1) \(item.location.city2)", indexOfDB: item.location.idx, longitude: item.location.longitude, latitude: item.location.latitude))
}
```
<해결>
```swift
try! realm.write {
    let copy = self.realm.create(MyLocation.self, value: MyLocation(idx, cityName: "\(item.location.city1) \(item.location.city2)", indexOfDB: item.location.idx, longitude: item.location.longitude, latitude: item.location.latitude))
    self.realm.add(copy)
}
```

2. 권한요청 결과값 받기  
<b>[문제]</b> 권한 요청을 하면 요청이 완료되었을 때 콜백이 날라오지 않아서 여러개의 permission이 한 번에 뜨거나, splash에서 받으면 permission 창이 있는데 main page로 넘어가는 이슈가 있었다.  
<b>[해결방안]</b> timer를 돌려서 요청상태를 확인 한 후, 거부/승인 등의 결과가 날라오면 다음 로직을 처리하도록 했다.


### 해커톤 이후 남은 일
- localization
    - 한국어로만 되어있는 부분을 localization 처리 필요
    - string, date 등 지역 감지 해서 지역에 맞게 변환되도록 처리
- 부가 날씨 정보 list형식으로 변경
    - 표시되는 날씨 정보를 선택할 수 있는데, list형식으로 되어있지 않아서 forEach로 했을 때 0...2, 3...6 방식으로 처리되어 ui 가 좋지 않음. list 형식으로 변환 필요
- 지역 선택 변경
    - 지역 선택을 한국의 시/군/구의 위도, 경도 정보를 local에 직접 저장하도록 되어있는데, 방식 변경 필요
    - 지역을 검색하면 위도, 경도를 알 수 있는 openAPI를 찾아서, 연동하는 과정이 필요할 것 같다.
    - 이때 언어별 지원이 되는지도 알아봐야 함
- 게시판 기능 보완
    - 신고기능 넣기: apple 정책에 따라, 커뮤니티 기능이 있으면 신고 기능이 있어야 함.
    - 로그인 기능 추가
    - 내 글 보기: 현재는 익명으로 되어있어서, 로그인 기능후에는 내 글 보기가 가능해지도록
    - 내 글 수정 및 삭제
    - 카테고리 추가: 음식, 장소, 잡담, 음악, 영상, 의상 등의 카테고리로 나누어서 글을 올릴 수 있도록
    - 이미지 추가: 이미지 업로드가 가능하도록
- 개발자 정보를 WebView로 변경
    - code update가 없이도 볼 수 있도록 webView로 변경하는 작업 필요










