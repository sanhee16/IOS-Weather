//
//  WriteBoardView.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//

import SwiftUI

struct WriteBoardView: View {
    typealias VM = WriteBoardViewModel
    public static func vc(_ coordinator: AppCoordinator, type: WeatherType, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, type: type)
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
                ZStack(alignment: .trailing) {
                    Topbar("새 글 쓰기", type: .back) {
                        vm.onClose()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Text("글 올리기")
                            .font(.kr14r)
                            .foregroundColor(.gray100)
                            .padding(EdgeInsets(top: 7, leading: 9, bottom: 7, trailing: 9))
                            .border(.gray60, lineWidth: 1.2, cornerRadius: 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.white)
                                    .shadow(color: .gray30, radius: 2, x: 2, y: 2)
                            )
                            .onTapGesture {
                                vm.upload()
                            }
                            .padding(.trailing, 12)
                    }
                }
                VStack(alignment: .leading, spacing: 0) {
                    if $vm.isLoading.wrappedValue {
                        Spacer()
                        HStack(alignment: .center, spacing: 0) {
                            Spacer()
                            SandyProgressView()
                            Spacer()
                        }
                        Spacer()
                    } else {
                        HStack(alignment: .center, spacing: 0) {
                            Text($vm.type.wrappedValue.name)
                                .font(.kr20r)
                                .foregroundColor(.blue100)
                                .padding(12)
                            Spacer()
                            Text("날짜 다시 선택하기")
                                .font(.kr14r)
                                .foregroundColor(.gray60)
                                .padding(EdgeInsets(top: 7, leading: 9, bottom: 7, trailing: 9))
                                .border(.gray60, lineWidth: 1.2, cornerRadius: 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.white)
                                        .shadow(color: .gray30, radius: 2, x: 2, y: 2)
                                )
                                .onTapGesture {
                                    vm.onClickReSelect()
                                }
                                .padding(.trailing, 2)
                        }
                        
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
