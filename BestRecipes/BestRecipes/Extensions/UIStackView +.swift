//
//  UIStackView +.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 13.08.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { addArrangedSubview($0) }
    }
}
