//
//  WriteBoardViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//

import Foundation
import Combine
import UIKit

class WriteBoardViewModel: BaseViewModel {
    @Published var content: String = ""
    @Published var keyboardHeight: CGFloat = 0.0

    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
    }
    
    func onAppear() {
        addKeyboardNotification()
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func save() {
        
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
}

