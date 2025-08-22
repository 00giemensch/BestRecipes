//
//  RecipeDetailCell.swift
//  BestRecipes
//
//  Created by Ilnur on 18.08.2025.
//

import UIKit

class RecipeDetailCell: UITableViewCell {
  

// Lbls
    lazy var cellTitleLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Poppins-SemiBold", size: 16)
        $0.font = .custom(.semibold, size: 16)
        $0.textColor = .black
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    lazy var cellWeightLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Poppins-Regular", size: 14)
        $0.font = .custom(.regular, size: 14)
        $0.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
        $0.textAlignment = .right
        $0.text = "200"
        return $0
    }(UILabel())
    
    lazy var cellUnitLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "Poppins-Regular", size: 14)
        $0.font = .custom(.regular, size: 14)
        $0.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
        $0.textAlignment = .right
        $0.text = "g"
        return $0
    }(UILabel())
//
    
    lazy var cellView: UIView = {
        $0.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        return $0
    }(UIView())

    
    lazy var cellImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 53).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 53).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "defaultSearch")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .red
        return $0
    }(UIImageView())
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        
        contentView.addSubview(cellView)
        contentView.addSubview(cellTitleLbl) // Ingredient/name
        contentView.addSubview(cellWeightLbl) // Ingredient/amount
        contentView.addSubview(cellUnitLbl) // Ingredient/unit - для грамм
        contentView.addSubview(cellImage) // Ingredient/image
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        cellWeightLbl.text = nil
        cellTitleLbl.text = nil
        cellImage.image = nil
    }
     
    func configure(with ingredient: Ingredient) { //'Ingredient' is not a member type of struct 'BestRecipes.RecipeModel'
            cellTitleLbl.text = ingredient.name
            cellWeightLbl.text = String(format: "%.2f", ingredient.amount)
            cellUnitLbl.text = ingredient.unit.isEmpty ? "" : ingredient.unit

            NetworkManager.shared.loadIngredientImage(imageName: ingredient.image) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self?.cellImage.image = image
                    case .failure:
                        self?.cellImage.image = UIImage(named: "defaultSearch")
                    }
                }
            }
        }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            cellImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            cellImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),

            
            cellTitleLbl.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 16),
            cellTitleLbl.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            
            cellUnitLbl.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            cellUnitLbl.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            
            cellWeightLbl.trailingAnchor.constraint(equalTo: cellUnitLbl.leadingAnchor, constant: 0),
            cellWeightLbl.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)

        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

    

     

