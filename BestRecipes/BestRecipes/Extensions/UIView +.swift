//
//  UIView +.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 13.08.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
