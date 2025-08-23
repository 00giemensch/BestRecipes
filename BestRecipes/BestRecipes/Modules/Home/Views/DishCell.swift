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
    private var isAddedInFavorite: Bool = false {
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
    private let timeLabel = UILabel() // Добавляем время приготовления
    
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
        timeLabel.text = nil
        dishImageView.image = UIImage(systemName: "frying.pan")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        avatarImageView.image = UIImage(systemName: "person.circle")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        ratingButton.isHasRating = false
        isAddedInFavorite = false
    }
    //MARK: - Methods
    @objc private func buttonPressed() {
        // Добавляем анимацию нажатия
        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.favoriteButton.transform = CGAffineTransform.identity
            }
        }
        
        isAddedInFavorite.toggle()
        guard let action = self.favoriteButtonAction else { return }
        action()
    }
    private func fillingBookmark() {
        favoriteButton.tintColor = isAddedInFavorite ? .systemRed : .gray
    }
    func configure(with recipe: RecipeModel,_ isAddToFavorite: Bool, showMinusIcon: Bool = false) {
        titleLabel.text = recipe.title
        subtitleLabel.text = recipe.creditsText.isEmpty ? "Unknown Author" : recipe.creditsText
        timeLabel.text = "\(recipe.readyInMinutes):10" // Формат времени как на макете
        isAddedInFavorite = isAddToFavorite
        
        // Настраиваем иконку закладки
        if showMinusIcon {
            let minusImage = UIImage(systemName: "minus")?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(minusImage, for: .normal)
            favoriteButton.tintColor = .systemRed // Красный цвет для кнопки удаления
        } else {
            let bookmarkImage = UIImage(resource: .bookmarkIco).withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(bookmarkImage, for: .normal)
        }
        
        ratingButton.setRatingGrade(recipe.spoonacularScore)
        
        // Загружаем изображение блюда
        fetchImage(with: recipe.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.dishImageView.image = image
            }
        }
        
        // Загружаем изображение для аватара (используем то же изображение блюда)
        fetchImage(with: recipe.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
        
        // Обновляем layout после загрузки контента
        DispatchQueue.main.async { [weak self] in
            self?.layoutIfNeeded()
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
        setupCellBackground()
        setupDishImageView()
        setupTitleLabel()
        setupFavoriteButton()
        setupAvatarImageView()
        setupSubtitleLabel()
        setupRatingButton()
        setupTimeLabel() // Добавляем настройку времени
    }
    
    private func setupCellBackground() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowRadius = 8
        contentView.layer.masksToBounds = false
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
            dishImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4), // Уменьшаем отступ сверху
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            dishImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            dishImageView.heightAnchor.constraint(equalToConstant: 180) // По Figma: 180px высота изображения
        ])
    }
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.text = "Title text fot testing textLabel"
        titleLabel.font = UIFont.custom(.bold, size: 18) // Еще больше уменьшаем размер для лучшего размещения
        titleLabel.numberOfLines = 3 // Разрешаем до 3 строк
        titleLabel.lineBreakMode = .byTruncatingTail // Обрезаем с многоточием если не помещается
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: 8), // Уменьшаем отступ
            titleLabel.leadingAnchor.constraint(equalTo: dishImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24) // Минимальная высота для одной строки
        ])
    }
    private func setupFavoriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 16
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        favoriteButton.layer.shadowOpacity = 0.15
        favoriteButton.layer.shadowRadius = 4
        
        let image = UIImage(resource: .bookmarkIco).withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(image, for: .normal)
        fillingBookmark()
        favoriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: dishImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    private func setupAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.systemGray5.cgColor // Добавляем тонкую границу
        
        let image = UIImage(systemName: "person.circle")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        avatarImageView.image = image
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6), // Уменьшаем отступ
            avatarImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120), // Уменьшаем ширину аватара
            avatarImageView.heightAnchor.constraint(equalToConstant: 28), // Уменьшаем высоту аватара
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6) // Уменьшаем отступ снизу
        ])
    }
    private func setupSubtitleLabel() {
        contentView.addSubview(subtitleLabel)
        subtitleLabel.text = "Subtitle text for subtitle lable"
        subtitleLabel.font = UIFont.custom(.regular, size: 12) // Еще больше уменьшаем размер
        subtitleLabel.numberOfLines = 1
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textColor = UIColor.systemGray3 // Более светлый цвет для лучшей иерархии
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subtitleLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 18) // Уменьшаем высоту
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
    private func setupTimeLabel() {
        contentView.addSubview(timeLabel)
        timeLabel.text = "15:10" // Placeholder text
        timeLabel.font = UIFont.custom(.bold, size: 12)
        timeLabel.textColor = .white
        timeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4) // Увеличиваем прозрачность
        timeLabel.layer.cornerRadius = 8
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем тень для лучшей читаемости
        timeLabel.layer.shadowColor = UIColor.black.cgColor
        timeLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        timeLabel.layer.shadowOpacity = 0.3
        timeLabel.layer.shadowRadius = 2
        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: dishImageView.bottomAnchor, constant: -8),
            timeLabel.trailingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: -8),
            timeLabel.widthAnchor.constraint(equalToConstant: 50),
            timeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
