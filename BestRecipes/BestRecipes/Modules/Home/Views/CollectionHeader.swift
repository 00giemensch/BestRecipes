//
//  SeeAllButton.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 23.08.2025.
//

import UIKit

class CollectionHeader: UIView {
    //MARK: - Properties
    var action: (() -> Void)?
    private var addBatton: Bool
    //MARK: - UI Components
    private let button = UIButton()
    private let hedderView = UIView()
    private let titleLabel = UILabel()
    
    //MARK: - Lifecycle
    init(_ isNeedBatton: Bool = true) {
        self.addBatton = isNeedBatton
        super.init(frame: .zero)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    @objc private func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    //MARK: - Setup Layout
    private func setupLayout() {
        headerView()
        setupTitleLabel()
        setupButton()
    }
    private func headerView() {
        self.addSubview(hedderView)
        hedderView.backgroundColor = .white
        hedderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hedderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hedderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hedderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hedderView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    private func setupTitleLabel() {
        hedderView.addSubview(titleLabel)
        titleLabel.font = UIFont.custom(.bold, size: 20)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: hedderView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: hedderView.leadingAnchor)
        ])
    }
    private func setupButton() {
        guard addBatton else { return }
        self.addSubview(button)
        let titleText = NSMutableAttributedString()
        let attributes : [NSAttributedString.Key: Any] = [
            .font: UIFont.custom(.bold, size: 14),
            .foregroundColor: UIColor.red
        ]
        titleText.append(NSAttributedString(string: "See All ", attributes: attributes))
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "arrow.forward")?.applyingSymbolConfiguration(.init(pointSize: 15))
        let imageString = NSAttributedString(attachment: attachment)
        titleText.append(imageString)
        
        button.setAttributedTitle(titleText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
