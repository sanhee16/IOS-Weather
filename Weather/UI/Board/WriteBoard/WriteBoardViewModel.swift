//
//  WriteBoardViewModel.swift
//  Weather
//
//  Created by sandy on 2022/10/10.
//

import Foundation
import Combine
import UIKit
import FirebaseCore
import FirebaseFirestore

class WriteBoardViewModel: BaseViewModel {
    @Published var content: String = ""
    @Published var keyboardHeight: CGFloat = 0.0
    @Published var type: WeatherType
    private var db: Firestore
    @Published var isLoading: Bool = true

    init(_ coordinator: AppCoordinator, type: WeatherType) {
        self.type = type
        self.db = Firestore.firestore()
        super.init(coordinator)
    }
    
    func onAppear() {
        addKeyboardNotification()
        self.isLoading = false
    }
    
    func onClose() {
        self.coordinator?.presentAlertView(.yesOrNo, title: "정말 나가시겠습니까?", description: "작성하던 글이 저장되지 않습니다.", callback: {[weak self] res in
            if res {
                self?.dismiss()
            }
        })
    }
    
    func upload() {
        if content.isEmpty {
            self.coordinator?.presentAlertView(.ok, title: "업로드 할 내용을 써주세요.")
            return
        }
        self.isLoading = true
        
        var ref: DocumentReference? = nil
        ref = db.collection("list").addDocument(data: [
            "createdAt": Int(Date().timeIntervalSince1970),
            "text": content,
            "type": type.rawValue
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.isLoading = false
                self.dismiss()
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.isLoading = false
                self.dismiss()
            }
        }
        
    }
    
    func onClickReSelect() {
        self.coordinator?.presentSelectWeatherView() {[weak self] type in
            self?.type = type
        }
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

