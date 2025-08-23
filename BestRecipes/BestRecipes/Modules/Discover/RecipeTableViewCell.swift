//
//  RecipeTableViewCell.swift
//  BestRecipes
//
//  Created by Nurislam on 19.08.2025.
//

import UIKit

// MARK: - Recipe Cell for Tables
class RecipeTableViewCell: UITableViewCell {
    static let reuseId = "RecipeTableViewCell"

    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 14)
        label.textColor = UIColor(named: "Neutral100") ?? UIColor(hex: 0x181A2A)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 10)
        label.textColor = UIColor(named: "Neutral50") ?? UIColor(hex: 0x919191)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            // Фото
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeImageView.widthAnchor.constraint(equalToConstant: 124),
            recipeImageView.heightAnchor.constraint(equalToConstant: 124),
            recipeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            // Подзаголовок
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    func setupRecipe(_ recipe: RecipeModel) {
            titleLabel.text = recipe.title
            subtitleLabel.text = recipe.creditsText.isEmpty ? "Unknown Author" : recipe.creditsText

            NetworkManager.shared.loadImage(from: recipe.image) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self?.recipeImageView.image = image
                    case .failure:
                        self?.recipeImageView.image = UIImage(named: "defaultSearch")
                    }
                }
            }
        }
    

}
