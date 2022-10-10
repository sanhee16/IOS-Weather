//
//  NotiSettingView.swift
//  Weather
//
//  Created by sandy on 2022/10/09.
//

import SwiftUI

struct NotiSettingView: View {
    typealias VM = NotiSettingViewModel
    public static func vc(_ coordinator: AppCoordinator, callback: ((Bool)-> Void)?) -> UIViewController {
        let vm = VM.init(coordinator, callback: callback)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        vc.controller.view.backgroundColor = UIColor.dim
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            DatePicker("", selection: $vm.currentDate, displayedComponents: .hourAndMinute)
                .labelsHidden()
            HStack(alignment: .center, spacing: 0) {
                Text("OK")
                    .font(.kr16r)
                    .foregroundColor(.gray90)
                    .frame(width: (UIScreen.main.bounds.width - 100)/2)
                    .onTapGesture {
                        vm.onClickOK()
                    }
                Text("Cancel")
                    .font(.kr16r)
                    .foregroundColor(.gray60)
                    .frame(width: (UIScreen.main.bounds.width - 100)/2)
                    .onTapGesture {
                        vm.onClickCancel()
                    }
            }
            .padding([.top, .bottom], 10)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .foregroundColor(Color.white)
        )
        .onAppear {
            vm.onAppear()
        }
    }
}
