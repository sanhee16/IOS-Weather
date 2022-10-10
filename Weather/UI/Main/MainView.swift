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
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 20)
                            .onTapGesture {
                                vm.onClickGPS()
                            }
                            .padding(.trailing, 7)
                        Image("note")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 16)
                            .onTapGesture {
                                vm.onClickBoard()
                            }
                            .padding(.trailing, 7)
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
                    Spacer()
                    SandyProgressView()
                    Spacer()
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
                .foregroundColor(.white.opacity(0.9))
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
                                            .padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7))
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.gray100)
                                            )
                                    }
                                    Text(info.current.temp.KelToCel())
                                        .font(.kr45b)
                                        .foregroundColor(info.current.weather[0].icon.weatherType().textcolor)
                                        .padding(.bottom, 4)
                                    Text(location.cityName)
                                        .font(.kr26b)
                                        .foregroundColor(.gray100)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 3) {
                                    Image("refresh")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(both: 24)
                                        .onTapGesture {
                                            vm.onClickRefresh()
                                        }
                                        .padding(.bottom, 6)
                                    Text("마지막 업데이트 시간")
                                        .font(.kr9r)
                                        .foregroundColor(.gray90)
                                    Text(info.current.dt.getDateAndTime())
                                        .font(.kr9r)
                                        .foregroundColor(.gray60)
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
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(info.current.weather[0].description)
                                            .font(.kr20b)
                                            .foregroundColor(.gray100)
                                        Text(info.current.weather[0].icon.weatherType().description)
                                            .multilineTextAlignment(.leading)
                                            .font(.kr15r)
                                            .foregroundColor(.gray90)
                                    }
                                    .padding(8)
                                    Spacer()
                                    Image(info.current.weather[0].icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(both: 80)
                                }
                                .padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .gray30, radius: 7, x: 7, y: 7)
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 20, trailing: 0))
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    currentTempView(geometry, info: info)
                                    if $vm.isDetailViewCount.wrappedValue > 0 {
                                        currentExtraView(geometry, info: info)
                                    }
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
                            .padding(.bottom, 20)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 30))
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
    
    private func currentExtraView(_ geometry: GeometryProxy, info: WeatherResponse) -> some View {
        return VStack(alignment: .center, spacing: 4) {
            HStack(alignment: .center, spacing: 0) {
                if $vm.isOnPressure.wrappedValue.isOn {
                    extraItem(geometry, title: $vm.isOnPressure.wrappedValue.type.name, description: "\(info.current.pressure)")
                }
                if $vm.isOnHumidity.wrappedValue.isOn {
                    extraItem(geometry, title: $vm.isOnHumidity.wrappedValue.type.name, description: "\(info.current.humidity)%")
                }
                if $vm.isOnWindSpeed.wrappedValue.isOn {
                    extraItem(geometry, title: $vm.isOnWindSpeed.wrappedValue.type.name, description: info.current.wind_speed.windSpeed())
                }
            }
            HStack(alignment: .center, spacing: 0) {
                if $vm.isOnFeelLike.wrappedValue.isOn {
                    extraItem(geometry, title: $vm.isOnFeelLike.wrappedValue.type.name, description: info.current.feels_like.KelToCel())
                }
                if $vm.isOnUV.wrappedValue.isOn {
                    extraItem(geometry, title: $vm.isOnUV.wrappedValue.type.name, description: "\(info.current.uvi)")
                }
                if $vm.isOnCloud.wrappedValue.isOn {
                    extraItem(geometry, title: $vm.isOnCloud.wrappedValue.type.name, description: "\(info.current.clouds)%")
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0))
        .frame(width: geometry.size.width - 66 - 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white.opacity(0.4))
        )
        .frame(width: geometry.size.width - 66 - 24)
        .padding([.top, .bottom], 6)
    }
    
    private func extraItem(_ geometry: GeometryProxy, title: String, description: String) -> some View {
        let width = (geometry.size.width - 66 - 30 - 24) / 3
        return VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.kr14b)
                .foregroundColor(.gray100)
            Text(description)
                .font(.kr16r)
                .foregroundColor(.gray100)
        }
        .padding(8)
        .frame(width: width)
    }
    
    private func currentTempView(_ geometry: GeometryProxy, info: WeatherResponse) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            Spacer()
            tempItem(geometry, title: "최저 기온", description: info.daily[0].temp.min.KelToCel(), image: "min")
            Spacer()
            Divider()
                .padding([.top, .bottom], 6)
            Spacer()
            tempItem(geometry, title: "최고 기온", description: info.daily[0].temp.max.KelToCel(), image: "max")
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white.opacity(0.4))
        )
        .padding([.top, .bottom], 6)
    }
    
    private func tempItem(_ geometry: GeometryProxy, title: String, description: String, image: String) -> some View {
        return VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.kr14b)
                .foregroundColor(.gray100)
            HStack(alignment: .center, spacing: 5) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(both: 40)
                Text(description)
                    .font(.kr16r)
                    .foregroundColor(.gray100)
            }
        }
        .padding(8)
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
