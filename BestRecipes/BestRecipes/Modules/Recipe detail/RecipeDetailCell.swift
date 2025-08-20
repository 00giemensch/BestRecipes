//
//  RecipeDetailCell.swift
//  BestRecipes
//
//  Created by Ilnur on 18.08.2025.
//

import UIKit

class RecipeDetailCell: UITableViewCell {

    var completion: ( () -> Void )?
    
    

    
// Lbls
    lazy var cellTitleLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.text = "dasd"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    lazy var cellPriceLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .systemGreen
        $0.textAlignment = .right
        $0.text = "dasd"
        return $0
    }(UILabel())
//
    
    lazy var cellView: UIView = {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return $0
    }(UIView())

    
    lazy var cellImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 80).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 80).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "defaultSearch")
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        
        contentView.addSubview(cellTitleLbl)
        contentView.addSubview(cellPriceLbl)
        contentView.addSubview(cellImage)
        setupConstraints()
    }
    
    override func prepareForReuse() {
        cellImage.image = nil
        cellTitleLbl.text = nil
    }
     
    
    func setupCell(item: RecipeModel) {
        cellTitleLbl.text = item.title
        
        NetworkManager.shared.loadImage(from: item.image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.cellImage.image = image
                case .failure:
                    self?.cellImage.image = nil // или поставить плейсхолдер
                }
            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            
            cellTitleLbl.topAnchor.constraint(equalTo: cellImage.topAnchor,constant: 12),
            cellTitleLbl.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 16),
            cellTitleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            cellPriceLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellPriceLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellPriceLbl.widthAnchor.constraint(equalToConstant: 80),
            
            cellTitleLbl.trailingAnchor.constraint(equalTo: cellPriceLbl.leadingAnchor, constant: -8),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

    

     

