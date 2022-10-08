//
//  MainView.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI
import SwiftUIPager

struct MainView: View {
    typealias VM = MainViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .leading) {
                    Topbar("날씨 정보", type: .none)
                    //TODO: more image 다운로드 후 적용 필요, 일단 임시로 글자로 함!
                    Text("지역 설정하기")
                        .font(.kr13r)
                        .foregroundColor(.gray100)
                        .onTapGesture {
                            vm.onClickSelectLocation()
                        }
                }
                card(geometry)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .background(Color.lightblue60)
        .ignoresSafeArea(.all)
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func card(_ geometry: GeometryProxy) -> some View {
        return Pager(page: $vm.page.wrappedValue, data: $vm.myLocations.wrappedValue.indices, id: \.self) { index in
            let location = $vm.myLocations.wrappedValue[index]
            if let info = $vm.weatherInfo.wrappedValue[location] {
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        HStack(alignment: .center, spacing: 0) {
                            Text(location.cityName)
                                .font(.kr30b)
                                .foregroundColor(.gray100)
                            Spacer()
                            Image("refresh")
                                .resizable()
                                .scaledToFit()
                                .frame(both: 20)
                        }
                        .padding([.leading, .trailing], 10)
                        
                        Divider()
                            .padding(12)
                        
                        //TODAY
                        title(info.current.dt.getDateAndTime())
                        
                        VStack(alignment: .leading, spacing: 6) {
                            todayWeather("temp", description: info.current.temp.KelToCel())
                            todayWeather("기압", description: "\(info.current.pressure)")
                            todayWeather("습도", description: "\(info.current.humidity) %")
                            todayWeather("체감온도", description: info.current.feels_like.KelToCel())
                            todayWeather("자외선 지수", description: "\(info.current.uvi)")
                            todayWeather("흐림", description: "\(info.current.clouds) %")
                            todayWeather("풍속", description: "\(info.current.wind_speed) m/s")
                            todayWeather("최저 기온", description: info.daily[0].temp.min.KelToCel())
                            todayWeather("최고 기온", description: info.daily[0].temp.max.KelToCel())
                        }
                        //Week
                        title("일주일 날씨")
                        Divider()
                            .padding(12)
                        ForEach(info.daily.indices, id: \.self) { index in
                            let daily = info.daily[index]
                            VStack(alignment: .leading, spacing: 6) {
                                todayWeather("날짜", description: daily.dt.getDateAndTime())
                                todayWeather("최저 기온", description: daily.temp.min.KelToCel())
                                todayWeather("최고 기온", description: daily.temp.max.KelToCel())
                                ForEach(daily.weather.indices, id: \.self) { idx in
                                    let weather = daily.weather[idx]
                                    todayWeather("날씨", description: weather.description)
                                    todayWeather("날씨", description: weather.icon)
                                    todayWeather("날씨", description: weather.main)
                                    todayWeather("날씨", description: "\(weather.id)")
                                }
                                todayWeather("풍속", description: "\(daily.wind_speed)")
                            }
                            Divider()
                                .padding(12)
                        }
                        Divider()
                            .padding(12)

                    }
                    .contentShape(Rectangle())
                }
                .padding(EdgeInsets(top: 20, leading: 12, bottom: 25, trailing: 12))
                .frame(width: geometry.size.width - 84, height: geometry.size.height - 150, alignment: .center)
    //            .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.dim.opacity(0.4))
                )
            }
        }
        .interactive(scale: 0.95)
        .interactive(opacity: 0.4)
        .sensitivity(.high)
        .preferredItemSize(CGSize(width: geometry.size.width - 60, height: 400))
        .contentShape(Rectangle())
    }
    
    private func todayWeather(_ title: String, description: String) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Text(title)
                .font(.kr14b)
                .foregroundColor(.gray100)
            Spacer()
            Text(description)
                .font(.kr14r)
                .foregroundColor(.gray90)
        }
    }
    
    private func title(_ title: String) -> some View {
        return Text(title)
            .font(.kr16b)
            .foregroundColor(.gray100)
            .padding(8)
    }
    
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView(vm: MainViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
        }
    }
}
#endif
