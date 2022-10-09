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
                    HStack(alignment: .center, spacing: 0) {
                        Text("지역 설정")
                            .font(.kr13r)
                            .foregroundColor(.gray100)
                            .onTapGesture {
                                vm.onClickSelectLocation()
                            }
                        Spacer()
                        Image("setting")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 18)
                            .onTapGesture {
                                vm.onClickSetting()
                            }
                    }
                    .padding([.leading, .trailing], 20)
                }
                if $vm.isLoading.wrappedValue {
                    ProgressView()
                } else {
                    card(geometry)
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .background($vm.backgroundColor.wrappedValue)
        .ignoresSafeArea(.all)
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func weeklyItem(_ geometry: GeometryProxy, item: Daily) -> some View {
        return VStack(alignment: .center, spacing: 4) {
            Text(item.dt.getDate())
                .font(.kr14r)
                .foregroundColor(.gray90)
            Image(item.weather[0].icon)
                .resizable()
                .scaledToFit()
                .frame(both: 45)
                .padding([.top, .bottom], 3)
            Text(item.weather[0].description)
                .font(.kr12r)
                .foregroundColor(.red100)
            HStack(alignment: .center, spacing: 4) {
                HStack(alignment: .center, spacing: 2) {
                    Image("wind")
                        .resizable()
                        .scaledToFit()
                        .frame(both: 13)
                    Text(item.wind_speed.windSpeed())
                        .font(.kr12r)
                        .foregroundColor(.gray90)
                }
                HStack(alignment: .center, spacing: 1) {
                    Image("water")
                        .resizable()
                        .scaledToFit()
                        .frame(both: 14)
                    Text(item.pop.pop())
                        .font(.kr12r)
                        .foregroundColor(.lightblue100)
                }
            }
            HStack(alignment: .center, spacing: 8) {
                Text(item.temp.min.KelToCel())
                    .font(.kr12r)
                    .foregroundColor(.blue100)
                Text(item.temp.max.KelToCel())
                    .font(.kr12r)
                    .foregroundColor(.red100)
            }
        }
        .frame(width: 120, height: 140, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white.opacity(0.8))
        )
    }
    
    private func card(_ geometry: GeometryProxy) -> some View {
        return Pager(page: $vm.page.wrappedValue, data: $vm.myLocations.wrappedValue.indices, id: \.self) { index in
            let location = $vm.myLocations.wrappedValue[index]
            if location.idx == -1 {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("+")
                        .font(.kr30b)
                        .foregroundColor(.gray90)
                        .onTapGesture {
                            vm.onClickSelectLocation()
                        }
                    Spacer()
                }
                .frame(width: geometry.size.width - 66, height: geometry.size.height - 150, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(.dim.opacity(0.4))
                )
            } else {
                if let info = $vm.weatherInfo.wrappedValue[location] {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                VStack(alignment: .leading, spacing: 6) {
                                    if location.indexOfDB == nil {
                                        Text("현재 위치")
                                            .font(.kr11r)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.gray90)
                                            )
                                    }
                                    Text(location.cityName)
                                        .font(.kr26b)
                                        .foregroundColor(.gray100)
                                }
                                Spacer()
                                VStack(alignment: .center, spacing: 2) {
                                    Text("업데이트 시간")
                                        .font(.kr9r)
                                        .foregroundColor(.gray60)
                                    Text(info.current.dt.getDateAndTime())
                                        .font(.kr9r)
                                        .foregroundColor(.gray60)
                                }
                                .padding(.trailing, 6)
                                Image("refresh")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(both: 20)
                                    .onTapGesture {
                                        vm.onClickRefresh()
                                    }
                            }
                            Divider()
                                .padding(.top, 12)
                        }
                        .padding(EdgeInsets(top: 20, leading: 22, bottom: 0, trailing: 22))
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                //TODAY
                                HStack(alignment: .center, spacing: 0) {
                                    Text(info.current.weather[0].description)
                                        .font(.kr20b)
                                        .foregroundColor(.gray100)
                                        .padding(8)
                                    Spacer()
                                    Image(info.current.weather[0].icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(both: 80)
                                }
                                .padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    todayWeather("temp", description: info.current.temp.KelToCel())
                                    todayWeather("기압", description: "\(info.current.pressure)")
                                    todayWeather("습도", description: "\(info.current.humidity) %")
                                    todayWeather("체감온도", description: info.current.feels_like.KelToCel())
                                    todayWeather("자외선 지수", description: "\(info.current.uvi)")
                                    todayWeather("흐림", description: "\(info.current.clouds) %")
                                    todayWeather("풍속", description: info.current.wind_speed.windSpeed())
                                    todayWeather("최저 기온", description: info.daily[0].temp.min.KelToCel())
                                    todayWeather("최고 기온", description: info.daily[0].temp.max.KelToCel())
                                }
                                
                                Divider()
                                    .padding(12)
                            }
                            .padding(EdgeInsets(top: 20, leading: 12, bottom: 4, trailing: 12))
                            //Week
                            title("일주일 날씨")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .center, spacing: 14) {
                                    ForEach(info.daily.indices, id: \.self) { index in
                                        let daily = info.daily[index]
                                            weeklyItem(geometry, item: daily)
                                    }
                                }
                                .padding(EdgeInsets(top: 12, leading: 12, bottom: 25, trailing: 12))
                            }
                            .shadow(color: .gray30, radius: 10, x: 10, y: 10)
                        }
                        .contentShape(Rectangle())
                    }
                    .frame(width: geometry.size.width - 66, height: geometry.size.height - 150, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.dim.opacity(0.4))
                    )
                }
            }
        }
        .interactive(scale: 0.96)
        .interactive(opacity: 0.2)
        .sensitivity(.high)
        .preferredItemSize(CGSize(width: geometry.size.width - 52, height: 400))
        .onPageChanged({ index in
            vm.onPageChanged(index)
        })
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
