//
//  ViewController.swift
//  Popular category Collection
//
//  Created by Никита Грицунов on 12.08.2025.
//

import UIKit

class PopularCategoryViewController: UIViewController {

    private enum Drawings {
        static var popularCategoryTitle: String { "Popular category" }
        static var popCatTitleLabelHeight: CGFloat { 28 }
        
        static var popularCategoryStackSpacing: CGFloat { 19 }
        
        static var popCatCollectionViewHeight: CGFloat { 231 }
        static var collectionViewCellSize: CGSize {CGSize(width: 150, height: 231)}
        
        static var buttonStackSpacing: CGFloat { 8 }
        static var buttonsScrollViewHeight: CGFloat { 34 }
        static var buttonsScrollViewPadding: CGFloat { 16 }
        static var categoryButtonsPadding: NSDirectionalEdgeInsets { NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12) }
        static var categoryButtonNormalBackgroundColor: UIColor { UIColor.white }
        static var categoryButtonNormalForegroundColor: UIColor { UIColor(red: 243/255, green: 178/255, blue: 178/255, alpha: 1) }
        static var categoryButtonRadius: CGFloat { 10 }
        static var categoryButtonSelectedBackgroundColor: UIColor { UIColor(red: 226/255, green: 62/255, blue: 62/255, alpha: 1) }
        static var categoryButtonSelectedForegroundColor: UIColor { UIColor.white }
        static var categoryButtonAnimationDuration: CGFloat { 0.2 }
    }
    
    
//MARK: - Properties
    var selectedButton: UIButton?
  
//MARK: - UI
    private lazy var popularCategoryMainStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = Drawings.popularCategoryStackSpacing
        element.distribution = .fillProportionally
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var popularCategoryTitleLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.custom(.semibold, size: 20)
        element.text = Drawings.popularCategoryTitle
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var popularCategoryCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.itemSize = CGSize(width: 150, height: 231)
        viewLayout.scrollDirection = .horizontal
        
        let element = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        element.showsHorizontalScrollIndicator = false
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // Элементы ScrollView
    private lazy var dishCategoriesScrollView: UIScrollView = {
        let element = UIScrollView()
        
        element.showsHorizontalScrollIndicator = false
        element.showsVerticalScrollIndicator = false
//        element.backgroundColor = .red
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var categoriesButtonsStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = Drawings.buttonStackSpacing
        element.distribution = .fillProportionally
//        element.backgroundColor = .green
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
       
//MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularCategoryCollectionView.delegate = self
        popularCategoryCollectionView.dataSource = self
        popularCategoryCollectionView.register(PopularCategoryCell.self, forCellWithReuseIdentifier: PopularCategoryCell.identifier)
        
        setViews()
        setupConstraints()
    }
    
//MARK: - Set Views and Setup Constraints
    private func setViews() {
        
        view.backgroundColor = .white
        view.addSubview(popularCategoryMainStack)
     
        popularCategoryMainStack.addArrangedSubview(popularCategoryTitleLabel)
        popularCategoryMainStack.addArrangedSubview(dishCategoriesScrollView)
        popularCategoryMainStack.addArrangedSubview(popularCategoryCollectionView)
        
        dishCategoriesScrollView.addSubview(categoriesButtonsStack)
        addButtons()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            popularCategoryMainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            popularCategoryMainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popularCategoryMainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            popularCategoryTitleLabel.heightAnchor.constraint(equalToConstant: Drawings.popCatTitleLabelHeight),
            
            dishCategoriesScrollView.heightAnchor.constraint(equalToConstant: Drawings.buttonsScrollViewHeight),
            
            categoriesButtonsStack.topAnchor.constraint(equalTo: dishCategoriesScrollView.topAnchor),
            categoriesButtonsStack.bottomAnchor.constraint(equalTo: dishCategoriesScrollView.bottomAnchor),
            categoriesButtonsStack.leadingAnchor.constraint(equalTo: dishCategoriesScrollView.leadingAnchor, constant: Drawings.buttonsScrollViewPadding),
            categoriesButtonsStack.trailingAnchor.constraint(equalTo: dishCategoriesScrollView.trailingAnchor, constant: -Drawings.buttonsScrollViewPadding),
            categoriesButtonsStack.heightAnchor.constraint(equalTo: dishCategoriesScrollView.heightAnchor),
            
            popularCategoryCollectionView.heightAnchor.constraint(equalToConstant: Drawings.popCatCollectionViewHeight)
        ])
    }
    
}

//MARK: - Extension UICollectionViewDataSource

extension PopularCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCategoryCell.identifier, for: indexPath) as! PopularCategoryCell
    
        return cell
    }
}

//MARK: - Extension UICollectionViewDelegate

extension PopularCategoryViewController: UICollectionViewDelegate {
    
}

//MARK: - Extension UICollectionViewDelegateFlowLayout

extension PopularCategoryViewController: UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Drawings.collectionViewCellSize
    }
}
//MARK: - Extension ViewController with scrollView

extension PopularCategoryViewController {
    private func addButtons(with categories: [String] = ["Salad", "Breakfast", "Appetizer", "Noodle", "Pankake", "Marshmallow"]) {
        
        for (index, category) in categories.enumerated() {
            let button: UIButton = {
                
                // Настраиваем первоначальное оборажение кнопки
                var buttonConfiguration = UIButton.Configuration.filled()
                buttonConfiguration.title = "\(category)"
                buttonConfiguration.attributedTitle?.font = UIFont.custom(.semibold, size: 12)
                buttonConfiguration.contentInsets = Drawings.categoryButtonsPadding
                buttonConfiguration.baseBackgroundColor = Drawings.categoryButtonNormalBackgroundColor
                buttonConfiguration.baseForegroundColor = Drawings.categoryButtonNormalForegroundColor
                buttonConfiguration.background.cornerRadius = Drawings.categoryButtonRadius
                
                let button = UIButton(configuration: buttonConfiguration)
                button.tag = index

                button.translatesAutoresizingMaskIntoConstraints = false
                
                //Обновляем отображение кнопки при смене состояния
                button.configurationUpdateHandler = { button in
                    var updatedConfiguration = button.configuration
                    
                    switch button.state {
                    case .selected:
                        updatedConfiguration?.baseBackgroundColor = Drawings.categoryButtonSelectedBackgroundColor
                        updatedConfiguration?.baseForegroundColor = Drawings.categoryButtonSelectedForegroundColor
                    case .normal:
                        updatedConfiguration?.baseBackgroundColor = Drawings.categoryButtonNormalBackgroundColor
                        updatedConfiguration?.baseForegroundColor = Drawings.categoryButtonNormalForegroundColor
                    default:
                        break
                    }
                    
                    // Анимация изменения отображения кнопки
                    UIView.transition(with: button, duration: Drawings.categoryButtonAnimationDuration, options: .transitionCrossDissolve) {
                        button.configuration = updatedConfiguration
                    }
                }
                button.addTarget(self, action: #selector(updatePopularCategoryCV), for: .touchUpInside)
                
                return button
            }()
            categoriesButtonsStack.addArrangedSubview(button)
        }
    }
    
    
    @objc private func updatePopularCategoryCV(_ sender: UIButton) {
        selectedButton?.isSelected = false
        selectedButton = sender
        
        sender.isSelected = true
    }
    
}


        

