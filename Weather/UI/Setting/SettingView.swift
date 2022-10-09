//
//  SettingView.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//

import SwiftUI

struct SettingView: View {
    typealias VM = SettingViewModel
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
            VStack(alignment: .leading, spacing: 0) {
                Topbar("설정", type: .back) {
                    vm.onClose()
                }
                title("앱 설정")
                if $vm.isAvailableGPSToggle.wrappedValue {
                    toggleItem("현재 위치정보 사용", description: "현재 위치정보를 사용하면 현재 위치의 날씨를 알 수 있습니다.", isOn: $vm.isUseGps)
                } else {
                    toggleItem("현재 위치정보 사용", description: "현재 위치정보를 사용하면 현재 위치의 날씨를 알 수 있습니다.", isOn: $vm.isUseGps, disableTap: vm.onClickGPSToggle)
                }
                
                if $vm.isAvailableGPSToggle.wrappedValue && $vm.isUseGps.wrappedValue {
                    toggleItem("날씨 알림", description: "현재 위치정보를 사용하면 매일 날씨 알람을 받을 수 있습니다.\n단, 알림 허용이 되어있어야 하고, 현재 위치정보를 사용하고 있어야 합니다.", isOn: $vm.isUseNoti)
                    if $vm.isUseNoti.wrappedValue {
                        subItem("알림 시간 설정하기", description: $vm.displayTime.wrappedValue, onTap: vm.onClickNotiTimeSetting)
                    }
                }
                
                title("정보")
                basicItem("문의하기", onTap: vm.onClickContact)
                basicItem("개발자 정보", onTap: vm.onclickDevInfo)
                basicItem("개인 정보 처리 방침", onTap: vm.onClickPolicy)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func title(_ title: String) -> some View {
        return Text(title)
            .font(.kr12b)
            .foregroundColor(.gray100)
            .padding(EdgeInsets(top: 16, leading: 20, bottom: 4, trailing: 7))
    }
    
    private func toggleItem(_ title: String, description: String? = nil, isOn: Binding<Bool>, disableTap: (()->())? = nil) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.kr13r)
                        .foregroundColor(.gray100)
                    if let description = description {
                        Text(description)
                            .font(.kr11r)
                            .foregroundColor(.gray60)
                    }
                }
                Spacer()
                Toggle("", isOn: isOn)
                    .labelsHidden()
                    .contentShape(Rectangle())
                    .toggleStyle(
                        SettingToggle()
                    )
                    .disabled(disableTap == nil ? false : true)
                    .onTapGesture {
                        if let disableTap = disableTap {
                            disableTap()
                        }
                    }
            }
            .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
            Divider()
                .padding([.leading, .trailing], 12)
        }
    }
    
    private func subItem(_ title: String, description: String? = nil, onTap: (() -> ())? = nil) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.kr13r)
                        .foregroundColor(.gray100)
                    if let description = description {
                        Text(description)
                            .font(.kr11r)
                            .foregroundColor(.gray60)
                    }
                }
                Spacer()
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 14)
            }
            .padding(EdgeInsets(top: 9, leading: 25, bottom: 9, trailing: 25))
            Divider()
                .padding([.leading, .trailing], 12)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let onTap = onTap {
                onTap()
            }
        }
    }
    
    private func basicItem(_ title: String, description: String? = nil, onTap: (() -> ())? = nil) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.kr13r)
                        .foregroundColor(.gray100)
                    if let description = description {
                        Text(description)
                            .font(.kr11r)
                            .foregroundColor(.gray60)
                    }
                }
                Spacer()
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(both: 14)
            }
            .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
            Divider()
                .padding([.leading, .trailing], 12)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let onTap = onTap {
                onTap()
            }
        }
    }
    
    
    struct SettingToggle: ToggleStyle {
        private let width = 40.0
        private let height = 22.0
        
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.label
                ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: width, height: height)
                        .foregroundColor(configuration.isOn ? .green : .gray60)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: (width / 2) - 4, height: height - 6)
                        .padding(4)
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                configuration.$isOn.wrappedValue.toggle()
                            }
                        }
                }
            }
        }
    }
}
