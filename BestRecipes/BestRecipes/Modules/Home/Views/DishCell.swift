//
//  DishCell.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 12.08.2025.
//

import UIKit

class DishCell: UICollectionViewCell {
    //MARK: - Properties
    static let cellId = "DishCell"
    internal var isAddedInFavorite: Bool = false {
        didSet {
            fillingBookmark()
        }
    }
    var favoriteButtonAction: (() -> Void)?
    
    //MARK: - UI Components
    private let dishImageView = UIImageView()
    private let favoriteButton = UIButton()
    let ratingButton = RatingButton()
    private let avatarImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        dishImageView.image = UIImage(systemName: "frying.pan")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        avatarImageView.image = UIImage(systemName: "person.circle")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        ratingButton.isHasRating = false
        isAddedInFavorite = false
    }
    //MARK: - Methods
    @objc private func buttonPressed() {
        isAddedInFavorite.toggle()
        guard let action = self.favoriteButtonAction else { return }
        action()
    }
    private func fillingBookmark() {
        favoriteButton.tintColor = isAddedInFavorite ? .systemRed : .gray
    }
    func configure(with recipe: RecipeModel,_ isAddToFavorite: Bool) {
        titleLabel.text = recipe.title
        subtitleLabel.text = recipe.creditsText
        isAddedInFavorite = isAddToFavorite
        ratingButton.setRatingGrade(recipe.spoonacularScore)
        fetchImage(with: recipe.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.dishImageView.image = image
            }
        }
        fetchImage(with: recipe.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
    }
    private func fetchImage(with imageUrl: String, completion: @escaping ((UIImage) -> Void)) {
        guard let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            completion(image)
        }.resume()
    }
    
    
    //MARK: - Setup Layout
    private func setupCell() {
        setupDishImageView()
        setupTitleLabel()
        setupFavoriteButton()
        setupAvatarImageView()
        setupSubtitleLabel()
        setupRatingButton()
    }
    private func setupDishImageView() {
        dishImageView.backgroundColor = .systemGray5
        dishImageView.layer.cornerRadius = 16
        let image = UIImage(systemName: "frying.pan")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        dishImageView.image = image
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.layer.masksToBounds = true
        dishImageView.translatesAutoresizingMaskIntoConstraints = false
        let shadowView = UIView()
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 1
        shadowView.layer.shadowOffset = .init(width: 0, height: 0)
        shadowView.layer.cornerRadius = 20
        shadowView.frame = dishImageView.bounds
        contentView.addSubview(shadowView)
        shadowView.addSubview(dishImageView)
        
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            dishImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.73)
        ])
    }
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.text = "Title text fot testing textLabel"
        titleLabel.font = UIFont.custom(.semibold, size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor),
        ])
    }
    private func setupFavoriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 16
        let image = UIImage(resource: .bookmarkIco).withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(image, for: .normal)
        fillingBookmark()
        favoriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -8),            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    private func setupAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 16
        let image = UIImage(systemName: "person.circle")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        avatarImageView.image = image
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    private func setupSubtitleLabel() {
        contentView.addSubview(subtitleLabel)
        subtitleLabel.text = "Subtitle text for subtitle lable"
        subtitleLabel.font = UIFont.custom(.regular, size: 12)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textColor = .lightGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 7),
            subtitleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor)
        ])
    }
    private func setupRatingButton() {
        contentView.addSubview(ratingButton)
        ratingButton.action = { [weak self] in
            print("ratingButton tup")
        }
        ratingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingButton.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 8),
            ratingButton.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor, constant: 8),
            ratingButton.widthAnchor.constraint(equalToConstant: 58),
            ratingButton.heightAnchor.constraint(equalToConstant: 27.6)
        ])
    }
}
