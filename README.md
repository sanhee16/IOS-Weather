# hackerton1-weather

# 제1회 iOS 1인 해커톤 - 주제 : 날씨 앱

## 프로젝트 목적
OpenAPI를 사용해서 날씨 정보를 받아오는 ios 앱을 만든다

### 외부 package
- realm
- firestore(firebase)
- swiftUIPager
- lottie
- alamofire

### 기술 및 패턴
- MVVM
- coordinator pattern
- SwiftUI
- Swift
- Combine

### 페이지 정보
1. 날씨 정보 페이지
2. 설정 페이지
3. 지역 선택 페이지
4. 날씨별 게시판 페이지

### 파일 구조
<img src="/readme-images/structure1.png">
<img src="/readme-images/structure2.png">
<img src="/readme-images/structure3.png">


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
