//
//  WriteBoardView.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//

import SwiftUI

struct WriteBoardView: View {
    typealias VM = WriteBoardViewModel
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
                Topbar("새 글 쓰기", type: .back) {
                    vm.onClose()
                }
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView {
                        MultilineTextField($vm.content.wrappedValue.isEmpty ? "내용을 입력하세요." : "", text: $vm.content) {
                            
                        }
                        .font(.kr14r)
                        .contentShape(Rectangle())
                        .accentColor(.lightGray01)
                        .keyboardType(.default)
                    }
                    .padding(.bottom, $vm.keyboardHeight.wrappedValue)
                }
                .padding([.leading, .trailing], 10)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}
