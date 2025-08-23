//
//  SeeAllViewController.swift
//  BestRecipes
//
//  Created by Nurislam on 19.08.2025.
//

import UIKit

final class SeeAllViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let titleFontSize: CGFloat = 24
        static let titleTopInset: CGFloat = 60
        static let titleHorizontalInset: CGFloat = 20
        static let backButtonSize: CGFloat = 44
        static let collectionTopInset: CGFloat = 20
        static let spacing: CGFloat = 16
        static let emptyStateTopInset: CGFloat = 100
        static let emptyStateHorizontalInset: CGFloat = 40
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "All Recipes"
        label.font = UIFont(name: "Poppins-Bold", size: Constants.titleFontSize)
        label.textColor = UIColor(named: "Neutral100") ?? .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "seeall_title"
        label.accessibilityLabel = "All recipes screen title"
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(named: "Neutral100") ?? .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "seeall_back_button"
        button.accessibilityLabel = "Back button"
        button.accessibilityHint = "Tap to go back to previous screen"
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.spacing + 8 // Увеличиваем расстояние между ячейками
        layout.minimumInteritemSpacing = Constants.spacing
        layout.sectionInset = UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: Constants.spacing + 16, right: Constants.spacing) // Увеличиваем нижний отступ
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DishCell.self, forCellWithReuseIdentifier: DishCell.cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "seeall_collection_view"
        collectionView.accessibilityLabel = "All recipes collection"
        
        return collectionView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "seeall_empty_state"
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
        label.accessibilityIdentifier = "seeall_empty_label"
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
        setupActions()
        loadMockData()
        updateUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back Button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopInset),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleHorizontalInset),
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonSize),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.titleHorizontalInset),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
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
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Loading
    private func loadMockData() {
        recipes = [
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Spaghetti Carbonara",
                readyInMinutes: 25,
                spoonacularScore: 85,
                aggregateLikes: 450,
                creditsText: "Chef John",
                cuisines: ["Italian"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Chicken Caesar Salad",
                readyInMinutes: 20,
                spoonacularScore: 78,
                aggregateLikes: 320,
                creditsText: "Chef Maria",
                cuisines: ["American"],
                dishTypes: ["salad"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Beef Tacos",
                readyInMinutes: 30,
                spoonacularScore: 82,
                aggregateLikes: 280,
                creditsText: "Chef Carlos",
                cuisines: ["Mexican"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Vegetarian Pizza",
                readyInMinutes: 35,
                spoonacularScore: 75,
                aggregateLikes: 390,
                creditsText: "Chef Anna",
                cuisines: ["Italian"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Grilled Salmon",
                readyInMinutes: 22,
                spoonacularScore: 88,
                aggregateLikes: 520,
                creditsText: "Chef David",
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
                aggregateLikes: 680,
                creditsText: "Chef Sarah",
                cuisines: ["American"],
                dishTypes: ["dessert"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Beef Steak",
                readyInMinutes: 25,
                spoonacularScore: 90,
                aggregateLikes: 550,
                creditsText: "Chef Michael",
                cuisines: ["American"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                title: "Pasta Primavera",
                readyInMinutes: 18,
                spoonacularScore: 80,
                aggregateLikes: 420,
                creditsText: "Chef Lisa",
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
extension SeeAllViewController: UICollectionViewDataSource {
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
extension SeeAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Constants.spacing * 3) / 2
        let height = width * 1.4 // Aspect ratio
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate
extension SeeAllViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        let detailVC = RecipeDetailViewController(recipe: recipe)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
