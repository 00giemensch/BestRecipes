//
//  TempViewController.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 19.08.2025.
//

import UIKit

final class TempViewController: UIViewController {

    // MARK: - UI Elements
    private let titleStack = UIStackView.create(.vertical, spacing: 8, alignment: .center)
    private let emojiLabel = UILabel.create(font: UIFont.custom(.regular, size: 40))
    private let titleLabel = UILabel.create(font: UIFont.custom(.semibold, size: 18), color: .black)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleStack)
        titleStack.addArrangedSubviews(emojiLabel, titleLabel)
        
        emojiLabel.text = "🚧"
        titleLabel.text = """
        The screen is 
        in development
        """
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

