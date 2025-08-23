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
        static let columnSpacing: CGFloat = 16
        static let sectionInset: CGFloat = 16
        static let aspectRatio: CGFloat = 1.4
        static let columnsCount: CGFloat = 2
        static let titleTopInset: CGFloat = 16
        static let titleHorizontalInset: CGFloat = 16
        static let collectionTopInset: CGFloat = 16
        static let backButtonSize: CGFloat = 24
    }
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.columnSpacing
        layout.minimumInteritemSpacing = Constants.columnSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.sectionInset, left: Constants.sectionInset, bottom: Constants.sectionInset, right: Constants.sectionInset)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCardCell.self, forCellWithReuseIdentifier: "RecipeCardCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "All Recipes"
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textColor = UIColor(named: "Neutral100") ?? .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "all_recipes_title"
        label.accessibilityLabel = "All recipes"
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(named: "Neutral100") ?? .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "back_button"
        button.accessibilityLabel = "Back"
        button.accessibilityHint = "Go back to previous screen"
        return button
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
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back Button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopInset),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleHorizontalInset),
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonSize),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: Constants.titleHorizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.titleHorizontalInset),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.collectionTopInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Loading
    private func loadMockData() {
        // Моковые данные для демо
        recipes = [
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/1-556x370.jpg",
                title: "Spaghetti Carbonara",
                readyInMinutes: 25,
                spoonacularScore: 85.0,
                aggregateLikes: 450,
                creditsText: "Chef John",
                cuisines: ["Italian"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/2-556x370.jpg",
                title: "Chicken Caesar Salad",
                readyInMinutes: 20,
                spoonacularScore: 78.0,
                aggregateLikes: 320,
                creditsText: "Chef Maria",
                cuisines: ["American"],
                dishTypes: ["salad"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/3-556x370.jpg",
                title: "Beef Tacos",
                readyInMinutes: 30,
                spoonacularScore: 82.0,
                aggregateLikes: 280,
                creditsText: "Chef Carlos",
                cuisines: ["Mexican"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/4-556x370.jpg",
                title: "Vegetarian Pizza",
                readyInMinutes: 35,
                spoonacularScore: 75.0,
                aggregateLikes: 390,
                creditsText: "Chef Anna",
                cuisines: ["Italian"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/5-556x370.jpg",
                title: "Grilled Salmon",
                readyInMinutes: 22,
                spoonacularScore: 88.0,
                aggregateLikes: 520,
                creditsText: "Chef David",
                cuisines: ["Mediterranean"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/6-556x370.jpg",
                title: "Chocolate Cake",
                readyInMinutes: 60,
                spoonacularScore: 92.0,
                aggregateLikes: 680,
                creditsText: "Chef Sarah",
                cuisines: ["American"],
                dishTypes: ["dessert"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/7-556x370.jpg",
                title: "Beef Steak",
                readyInMinutes: 25,
                spoonacularScore: 90.0,
                aggregateLikes: 550,
                creditsText: "Chef Michael",
                cuisines: ["American"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/8-556x370.jpg",
                title: "Pasta Primavera",
                readyInMinutes: 18,
                spoonacularScore: 80.0,
                aggregateLikes: 420,
                creditsText: "Chef Lisa",
                cuisines: ["Italian"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/9-556x370.jpg",
                title: "Mushroom Risotto",
                readyInMinutes: 40,
                spoonacularScore: 85.0,
                aggregateLikes: 380,
                creditsText: "Chef Marco",
                cuisines: ["Italian"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/10-556x370.jpg",
                title: "Fish and Chips",
                readyInMinutes: 35,
                spoonacularScore: 78.0,
                aggregateLikes: 290,
                creditsText: "Chef James",
                cuisines: ["British"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/11-556x370.jpg",
                title: "Chicken Curry",
                readyInMinutes: 45,
                spoonacularScore: 88.0,
                aggregateLikes: 610,
                creditsText: "Chef Priya",
                cuisines: ["Indian"],
                dishTypes: ["main course"],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
            RecipeModel(
                image: "https://spoonacular.com/recipeImages/12-556x370.jpg",
                title: "Apple Pie",
                readyInMinutes: 90,
                spoonacularScore: 95.0,
                aggregateLikes: 720,
                creditsText: "Chef Grandma",
                cuisines: ["American"],
                dishTypes: ["dessert"],
                extendedIngredients: [],
                analyzedInstructions: []
            )
        ]
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SeeAllViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCardCell", for: indexPath) as? RecipeCardCell else {
            fatalError("RecipeCardCell not found")
        }
        cell.configure(with: recipes[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SeeAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = Constants.columnSpacing * (Constants.columnsCount - 1) + Constants.sectionInset * 2
        let width = (collectionView.bounds.width - totalSpacing) / Constants.columnsCount
        let height = width * Constants.aspectRatio
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
