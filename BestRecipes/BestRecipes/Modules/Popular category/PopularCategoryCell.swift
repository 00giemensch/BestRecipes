//
//  PopularCategoryCell.swift
//  Popular category Collection
//
//  Created by Никита Грицунов on 13.08.2025.
//

import UIKit

class PopularCategoryCell: UICollectionViewCell {

//MARK: - Properties
    
    static let identifier = "PopularCategoryCell"
    
//MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//MARK: - UI
    
    private lazy var mainView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
       
    private lazy var imageShadow: UIView = {
        let element = UIView(frame: CGRectMake(0, 0, 110, 110))
        element.layer.cornerRadius = element.frame.height / 2
        
        element.layer.shadowOpacity = 0.12
        element.layer.shadowRadius = 25
        element.layer.shadowColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.15).cgColor
        element.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dishImage: UIImageView = {
        let element = UIImageView(frame: CGRectMake(0, 0, 110, 110))
        element.image = UIImage(named: "marshmallow")
        element.contentMode = .scaleAspectFill
        element.layer.masksToBounds = true
        element.layer.cornerRadius = element.frame.height / 2
               	
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dishTitleLabel: UILabel = {
        let element = UILabel()
        element.text = "Mashmallow and rose wrap"
        element.numberOfLines = 0
        element.textAlignment = .center
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var timeLabel: UILabel = {
        let element = UILabel()
        element.text = "Time"
        element.textColor = .systemGray4
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cookingTimeLabel: UILabel = {
        let element = UILabel()
        element.text = "5 min"
        element.textColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var favoritesMark: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(resource: .bookmarkIco)
        element.contentMode = .scaleAspectFit
        element.backgroundColor = .white
        element.layer.cornerRadius = 12
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var background: UIView = {
        let element = UIView()
        element.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        element.layer.cornerRadius = 12
        
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
            
            contentView.layer.cornerRadius = 12
        
            contentView.addSubview(background)
            contentView.addSubview(imageShadow)
            contentView.addSubview(dishTitleLabel)
            contentView.addSubview(footerSectionView)
            
            imageShadow.addSubview(dishImage)
            footerSectionView.addSubview(timeLabel)
            footerSectionView.addSubview(cookingTimeLabel)
            footerSectionView.addSubview(favoritesMark)
            
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
                
                footerSectionView.topAnchor.constraint(equalTo: dishTitleLabel.bottomAnchor, constant: 16),
                footerSectionView.heightAnchor.constraint(equalToConstant: 40),
                footerSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                footerSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                
                favoritesMark.heightAnchor.constraint(equalToConstant: 24),
                favoritesMark.bottomAnchor.constraint(equalTo: footerSectionView.bottomAnchor),
                favoritesMark.trailingAnchor.constraint(equalTo: footerSectionView.trailingAnchor),
                
                timeLabel.topAnchor.constraint(equalTo: footerSectionView.topAnchor),
                timeLabel.leadingAnchor.constraint(equalTo: footerSectionView.leadingAnchor),
                
                cookingTimeLabel.bottomAnchor.constraint(equalTo: footerSectionView.bottomAnchor),
                cookingTimeLabel.leadingAnchor.constraint(equalTo: footerSectionView.leadingAnchor)
            ])
        }
}
