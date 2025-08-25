//
//  UIFont +.swift
//  PrepareRecipes
//
//  Created by Варвара Уткина on 12.08.2025.
//

import UIKit

extension UIFont {
    static func custom(_ type: Poppins, size: CGFloat) -> UIFont {
        type.font(size: size)
    }
}

// MARK: - Inter Font
enum Poppins: String {
    case thin = "Poppins-Thin"
    case extraLight = "Poppins-ExtraLight"
    case light = "Poppins-Light"
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semibold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
    case extraBold = "Poppins-ExtraBold"
    case black = "Poppins-Black"
    
    private var fallbackWeight: UIFont.Weight {
        switch self {
        case .light: .light
        case .regular: .regular
        case .medium: .medium
        case .semibold: .semibold
        case .bold: .bold
        case .extraBold: .heavy
        case .thin: .thin
        case .extraLight: .thin
        case .black: .black
        }
    }
    
    func font(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: rawValue, size: size) else {
            assertionFailure("Шрифт \(rawValue) не найден. Добавьте его в проект и Info.plist")
            return UIFont.systemFont(ofSize: size, weight: fallbackWeight)
        }
        return font
    }
}
