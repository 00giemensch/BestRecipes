//
//  UILabel +.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 13.08.2025.
//

import UIKit

extension UILabel {
    static func create(font: UIFont, color: UIColor = .white) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
