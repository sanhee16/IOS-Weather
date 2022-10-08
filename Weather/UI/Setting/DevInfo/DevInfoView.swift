//
//  DevInfoView.swift
//  Weather
//
//  Created by sandy on 2022/10/08.
//


import SwiftUI

struct DevInfoView: View {
    typealias VM = DevInfoViewModel
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
                Topbar("개발자 정보", type: .back) {
                    vm.onClose()
                }
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        Text("Sandy")
                            .font(.kr16b)
                            .foregroundColor(.gray100)
                        Spacer()
                        Image("sandy")
                            .resizable()
                            .scaledToFit()
                            .frame(both: 50)
                            .clipShape(Circle())
                    }
                    .padding(EdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24))
                    Divider()
                        .padding([.leading, .trailing, .bottom], 10)
                    
                    Group {
                        title("💡 이 프로젝트에 사용한 것")
                        description("swiftui, mvvm, cooridnator pattern, realm swift, combine")
                        
                        title("⌨ 개발자 스택")
                        description("ios, aos")
                        description("swift, kotlin, java, python, c, c++, js")
                        
                        title("🖥 github")
                        description(vm.git)
                            .onTapGesture {
                                vm.onClickUrl()
                            }
                        title("ℹ 출처")
                        description("이미지: https://icons8.com/")
                        description("날씨 api: https://openweathermap.org/")
                    }
                    .frame(width: geometry.size.width, alignment: .leading)
                }
                .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func title(_ title: String) -> some View {
        return Text(title)
            .font(.kr14b)
            .foregroundColor(.gray100)
            .padding(EdgeInsets(top: 16, leading: 8, bottom: 10, trailing: 8))
    }
    private func description(_ description: String) -> some View {
        return Text(description)
            .font(.kr13r)
            .foregroundColor(.gray90)
    }
}
