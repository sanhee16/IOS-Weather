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
- coordinator pattern
    - viewcontroller대신 페이지 전환을 담당하도록 (관심사 분리) coordinator 패턴 채택  
- SwiftUI, UIKit
    - swiftui를 주로 사용하고, swiftui로는 안되는 email쓰기, multiTextField 등은 UIKit 사용
- Swift
- Combine
    - api 통신에 사용

### 페이지 정보
1. 날씨 정보 페이지
2. 설정 페이지
3. 지역 선택 페이지
4. 날씨별 게시판 페이지

### 파일 구조
<img src="/readme-images/structure1.png" width="200"> <img src="/readme-images/structure2.png" width="200"> <img src="/readme-images/structure3.png" width="200">   
##### 구성
- UI
    - view, viewmodel, customView
    - 페이지에 따른 group별로 묶어져 있다.
- Data
    - DataClass, Api Response Structure
    - custom data class나, api 결과를 받을 때 필요한 structure들이 정의되어 있다.
- Commom
    - Util, Extension, Api, UserDefaults
    - 공통적으로 사용되는 util, extension등을 만들어 두었다.
- Base
    - BaseViewModel, BaseViewController
    - viewModel과 viewController들이 상속받는 base를 만들어 두었다.
- coordinator
    - BaseCoordinator
    - coordinator pattern의 base. viewcontroller 대신에 여기서 present,change,dismiss등을 담당한다.
- Delegate
    - AppDelegate, SceneDelegate
    - 앱의 life cycle을 관리하는 delegate들이 있다.  




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










