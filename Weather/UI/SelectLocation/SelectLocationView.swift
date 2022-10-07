//
//  SelectLocationView.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI

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

#if DEBUG
struct SelectLocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SelectLocationView(vm: SelectLocationViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
        }
    }
}
#endif
