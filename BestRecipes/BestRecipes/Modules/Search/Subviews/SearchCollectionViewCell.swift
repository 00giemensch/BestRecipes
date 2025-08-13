//
//  SearchCollectionViewCell.swift
//  PrepareRecipes
//
//  Created by Варвара Уткина on 12.08.2025.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionViewCell"
    
    private enum Drawing {
        static var radius: CGFloat { 10 }
        
        static var blurRadius: CGFloat { 8 }
        static var smallInset: CGFloat { 8 }
        static var horizontalInset: CGFloat { 16 }
        static var blurSize: CGSize { CGSize(width: 58, height: 28) }
        
        static var starSize: CGSize { CGSize(width: 16, height: 16) }
        static var starSpacing: CGFloat { 3 }
        static var ingredientsInset: CGFloat { 7 }
    }
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Drawing.radius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let blurView: UIView = {
        let blurView = UIView()
        blurView.backgroundColor = .blur
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = Drawing.blurRadius
        blurView.layer.masksToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    private let rateStack = UIStackView.create(spacing: Drawing.starSpacing, alignment: .center)
    private let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "starRate"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let rateLabel = UILabel.create(font: UIFont.custom(.semibold, size: 14))
    
    private let titleStack = UIStackView.create(.vertical, spacing: Drawing.horizontalInset)
    private let titleLabel = UILabel.create(font: UIFont.custom(.semibold, size: 16))
    
    private let ingredientsStack = UIStackView.create(spacing: Drawing.ingredientsInset)
    private let ingredientsLabel = UILabel.create(font: UIFont.custom(.regular, size: 12))
    private let lineLabel = UILabel.create(font: UIFont.custom(.regular, size: 12))
    private let timeLabel = UILabel.create(font: UIFont.custom(.regular, size: 12))
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with model: SearchModel) {
        imageView.image = UIImage(named: model.imageName)
        rateLabel.text = model.rate
        titleLabel.text = model.title
        ingredientsLabel.text = model.ingredients
        lineLabel.text = "|"
        timeLabel.text = model.time
        addGradientToImageView()
    }
    
    // MARK: - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(imageView, blurView, titleStack)
        blurView.addSubview(rateStack)
        rateStack.addArrangedSubviews(iconView, rateLabel)
        titleStack.addArrangedSubviews(titleLabel, ingredientsStack)
        ingredientsStack.addArrangedSubviews(ingredientsLabel, lineLabel, timeLabel)
        
        titleLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Drawing.smallInset),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawing.smallInset),
            blurView.widthAnchor.constraint(equalToConstant: Drawing.blurSize.width),
            blurView.heightAnchor.constraint(equalToConstant: Drawing.blurSize.height),
            
            rateStack.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            rateStack.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            
            iconView.widthAnchor.constraint(equalToConstant: Drawing.starSize.width),
            iconView.heightAnchor.constraint(equalToConstant: Drawing.starSize.height),
            
            titleStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawing.horizontalInset),
            titleStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Drawing.horizontalInset),
            titleStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Drawing.horizontalInset)
        ])
    }
    
    // MARK: - Private Methods
    private func addGradientToImageView() {
        imageView.layoutIfNeeded()
        guard imageView.bounds.width > 0, imageView.bounds.height > 0 else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.frame = imageView.bounds
        
        let height = ceil(imageView.bounds.height * 0.55)
        gradientLayer.frame = CGRect(
            x: 0,
            y: height,
            width: imageView.bounds.width,
            height: height
        )
        imageView.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }
        
        imageView.layer.insertSublayer(
            gradientLayer,
            at: UInt32(imageView.layer.sublayers?.count ?? 0)
        )
    }
}
