//
//  SendEmailView.swift
//  Weather
//
//  Created by sandy on 2022/10/08.
//


import SwiftUI
import MessageUI

struct SendEmailView: View {
    typealias VM = SendEmailViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Topbar("메일 보내기", type: .close) {
                    vm.onClose()
                }
                VStack {
                    if MFMailComposeViewController.canSendMail() {
                        Button("Show mail view") {
                            self.isShowingMailView.toggle()
                        }
                    } else {
                        Text("Can't send emails from this device")
                    }
                    if result != nil {
                        Text("Result: \(String(describing: result))")
                            .lineLimit(nil)
                    }
                }
                .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$result)
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
}
