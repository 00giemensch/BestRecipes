//
//  KitchenCollectionViewCell.swift.swift
//  BestRecipes
//
//  Created by Анастасия Тихонова on 22.08.2025.
//

import UIKit

// MARK: - Kitchen Cell

class KitchenCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let flagLabel = UILabel()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    static let identifier = "KitchenCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        contentView.backgroundColor = .clear

        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55           // Круг: 110 / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        flagLabel.font = UIFont.systemFont(ofSize: 36)
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        flagLabel.backgroundColor = .clear
        flagLabel.textAlignment = .center

        contentView.addSubview(imageView)
        contentView.addSubview(flagLabel)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 110),
            imageView.heightAnchor.constraint(equalToConstant: 110),

            flagLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            flagLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            flagLabel.widthAnchor.constraint(equalToConstant: 36),
            flagLabel.heightAnchor.constraint(equalToConstant: 36),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    func configure(with kitchen: Kitchen) {
        nameLabel.text = kitchen.name
        flagLabel.text = kitchen.flagEmoji

        fetchImage(with: kitchen.imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }

    private func fetchImage(with imageUrl: String, completion: @escaping ((UIImage) -> Void)) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  error == nil else { return }
            completion(image)
        }.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        flagLabel.text = nil
        nameLabel.text = nil
    }
}
