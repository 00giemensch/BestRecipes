////
////  RecipeCardCell.swift
////  BestRecipes
////
////  Created by Nurislam on 19.08.2025.
////
//
//import UIKit
//
//final class RecipeCardCell: UICollectionViewCell {
//    
//    // MARK: - Constants
//    private enum Constants {
//        static let cornerRadius: CGFloat = 12
//        static let shadowOffset = CGSize(width: 0, height: 2)
//        static let shadowRadius: CGFloat = 4
//        static let shadowOpacity: Float = 0.1
//        static let titleTopInset: CGFloat = 12
//        static let titleHorizontalInset: CGFloat = 12
//        static let timeTopInset: CGFloat = 8
//        static let bottomInset: CGFloat = 12
//    }
//    
//    // MARK: - UI Elements
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = Constants.cornerRadius
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.accessibilityIdentifier = "recipe_image"
//        imageView.accessibilityLabel = "Recipe image"
//        return imageView
//    }()
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Poppins-SemiBold", size: 16)
//        label.textColor = UIColor(named: "Neutral100") ?? .black
//        label.numberOfLines = 2
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.accessibilityIdentifier = "recipe_title"
//        label.accessibilityLabel = "Recipe title"
//        label.adjustsFontForContentSizeCategory = true
//        return label
//    }()
//    
//    private let timeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Poppins-Regular", size: 12)
//        label.textColor = UIColor(named: "Neutral50") ?? .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.accessibilityIdentifier = "recipe_time"
//        label.accessibilityLabel = "Cooking time"
//        label.adjustsFontForContentSizeCategory = true
//        return label
//    }()
//    
//    private let ratingLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Poppins-Regular", size: 12)
//        label.textColor = UIColor(named: "Neutral50") ?? .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.accessibilityIdentifier = "recipe_rating"
//        label.accessibilityLabel = "Recipe rating"
//        label.adjustsFontForContentSizeCategory = true
//        return label
//    }()
//    
//    // MARK: - Initialization
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        contentView.addSubview(imageView)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(timeLabel)
//        contentView.addSubview(ratingLabel)
//        
//        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = Constants.cornerRadius
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOffset = Constants.shadowOffset
//        contentView.layer.shadowRadius = Constants.shadowRadius
//        contentView.layer.shadowOpacity = Constants.shadowOpacity
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Image
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75),
//            
//            // Title
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.titleTopInset),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.titleHorizontalInset),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.titleHorizontalInset),
//            
//            // Time
//            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.timeTopInset),
//            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.titleHorizontalInset),
//            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomInset),
//            
//            // Rating
//            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.timeTopInset),
//            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.titleHorizontalInset),
//            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomInset)
//        ])
//    }
//    
//    // MARK: - Configuration
//    func configure(with recipe: RecipeModel) {
//        titleLabel.text = recipe.title
//        timeLabel.text = "\(recipe.readyInMinutes) min"
//        ratingLabel.text = "★ \(String(format: "%.1f", recipe.spoonacularScore / 10.0))"
//        
//        // Обновляем accessibility
//        titleLabel.accessibilityLabel = "Recipe: \(recipe.title)"
//        timeLabel.accessibilityLabel = "Cooking time: \(recipe.readyInMinutes) minutes"
//        ratingLabel.accessibilityLabel = "Rating: \(String(format: "%.1f", recipe.spoonacularScore / 10.0)) stars"
//        
//        // Загружаем изображение
//        loadImage(from: recipe.image)
//    }
//    
//    private func loadImage(from urlString: String) {
//        // Сначала показываем заглушку
//        imageView.image = UIImage(named: "defaultSearch")
//        
//        // Загружаем реальное изображение
//        NetworkManager.shared.loadImage(from: urlString) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    self?.imageView.image = image
//                case .failure(_):
//                    self?.imageView.image = UIImage(named: "defaultSearch")
//                }
//            }
//        }
//    }
//}
