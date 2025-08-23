//
//  DiscoverViewController.swift
//  BestRecipes
//
//  Created by Nurislam on 19.08.2025.
//

import UIKit

final class DiscoverViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let titleFontSize: CGFloat = 20 // Уменьшаем размер шрифта заголовка
        static let titleTopInset: CGFloat = 16 // Уменьшаем отступ сверху
        static let titleHorizontalInset: CGFloat = 16 // По Figma: (375 - 343) / 2 = 16
        static let collectionTopInset: CGFloat = 12 // Уменьшаем отступ между заголовком и коллекцией
        static let spacing: CGFloat = 16
        static let emptyStateTopInset: CGFloat = 100
        static let emptyStateHorizontalInset: CGFloat = 40
        static let cardHeight: CGFloat = 258 // По Figma
        static let imageHeight: CGFloat = 180 // По Figma
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved recipes"
        label.font = UIFont(name: "Poppins-SemiBold", size: Constants.titleFontSize)
        label.textColor = UIColor(named: "Neutral100") ?? .black
        label.textAlignment = .center // По Figma - центрирован
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "saved_recipes_title"
        label.accessibilityLabel = "Saved recipes screen title"
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20 // Оптимальное расстояние между ячейками
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16) // Уменьшаем отступы
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DishCell.self, forCellWithReuseIdentifier: DishCell.cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "saved_recipes_collection_view"
        collectionView.accessibilityLabel = "Saved recipes collection"
        
        return collectionView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "discover_empty_state"
        view.accessibilityLabel = "No recipes available"
        return view
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No recipes found"
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.textColor = UIColor(named: "Neutral50") ?? .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "discover_empty_label"
        label.accessibilityLabel = "No recipes found message"
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // MARK: - Data
    private var recipes: [RecipeModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadMockData()
        updateUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleHorizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.titleHorizontalInset),
            titleLabel.heightAnchor.constraint(equalToConstant: 29) // По Figma: 29px высота
        ])
        
        NSLayoutConstraint.activate([
            // CollectionView
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.collectionTopInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Empty State
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.emptyStateHorizontalInset),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.emptyStateHorizontalInset),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadMockData() {
        recipes = [
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg", // Бургер с яйцом
                title: "How to make sharwama at home",
                readyInMinutes: 15,
                spoonacularScore: 100, // 5.0 звезды (100/100)
                aggregateLikes: 120,
                creditsText: "Zeelicious Foods",
                cuisines: ["Middle Eastern"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716426-556x370.jpg", // Яичница
                title: "How to make sharwama at home",
                readyInMinutes: 15,
                spoonacularScore: 100, // 5.0 звезды (100/100)
                aggregateLikes: 200,
                creditsText: "Zeelicious Foods",
                cuisines: ["Middle Eastern"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716428-556x370.jpg", // Лосось
                title: "How to make sharwama at home",
                readyInMinutes: 15,
                spoonacularScore: 100, // 5.0 звезды (100/100)
                aggregateLikes: 150,
                creditsText: "Zeelicious Foods",
                cuisines: ["Middle Eastern"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716427-556x370.jpg", // Разное блюдо
                title: "How to make sharwama at home",
                readyInMinutes: 15,
                spoonacularScore: 100, // 5.0 звезды (100/100)
                aggregateLikes: 180,
                creditsText: "Zeelicious Foods",
                cuisines: ["Middle Eastern"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716425-556x370.jpg", // Еще одно блюдо
                title: "How to make sharwama at home",
                readyInMinutes: 15,
                spoonacularScore: 100, // 5.0 звезды (100/100)
                aggregateLikes: 220,
                creditsText: "Zeelicious Foods",
                cuisines: ["Middle Eastern"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            )
        ]
    }
    
    private func updateUI() {
        emptyStateView.isHidden = !recipes.isEmpty
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.cellId, for: indexPath) as! DishCell
        let recipe = recipes[indexPath.item]
        let isItInFavorites = true // Все рецепты сохранены (как на макете)
        
        cell.configure(with: recipe, isItInFavorites, showMinusIcon: true) // Показываем минус для Saved recipes
        cell.favoriteButtonAction = { [weak self] in
            // Handle favorite action
            print("Favorite tapped for: \(recipe.title)")
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // 16px отступы с каждой стороны = 343px
        let height: CGFloat = 240 // Уменьшаем высоту карточки для более компактного вида
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate
extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        let detailVC = RecipeDetailViewController(recipe: recipe)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
