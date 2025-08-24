//
//  PopularCategoryCell.swift
//  Popular category Collection
//
//  Created by Никита Грицунов on 13.08.2025.
//

import UIKit

class PopularCategoryCell: UICollectionViewCell {
    private enum Drawings {
        static var imageRectSize: CGRect { CGRectMake(0, 0, 110, 110) }
        static var imageShadowOpacity: Float { 1.0 }
        static var imageShadowRadius: CGFloat { 25 }
        static var imageShadowColor: CGColor { UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.15).cgColor }
        static var imageShadowOffset: CGSize { CGSize(width: 0, height: 8) }
        
        static var timeLabelText: String { "Time" }
        static var timeLabelColor: UIColor { UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1) }
        
        static var favoriteButtonRadius: CGFloat { 12 }
        static var favoriteButtonIconSize: CGSize { CGSize(width: 10.96, height: 13.67) }
        static var favoriteButtonColor: UIColor { UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1) }
        
        static var backgroundRadius: CGFloat { 12 }
        static var backgroundColor: UIColor { UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1) }
    }

//MARK: - Properties
    static let identifier = "PopularCategoryCell"
    private var isAddedInFavorite: Bool = false {
        didSet {
            fillingBookmark()
        }
    }
    
    var favoriteButtonAction: (() -> Void)?
    
//MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        dishTitleLabel.text = nil
        cookingTimeLabel.text = nil
        isAddedInFavorite = false
    }
    
//MARK: - UI
    private lazy var mainView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
       
    private lazy var imageShadow: UIView = {
        let element = UIView(frame: Drawings.imageRectSize)
        element.layer.cornerRadius = element.frame.height / 2
        element.layer.shadowOpacity = Drawings.imageShadowOpacity
        element.layer.shadowRadius = Drawings.imageShadowRadius
        element.layer.shadowColor = Drawings.imageShadowColor
        element.layer.shadowOffset = Drawings.imageShadowOffset
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dishImage: UIImageView = {
        let element = UIImageView(frame: Drawings.imageRectSize)
        element.image = UIImage(resource: .defaultSearch)
        element.contentMode = .scaleAspectFill
        element.layer.masksToBounds = true
        element.layer.cornerRadius = element.frame.height / 2
                   
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dishTitleLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.custom(.semibold, size: 14)
        element.text = ""
        element.numberOfLines = 2
        element.adjustsFontSizeToFitWidth = true
        element.minimumScaleFactor = 0.5
        element.textAlignment = .center
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var timeLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.custom(.regular, size: 12)
        element.text = Drawings.timeLabelText
        element.textColor = Drawings.timeLabelColor
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cookingTimeLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.custom(.semibold, size: 12)
        element.text = "5 min"
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var favoriteButton: UIButton = {
        let image = UIImage(resource: .bookmarkIco)
        let scaledImage = image.scale(to: Drawings.favoriteButtonIconSize).withRenderingMode(.alwaysTemplate)

        let element = UIButton()
        element.setImage(scaledImage, for: .normal)
        element.backgroundColor = .white
        
        element.layer.cornerRadius = 12
        element.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var background: UIView = {
        let element = UIView()
        element.backgroundColor = Drawings.backgroundColor
        element.layer.cornerRadius = Drawings.backgroundRadius
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var footerSectionView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    //MARK: - Setup Constraints and Set Views
        private func setViews() {
            contentView.layer.cornerRadius = Drawings.backgroundRadius
        
            contentView.addSubview(background)
            contentView.addSubview(imageShadow)
            contentView.addSubview(dishTitleLabel)
            contentView.addSubview(footerSectionView)
            
            imageShadow.addSubview(dishImage)
            footerSectionView.addSubview(timeLabel)
            footerSectionView.addSubview(cookingTimeLabel)
            footerSectionView.addSubview(favoriteButton)
            fillingBookmark()
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                imageShadow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
                imageShadow.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                   
                imageShadow.heightAnchor.constraint(equalToConstant: 110),
                imageShadow.widthAnchor.constraint(equalToConstant: 110),
                
                dishImage.heightAnchor.constraint(equalToConstant: 110),
                dishImage.widthAnchor.constraint(equalToConstant: 110),
                
                background.topAnchor.constraint(equalTo: imageShadow.centerYAnchor),
                background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                
                dishTitleLabel.topAnchor.constraint(equalTo: imageShadow.bottomAnchor, constant: 12),
                dishTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                dishTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                
//                footerSectionView.topAnchor.constraint(equalTo: dishTitleLabel.bottomAnchor, constant: 16),
                footerSectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                footerSectionView.heightAnchor.constraint(equalToConstant: 40),
                footerSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                footerSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                
                favoriteButton.heightAnchor.constraint(equalToConstant: 24),
                favoriteButton.widthAnchor.constraint(equalToConstant: 24),
                favoriteButton.bottomAnchor.constraint(equalTo: footerSectionView.bottomAnchor),
                favoriteButton.trailingAnchor.constraint(equalTo: footerSectionView.trailingAnchor),
                
                timeLabel.topAnchor.constraint(equalTo: footerSectionView.topAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: footerSectionView.leadingAnchor),
                
                cookingTimeLabel.bottomAnchor.constraint(equalTo: footerSectionView.bottomAnchor),
                cookingTimeLabel.leadingAnchor.constraint(equalTo: footerSectionView.leadingAnchor)
            ])
        }
    
    @objc func favoriteButtonPressed() {
        isAddedInFavorite.toggle()
        guard let action = self.favoriteButtonAction else { return }
        action()
    }
    
    private func fillingBookmark() {
        favoriteButton.tintColor = isAddedInFavorite ? .systemRed : .gray
    }
    
    func configureCell(with recipe: RecipeModel,_ isAddToFavorite: Bool) {
        dishTitleLabel.text = recipe.title
        cookingTimeLabel.text = "\(recipe.readyInMinutes) Mins"
        isAddedInFavorite = isAddToFavorite
        NetworkManager.shared.loadImage(from: recipe.image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.dishImage.image = image
                case .failure:
                    self?.dishImage.image = UIImage(named: "defaultSearch")
                }
            }
        }
    }
}

//MARK: - Extension UIImage

extension UIImage {
    func scale(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
