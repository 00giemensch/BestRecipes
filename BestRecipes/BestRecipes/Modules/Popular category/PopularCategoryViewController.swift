//
//  ViewController.swift
//  Popular category Collection
//
//  Created by Никита Грицунов on 12.08.2025.
//

import UIKit

class ViewController: UIViewController {
//MARK: - Properties
    var selectedButton: UIButton?
  
//MARK: - UI
    private lazy var popularCategoryMainStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 19
        element.distribution = .fillProportionally
        
        element.backgroundColor = .lightGray
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var blockTitleLabel: UILabel = {
        let element = UILabel()
        element.text = "Popular category"
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var popularCategoryCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let element = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        element.backgroundColor = .brown
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
        element.spacing = 8
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
    
//MARK: - Set Views and Setup Constaraints
    private func setViews() {
        
        view.backgroundColor = .white
        view.addSubview(popularCategoryMainStack)
     
        popularCategoryMainStack.addArrangedSubview(blockTitleLabel)
        popularCategoryMainStack.addArrangedSubview(dishCategoriesScrollView)
        
        dishCategoriesScrollView.addSubview(categoriesButtonsStack)
        addButtons()
        
        popularCategoryMainStack.addArrangedSubview(popularCategoryCollectionView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
              
//            popularCategoryMainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            popularCategoryMainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            popularCategoryMainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            blockTitleLabel.heightAnchor.constraint(equalToConstant: 28),
//            
////            dishCategoriesScrollView.topAnchor.constraint(equalTo: blockTitleLabel.bottomAnchor),
//            dishCategoriesScrollView.heightAnchor.constraint(equalToConstant: 34),
////            dishCategoriesScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////            dishCategoriesScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            categoriesButtonsStack.topAnchor.constraint(equalTo: dishCategoriesScrollView.topAnchor),
//            categoriesButtonsStack.bottomAnchor.constraint(equalTo: dishCategoriesScrollView.bottomAnchor),
//            categoriesButtonsStack.leadingAnchor.constraint(equalTo: dishCategoriesScrollView.leadingAnchor),
//            categoriesButtonsStack.trailingAnchor.constraint(equalTo: dishCategoriesScrollView.trailingAnchor),
//            
//            popularCategoryCollectionView.topAnchor.constraint(equalTo: dishCategoriesScrollView.bottomAnchor),
//            popularCategoryCollectionView.bottomAnchor.constraint(equalTo: popularCategoryMainStack.bottomAnchor),
//            popularCategoryCollectionView.leadingAnchor.constraint(equalTo: popularCategoryMainStack.leadingAnchor),
//            popularCategoryCollectionView.trailingAnchor.constraint(equalTo: popularCategoryMainStack.trailingAnchor),
            
            
            
            popularCategoryMainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            popularCategoryMainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popularCategoryMainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popularCategoryMainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            blockTitleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            dishCategoriesScrollView.heightAnchor.constraint(equalToConstant: 34),
            
            categoriesButtonsStack.topAnchor.constraint(equalTo: dishCategoriesScrollView.topAnchor),
            categoriesButtonsStack.bottomAnchor.constraint(equalTo: dishCategoriesScrollView.bottomAnchor),
            categoriesButtonsStack.leadingAnchor.constraint(equalTo: dishCategoriesScrollView.leadingAnchor, constant: 16),
            categoriesButtonsStack.trailingAnchor.constraint(equalTo: dishCategoriesScrollView.trailingAnchor, constant: -16),
            categoriesButtonsStack.heightAnchor.constraint(equalTo: dishCategoriesScrollView.heightAnchor),
            
            popularCategoryCollectionView.heightAnchor.constraint(equalToConstant: 231)
            
            
            
        ])
    }
    
}

//MARK: - Extension UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
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

extension ViewController: UICollectionViewDelegate {
    
}

//MARK: - Extension UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = itemWidth(for: view.frame.width, spacing: 16)
        
        return CGSize(width: 150, height: 231)
    }
    
//    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
//            let itemsInRow: CGFloat = 3
//
//            let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
//            let finalWidth = (width - totalSpacing) / itemsInRow
//
//            return floor(finalWidth)
//        }
}
//MARK: - Extension ViewController with scrollView

extension ViewController {
    private func addButtons(with categories: [String] = ["Компот", "Каша", "Торт", "Cok", "Pankake", "Marshmallow"]) {
        
        for (index, category) in categories.enumerated() {
            let button: UIButton = {
                
                // Настраиваем первоначальное оборажение кнопки
                var buttonConfiguration = UIButton.Configuration.filled()
                buttonConfiguration.title = "\(category)"
                buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
                buttonConfiguration.baseBackgroundColor = .white
                buttonConfiguration.baseForegroundColor = UIColor(red: 243/255, green: 178/255, blue: 178/255, alpha: 1)
                buttonConfiguration.background.cornerRadius = 10
                
                let button = UIButton(configuration: buttonConfiguration)
                button.tag = index
                button.translatesAutoresizingMaskIntoConstraints = false
                
                //Обновляем отображение кнопки при смене состояния
                button.configurationUpdateHandler = { button in
                    var updatedConfiguration = button.configuration
                    
                    switch button.state {
                    case .selected:
                        updatedConfiguration?.baseBackgroundColor = UIColor(red: 226/255, green: 62/255, blue: 62/255, alpha: 1)
                        updatedConfiguration?.baseForegroundColor = .white
                    case .normal:
                        updatedConfiguration?.baseBackgroundColor = .white
                        updatedConfiguration?.baseForegroundColor = UIColor(red: 243/255, green: 178/255, blue: 178/255, alpha: 1)
                    default:
                        break
                    }
                    
                    // Анимация изменения отображения кнопки
                    UIView.transition(with: button, duration: 0.2, options: .transitionCrossDissolve) {
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


        

