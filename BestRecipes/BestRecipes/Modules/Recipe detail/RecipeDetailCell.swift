//
//  RecipeDetailCell.swift
//  BestRecipes
//
//  Created by Ilnur on 18.08.2025.
//

import UIKit

class RecipeDetailCell: UITableViewCell {
    
    // MARK: - UI
    
    lazy var cellTitleLbl: UILabel = {
        let label = UILabel.create(font: .custom(.semibold, size: 16), color: .black)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    lazy var cellWeightLbl: UILabel = {
        let label = UILabel.create(font: .custom(.regular, size: 14), color: #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1))
        label.textAlignment = .right
        return label
    }()
    
    lazy var cellUnitLbl: UILabel = {
        let label = UILabel.create(font: .custom(.regular, size: 14), color: #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1))
        label.textAlignment = .right
        return label
    }()
    
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
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIImageView())
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        
        contentView.addSubview(cellView)
        contentView.addSubview(cellTitleLbl)
        contentView.addSubview(cellWeightLbl)
        contentView.addSubview(cellUnitLbl)
        contentView.addSubview(cellImage)
        
        cellWeightLbl.setContentHuggingPriority(.required, for: .horizontal)
        cellUnitLbl.setContentHuggingPriority(.required, for: .horizontal)
        cellTitleLbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        cellWeightLbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        cellUnitLbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        cellTitleLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        cellWeightLbl.text = nil
        cellTitleLbl.text = nil
        cellImage.image = nil
    }
    
    // MARK: - Configure
    
    func configure(with ingredient: Ingredient) {
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
    
    // MARK: - Layout
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            cellImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            cellImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            
            cellTitleLbl.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 16),
            cellTitleLbl.trailingAnchor.constraint(lessThanOrEqualTo: cellWeightLbl.leadingAnchor, constant: -16),
            cellTitleLbl.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),

            cellWeightLbl.trailingAnchor.constraint(equalTo: cellUnitLbl.leadingAnchor, constant: -4),
            cellWeightLbl.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),

            cellUnitLbl.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            cellUnitLbl.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
            
        ])
    }
    
    
}





