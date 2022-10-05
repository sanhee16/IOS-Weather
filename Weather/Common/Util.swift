//
//  Util.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation
import SwiftUI

class Util {
    static func safeAreaInsets() -> UIEdgeInsets? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)?.safeAreaInsets
    }
    
    static func safeBottom() -> CGFloat {
        return safeAreaInsets()?.bottom ?? 0
    }
    
    static func safeTop() -> CGFloat {
        return safeAreaInsets()?.top ?? 0
    }
}
