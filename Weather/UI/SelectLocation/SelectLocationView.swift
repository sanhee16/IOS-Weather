//
//  SelectLocationView.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI
import SwiftUIPager

struct SelectLocationView: View {
    typealias VM = SelectLocationViewModel
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
                Topbar("지역 선택", type: .close) {
                    vm.onClose()
                }
                if $vm.isLoading.wrappedValue {
                    SandyProgressView()
                } else {
                    //TODO: myLocation = pager로 구현할꺼!
                    HStack(alignment: .center, spacing: 0) {
                        Text("내가 추가한 지역")
                            .font(.kr15b)
                            .foregroundColor(.gray100)
                        if $vm.isEditing.wrappedValue {
                            Text("삭제중")
                                .font(.kr11r)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.gray60)
                                )
                                .padding(.leading, 6)
                            Spacer()
                            if $vm.deleteCnt.wrappedValue > 0 {
                                Text("삭제하기")
                                    .font(.kr14r)
                                    .foregroundColor(.gray100)
                                    .onTapGesture {
                                        vm.onClickAdmitEdit()
                                    }
                            }
                            Text("취소")
                                .font(.kr14r)
                                .foregroundColor(.gray60)
                                .padding(.leading, 12)
                                .onTapGesture {
                                    vm.onClickCancelEdit()
                                }
                        } else {
                            Spacer()
                            if !$vm.myLocations.wrappedValue.isEmpty {
                                Text("편집하기")
                                    .font(.kr14r)
                                    .foregroundColor(.gray100)
                                    .onTapGesture {
                                        vm.onClickEdit()
                                    }
                            }
                        }
                    }
                    .frame(width: geometry.size.width - 40, height: 50, alignment: .center)
                    
                    if !$vm.myLocations.wrappedValue.isEmpty {
                        myLocationView(geometry)
                    }
                    //TODO: 전체 location은 scrollView?
                    Divider()
                        .padding(20)
                    HStack(alignment: .center, spacing: 0) {
                        Text("지역 추가하기")
                            .font(.kr15b)
                            .foregroundColor(.gray100)
                        Spacer()
                        if $vm.selectedLocation.wrappedValue != nil {
                            Text("추가하기")
                                .font(.kr13r)
                                .foregroundColor(.gray90)
                                .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                                .border(.darkblue60, lineWidth: 2, cornerRadius: 8)
                                .onTapGesture {
                                    vm.addToMyLocation()
                                }
                        }
                    }
                    .frame(width: geometry.size.width - 40, height: 50, alignment: .center)
                    selectCity(geometry)
                    if $vm.selectedCityIdx.wrappedValue != nil, $vm.specificLocations.wrappedValue.count > 0 {
                        Divider()
                            .padding(6)
                        selectLocation(geometry)
                    }
                }
                
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func myLocationView(_ geometry: GeometryProxy) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 12) {
                ForEach($vm.myLocations.wrappedValue.indices, id: \.self) { idx in
                    let item = $vm.myLocations.wrappedValue[idx]
                    myLocationItem(geometry, item: item)
                        .onTapGesture {
                            vm.addToDeleteList(item)
                        }
                }
            }
            .padding(EdgeInsets(top: 14, leading: 20, bottom: 6, trailing: 20))
        }
    }
    
    private func myLocationItem(_ geometry: GeometryProxy, item: Location) -> some View {
        return HStack(alignment: .center, spacing: 4) {
            if item.loc.indexOfDB == nil {
                Image("location")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 12)
            }
            Text(item.loc.cityName)
                .font(.kr16r)
                .foregroundColor(.gray100)
                .multilineTextAlignment(.center)
                .lineSpacing(1.4)
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .border(.lightblue80, lineWidth: item.editing ? 0 : 2, cornerRadius: 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(item.editing ? .lightblue100 : .clear)
        )
    }
    
    
    private func selectLocation(_ geometry: GeometryProxy) -> some View {
        return ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 15), count: 4), spacing: 6) {
                ForEach($vm.specificLocations.wrappedValue.indices, id: \.self) { idx in
                    let item = $vm.specificLocations.wrappedValue[idx]
                    locationItem(geometry, name: item.location.city2, isSelected: item.selectedStatus) {
                        vm.selectLocation(item)
                    }
                }
            }
            .padding(16)
        }
    }
    
    private func selectCity(_ geometry: GeometryProxy) -> some View {
        return LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 15), count: 4), spacing: 6) {
            ForEach($vm.cityList.wrappedValue.indices, id: \.self) { idx in
                let item = $vm.cityList.wrappedValue[idx]
                let isSelected: SeletedStatus = $vm.selectedCityIdx.wrappedValue == idx ? .selected : .none
                locationItem(geometry, name: item, isSelected: isSelected) {
                    vm.selectCity(idx)
                }
            }
        }
        .padding(16)
    }
    
    private func locationItem(_ geometry: GeometryProxy, name: String, isSelected: SeletedStatus, onTap: (() -> ())? = nil) -> some View {
        let width = (geometry.size.width - 32) / 4 - 15
        return Text(name)
            .font(.kr16r)
            .foregroundColor(isSelected.textColor)
            .multilineTextAlignment(.center)
            .frame(width: width, height: 36, alignment: .center)
            .border(isSelected.borderColor, lineWidth: 2, cornerRadius: 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isSelected.backgroundColor)
            )
            .onTapGesture {
                if let onTap = onTap {
                    onTap()
                }
            }
    }
}
