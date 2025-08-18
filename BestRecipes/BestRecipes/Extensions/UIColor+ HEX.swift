//
//  Extensions.swift
//  BestRecipes
//
//  Created by Анастасия Тихонова on 15.08.2025.
//



import UIKit

// MARK: - UIColor + HEX convenience
extension UIColor {
    convenience init(hex: UInt32) {
        let r = CGFloat((hex >> 16) & 0xFF)/255.0
        let g = CGFloat((hex >> 8) & 0xFF)/255.0
        let b = CGFloat(hex & 0xFF)/255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}




 

