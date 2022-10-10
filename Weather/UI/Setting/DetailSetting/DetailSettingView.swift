//
//  DetailSettingView.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//


import SwiftUI

struct DetailSettingView: View {
    typealias VM = DetailSettingViewModel
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
                Topbar("날씨 세부 설정", type: .back) {
                    vm.onClose()
                }
                .padding(.bottom, 10)
                itemView($vm.isOnFeelLike)
                itemView($vm.isOnWindSpeed)
                itemView($vm.isOnPressure)
                itemView($vm.isOnHumidity)
                itemView($vm.isOnUV)
                itemView($vm.isOnCloud)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func itemView(_ item: Binding<DetailItem>) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                let title = item.wrappedValue.type.name
                Text(title)
                    .font(.kr16b)
                    .foregroundColor(.gray100)
                Spacer()
                let isOn = item.wrappedValue.isOn
                Text(isOn ? "ON" : "OFF")
                    .font(.kr16r)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 30, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(isOn ? .green.opacity(0.9) : .red.opacity(0.9))
                            .shadow(color: .gray60, radius: 4, x: 2, y: 4)
                    )
                    .onTapGesture {
                        vm.updateStatus(item.wrappedValue.type)
                    }
            }
            Divider()
                .padding(.top, 12)
        }
        .padding(EdgeInsets(top: 6, leading: 22, bottom: 6, trailing: 22))
    }
}
