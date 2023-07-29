//
//  Font.swift
//
//
//  Created by Евгений Таракин on 29.07.2023.
//

import UIKit

private let familyName = "Manrope"

enum Font: String {
    case extraLight = "ExtraLight"
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case bold = "Bold"
    case semiBold = "SemiBold"
    case extraBold = "ExtraBold"

    func size(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: fullFontName, size: size) {
            return font
        }
        fatalError("Font '\(fullFontName)' does not exist.")
    }
    
    fileprivate var fullFontName: String {
        return rawValue.isEmpty ? familyName : familyName + "-" + rawValue
    }
}
