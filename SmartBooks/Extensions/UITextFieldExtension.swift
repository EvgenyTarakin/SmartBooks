//
//  UITextFieldExtension.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit
import SnapKit

extension UITextField {
    // MARK: - func
    func setupTextField(_ placeholder: String) {
        self.backgroundColor = .white
        self.clearButtonMode = .whileEditing
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.font : Font.medium.size(15),
                                                                          NSAttributedString.Key.foregroundColor : UIColor(hex: "1B1F3B", alpha: 0.65)])
        inactivateTextField()
        setupPaddings()
    }
    
    func activateTextField() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "3888FF").cgColor
    }
    
    func inactivateTextField() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "E3E3EB").cgColor
    }
    
    // MARK: - private func
    private func setupPaddings() {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
    }
    
    // MARK: - obj-c
}
