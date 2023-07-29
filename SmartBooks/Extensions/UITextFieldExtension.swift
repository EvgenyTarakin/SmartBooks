//
//  UITextFieldExtension.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit
import SnapKit

extension UITextField {
    func setLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setupClearButton() {
        let clearButton = UIButton()
        clearButton.setTitle("", for: .normal)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(tapClearButton), for: .touchUpInside)
        self.addSubview(clearButton)
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(12)
            $0.height.width.equalTo(24)
        }
        if self.text != "" {
            clearButton.isHidden = true
        } else {
            clearButton.isHidden = false
        }
    }
    
    @objc private func tapClearButton() {
        setupClearButton()
        self.text = ""
    }
}
