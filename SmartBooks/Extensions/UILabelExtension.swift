//
//  UILabelExtension.swift
//  SmartBooks
//
//  Created by Евгений Таракин on 01.08.2023.
//

import UIKit

extension UILabel {
    func highlight(searchedText: String?, color: UIColor = .red, font: UIFont) {
        guard let txtLabel = self.text?.lowercased(), let searchedText = searchedText?.lowercased() else {
            return
        }

        let attributeTxt = NSMutableAttributedString(string: txtLabel)
        let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)

        attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributeTxt.addAttribute(NSAttributedString.Key.font, value: font, range: range)

        self.attributedText = attributeTxt
    }
}
