//
//  SelectWeatherView.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//


import SwiftUI

struct SelectWeatherView: View {
    typealias VM = SelectWeatherViewModel
    public static func vc(_ coordinator: AppCoordinator, callback: @escaping (WeatherType) -> (), completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, callback: callback)
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
            ZStack(alignment: .trailing) {
                Topbar("날씨 선택하기", type: .close) {
                    vm.onClose()
                }
                if $vm.selectedItem.wrappedValue != nil {
                    Text("선택하기")
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
                            vm.onClickSelect()
                        }
                        .padding(.trailing, 6)
                }
            }
            .padding(.bottom, 16)
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 15), count: 3), spacing: 8) {
                ForEach($vm.list.wrappedValue.indices, id: \.self) { idx in
                    let item = $vm.list.wrappedValue[idx]
                    itemView(item: item, isSelected: $vm.selectedItem.wrappedValue == item)
                }
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
    
    private func itemView(item: WeatherType, isSelected: Bool) -> some View {
        return Text(item.name)
            .font(isSelected ? .kr14b : .kr14r)
            .foregroundColor(isSelected ? .white : .gray100)
            .frame(width: 70, height: 40, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isSelected ? .blue80 : .clear)
            )
            .border(isSelected ? .clear : .blue80, lineWidth: 1.2, cornerRadius: 12)
            .onTapGesture {
                vm.onSelectItem(item)
            }
    }
}

