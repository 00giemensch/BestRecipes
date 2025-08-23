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
        static let titleFontSize: CGFloat = 24
        static let titleTopInset: CGFloat = 60
        static let titleHorizontalInset: CGFloat = 20
        static let collectionTopInset: CGFloat = 20
        static let spacing: CGFloat = 16
        static let emptyStateTopInset: CGFloat = 100
        static let emptyStateHorizontalInset: CGFloat = 40
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.font = UIFont(name: "Poppins-Bold", size: Constants.titleFontSize)
        label.textColor = UIColor(named: "Neutral100") ?? .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "discover_title"
        label.accessibilityLabel = "Discover screen title"
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.spacing
        layout.minimumInteritemSpacing = Constants.spacing
        layout.sectionInset = UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: Constants.spacing, right: Constants.spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DishCell.self, forCellWithReuseIdentifier: DishCell.cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "discover_collection_view"
        collectionView.accessibilityLabel = "Discover recipes collection"
        
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
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleHorizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.titleHorizontalInset),
            
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
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Grilled Salmon",
                readyInMinutes: 25,
                spoonacularScore: 88,
                aggregateLikes: 120,
                creditsText: "Chef John",
                cuisines: ["Mediterranean"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Chocolate Cake",
                readyInMinutes: 60,
                spoonacularScore: 92,
                aggregateLikes: 200,
                creditsText: "Baking Master",
                cuisines: ["American"],
                dishTypes: ["dessert"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Beef Steak",
                readyInMinutes: 30,
                spoonacularScore: 90,
                aggregateLikes: 150,
                creditsText: "Grill Master",
                cuisines: ["American"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Pasta Primavera",
                readyInMinutes: 20,
                spoonacularScore: 80,
                aggregateLikes: 80,
                creditsText: "Italian Chef",
                cuisines: ["Italian"],
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
        let isItInFavorites = false // Mock data for favorites
        
        cell.configure(with: recipe, isItInFavorites)
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
        let width = (collectionView.bounds.width - Constants.spacing * 3) / 2
        let height = width * 1.4 // Aspect ratio
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
