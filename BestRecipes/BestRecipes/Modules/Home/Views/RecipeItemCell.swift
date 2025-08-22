//
//  RecipeItemCell.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 22.08.2025.
//

import UIKit

// MARK: - Recipe Cell
class RecipeItemCell: UICollectionViewCell {
    static let reuseId = "RecipeItemCell"

    private let imageView: UIImageView = {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            // Фото
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 124),
            imageView.heightAnchor.constraint(equalToConstant: 124),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            // Подзаголовок
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            subtitleLabel.widthAnchor.constraint(equalToConstant: 99),
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
                        self?.imageView.image = image
                    case .failure:
                        self?.imageView.image = UIImage(named: "defaultSearch")
                    }
                }
            }
        }
    

}
