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
    
    static func create(
        _ axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat,
        alignment: UIStackView.Alignment = .leading
    ) -> UIStackView {
        
        let stack = UIStackView()
        stack.axis = axis
        stack.distribution = .fill
        stack.spacing = spacing
        stack.alignment = alignment
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}
