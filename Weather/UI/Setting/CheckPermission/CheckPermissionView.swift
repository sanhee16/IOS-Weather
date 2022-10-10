//
//  CheckPermissionView.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//


import SwiftUI

struct CheckPermissionView: View {
    typealias VM = CheckPermissionViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        vc.controller.view.backgroundColor = UIColor.dim
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .center) {
                Topbar("권한 설정 여부", type: .close) {
                    vm.onClose()
                }
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Image("refresh")
                        .resizable()
                        .scaledToFit()
                        .frame(both: 20)
                        .onTapGesture {
                            vm.onAppear()
                        }
                        .padding(.trailing, 6)
                }
            }
            Text("원활한 기능 사용을 위해 모든 권한을 항상 허용으로 바꾸는 것을 권장합니다.\n권한 허용은 설정에서 바꿀 수 있습니다.")
                .multilineTextAlignment(.center)
                .font(.kr9r)
                .foregroundColor(.gray60)
                .padding(.bottom, 12)
            VStack(alignment: .leading, spacing: 0) {
                itemView("위치 정보 항상 사용", description: "앱 사용 중에 허용을 하면 항상 현재 위치의 날씨를 받아 올 수 있습니다.\n위치 정보는 수집하지 않습니다.", isOn: $vm.location)
                Divider()
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                itemView("알림 항상 사용", description: "정해진 시간에 날씨 알림을 받을 수 있습니다.\n단, 위치정보를 사용하고 있어야 합니다.", isOn: $vm.noti)
            }
            
            Text("설정에서 권한 변경하기")
                .font(.kr18r)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 120, height: 50, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(.blue100)
                        .shadow(color: .gray60, radius: 8, x: 2, y: 8)
                )
                .padding(.top, 20)
                .onTapGesture {
                    vm.moveToSettingUrl()
                }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
        .frame(width: UIScreen.main.bounds.width - 80, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .foregroundColor(Color.white)
        )
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func itemView(_ title: String, description: String?, isOn: Binding<Bool>) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(title)
                    .font(.kr16b)
                    .foregroundColor(.gray100)
                Spacer()
                let isOn = isOn.wrappedValue
                Text(isOn ? "ON" : "OFF")
                    .font(.kr16r)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 30, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(isOn ? .green.opacity(0.9) : .red.opacity(0.9))
                    )
            }
            if let description = description {
                Text(description)
                    .font(.kr12r)
                    .foregroundColor(.gray60)
                    .padding(.top, 10)
            }
        }
        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
    }
}

