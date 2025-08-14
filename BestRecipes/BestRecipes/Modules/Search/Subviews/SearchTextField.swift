//
//  SearchTextField.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 14.08.2025.
//

import UIKit

protocol SearchTextFieldDelegate: AnyObject {
    func closeButtonTapped()
}

final class SearchTextField: UITextField {
    
    // MARK: - Dependencies
    weak var searchDelegate: SearchTextFieldDelegate?
    
    // MARK: - UI Elements
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .searchBlack
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    // MARK: - Setup
    private func setupTextField() {
        backgroundColor = .white
        textColor = .searchBlack
        font = UIFont.custom(.regular, size: 14)
        borderStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.searchBarGray.cgColor
        
        placeholder = "Search recipes"
        attributedPlaceholder = NSAttributedString(
            string: "Search recipes",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.searchBarGray,
                NSAttributedString.Key.font: UIFont.custom(.regular, size: 14)
            ]
        )
        
        let searchIcon = UIImageView(image: UIImage(named: "searchIcon")?
            .withRenderingMode(.alwaysTemplate))
        searchIcon.tintColor = .searchBlack
        searchIcon.contentMode = .scaleAspectFit
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        leftView.addSubview(searchIcon)
        searchIcon.frame = CGRect(x: 12, y: 0, width: 20, height: 44)
        
        self.leftView = leftView
        self.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        rightView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: rightView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        self.rightView = rightView
        self.rightViewMode = .always
        
        clearButtonMode = .never
        returnKeyType = .search
        autocorrectionType = .no
        autocapitalizationType = .none
        
        closeButton.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func closeButtonTapped() {
        searchDelegate?.closeButtonTapped()
    }
    
    // MARK: - Override methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 36, height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 44, y: 0, width: 44, height: bounds.height)
    }
} 
