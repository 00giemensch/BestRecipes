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
        static let columnSpacing: CGFloat = 16
        static let sectionInset: CGFloat = 16
        static let aspectRatio: CGFloat = 1.4
        static let columnsCount: CGFloat = 2
        static let titleTopInset: CGFloat = 16
        static let titleHorizontalInset: CGFloat = 16
        static let collectionTopInset: CGFloat = 16
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
        label.text = "Discover"
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textColor = UIColor(named: "Neutral100") ?? .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No recipes found"
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.textColor = UIColor(named: "Neutral50") ?? .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.collectionTopInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.collectionTopInset),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State Label
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
        ])
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
            )
        ]
        updateUI()
    }
    
    private func updateUI() {
        if recipes.isEmpty {
            emptyStateView.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyStateView.isHidden = true
            collectionView.isHidden = false
        }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension DiscoverViewController: UICollectionViewDataSource {
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
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = Constants.columnSpacing * (Constants.columnsCount - 1) + Constants.sectionInset * 2
        let width = (collectionView.bounds.width - totalSpacing) / Constants.columnsCount
        let height = width * Constants.aspectRatio
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
