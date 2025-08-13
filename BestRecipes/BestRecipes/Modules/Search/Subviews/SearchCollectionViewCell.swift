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
        static var blurInset: CGFloat { 8 }
        static var blurSize: CGSize { CGSize(width: 58, height: 28) }
        
        static var starSize: CGSize { CGSize(width: 16, height: 16) }
        static var starSpacing: CGFloat { 3 }
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
    private let rateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = Drawing.starSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "starRate"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.custom(.semibold, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(imageView, blurView)
        blurView.addSubview(rateStack)
        rateStack.addArrangedSubviews(iconView, rateLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Drawing.blurInset),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawing.blurInset),
            blurView.widthAnchor.constraint(equalToConstant: Drawing.blurSize.width),
            blurView.heightAnchor.constraint(equalToConstant: Drawing.blurSize.height),
            
            rateStack.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            rateStack.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            
            iconView.widthAnchor.constraint(equalToConstant: Drawing.starSize.width),
            iconView.heightAnchor.constraint(equalToConstant: Drawing.starSize.height)
        ])
    }
}
