//
//  BoardMainView.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//


import SwiftUI

struct BoardMainView: View {
    typealias VM = BoardMainViewModel
    public static func vc(_ coordinator: AppCoordinator, weatherType: WeatherType, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, weatherType: weatherType)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    
    @State private var addImagePosition: CGRect = .zero
    @State private var addImage: CGRect = .zero
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Topbar("보드", type: .back) { // 이 날씨에 뭐하지?
                    vm.onClose()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach($vm.weatherList.wrappedValue.indices, id: \.self) { idx in
                            let item = $vm.weatherList.wrappedValue[idx]
                            topMenuItem(geometry, title: item.name, isSelected: idx == $vm.selectedIdx.wrappedValue, idx: idx)
                        }
                    }
                    .padding([.leading, .trailing], 4)
                }
                if $vm.isLoading.wrappedValue {
                    Spacer()
                    SandyProgressView()
                    Spacer()
                } else {
                    ZStack(alignment: .topLeading) {
                        drawBody(geometry)
                            .rectReader($addImagePosition, in: .named("MainSpace"))
                        addButton(geometry)
                            .rectReader($addImage, in: .global)
                            .offset(
                                x: ($addImagePosition.wrappedValue.origin.x + $addImagePosition.wrappedValue.size.width) -
                                ($addImage.wrappedValue.size.width + 50),
                                y: ($addImagePosition.wrappedValue.origin.y + $addImagePosition.wrappedValue.size.height) -
                                ($addImage.wrappedValue.size.height + 40)
                            )
                    }
                    .coordinateSpace(name: "MainSpace")
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func addButton(_ geometry: GeometryProxy) -> some View {
        return Image("add")
            .resizable()
            .scaledToFit()
            .frame(both: 32)
            .padding(16)
            .background(
                Circle()
                    .foregroundColor(.blue100)
                    .shadow(color: .gray30, radius: 10, x: 3, y: 4)
            )
    }
    private func drawBody(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach($vm.allData.wrappedValue.indices, id: \.self) { idx in
                        if $vm.allData.wrappedValue[idx].type == $vm.weatherList.wrappedValue[$vm.selectedIdx.wrappedValue].rawValue {
                            boardItem(geometry, item: $vm.allData.wrappedValue[idx])
                        }
                    }
                }
                .padding([.top, .bottom], 20)
                .frame(width: geometry.size.width)
            }
        }
    }
    
    private func boardItem(_ geometry: GeometryProxy, item: Board) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text(item.text)
                .font(.kr16r)
                .foregroundColor(.gray90)
                .padding(.bottom, 10)
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Text(item.getDate())
                    .font(.kr13r)
                    .foregroundColor(.gray60)
            }
        }
        .padding(EdgeInsets(top: 14, leading: 18, bottom: 14, trailing: 18))
        .frame(width: geometry.size.width - 40)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.lightGray03)
                .shadow(color: .gray30.opacity(0.6), radius: 4, x: 2, y: 6)
        )
    }
    
    private func topMenuItem(_ geometry: GeometryProxy, title: String, isSelected: Bool, idx: Int) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            Text(title)
                .font(isSelected ? .kr15b : .kr15r)
                .foregroundColor(isSelected ? .gray100 : .gray60)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
//            }
        }
        .onTapGesture {
            vm.onChangeWeatherMenu(idx)
        }
    }
}
