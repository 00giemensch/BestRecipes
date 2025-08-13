//
//  RatingButton.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 13.08.2025.
//

import UIKit

class RatingButton: UIView {
    //MARK: - Properties
    var action: (() -> Void)?
    private var isHasRating: Bool {
        didSet {
            fillingStar()
        }
    }
    
    //MARK: - UI Components
    private let button = UIButton()
    private let starImageView = UIImageView()
    private let gradeLabel = UILabel()
    
    //MARK: - Lifecycle
    init(isHasRating: Bool = false) {
        self.isHasRating = isHasRating
        super.init(frame: .zero)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    @objc private func buttonPressed() {
        isHasRating.toggle()
        guard let action = self.action else { return }
        action()
    }
    private func fillingStar() {
        starImageView.tintColor = isHasRating ? .yellow : .black
    }
    
    //MARK: - Setup Layout
    private func setupLayout() {
        setupBackground()
        setupStarImageView()
        setupGradeLabel()
        setupButton()
    }
    private func setupBackground() {
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.layer.cornerRadius = 8
    }
    private func setupStarImageView() {
        self.addSubview(starImageView)
        let starColor: UIColor = isHasRating ? .yellow : .black
        let image = UIImage(systemName: "star.fill")
        starImageView.image = image
        starImageView.tintColor = starColor
        starImageView.contentMode = .scaleAspectFill
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.8),
            starImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    private func setupGradeLabel() {
        self.addSubview(gradeLabel)
        gradeLabel.text = "4,5"
        gradeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        gradeLabel.textColor = .white
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradeLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            gradeLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor,constant: 3)
        ])
    }
    private func setupButton() {
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
