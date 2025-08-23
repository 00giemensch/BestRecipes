//
//  RecipeDetailViewController.swift
//  BestRecipes
//
//  Created by Ilnur on 14.08.2025.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let recipe: RecipeModel
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    lazy var scrollView: UIScrollView = {
        $0.addSubview(scrollContentView)
        $0.contentInsetAdjustmentBehavior = .never
        $0.alwaysBounceVertical = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        return $0
    }(UIScrollView())
    
    lazy var scrollContentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubviews(subtitleLbl, recipeView, hStackRating, titleInstructionsLbl, instructionsStepTextLbl, hStackIngridients, tableView)
        return $0
    }(UIView())
    
    lazy var subtitleLbl: UILabel = {
        let label = UILabel.create(font: .custom(.semibold, size: 24), color: .black)
        label.text = recipe.title
        label.numberOfLines = 3
        return label
    }()
    
    lazy var recipeView: UIView = {
        $0.backgroundColor = .red
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 18
        return $0
    }(UIView())
    
    lazy var ratingStarImg: UIImageView = {
        $0.image = UIImage(named: "starRate")
        $0.tintColor = .black
        return $0
    }(UIImageView())
    
    lazy var ratingNumberLbl: UILabel = {
        let label = UILabel.create(font: .custom(.regular, size: 14), color: .black)
        label.text = String(format: "%.1f", recipe.spoonacularScore / 10)
        return label
    }()
    
    lazy var reviewsLbl: UILabel = {
        let label = UILabel.create(font: .custom(.regular, size: 14), color: #colorLiteral(red: 0.5686, green: 0.5686, blue: 0.5686, alpha: 1))
        label.text = "(\(recipe.aggregateLikes) Reviews)"
        return label
    }()
    
    lazy var titleInstructionsLbl: UILabel = {
        let label = UILabel.create(font: .custom(.semibold, size: 20), color: .black)
        label.text = "Instructions"
        return label
    }()
    
    lazy var hStackRating: UIStackView = {
        let stack = UIStackView.create(spacing: 8)
        stack.distribution = .equalSpacing
        stack.widthAnchor.constraint(equalToConstant: 300)
        stack.addArrangedSubviews(ratingStarImg, ratingNumberLbl,reviewsLbl)
        return stack
    }()
    
    lazy var instructionsStepTextLbl: UILabel = {
        let label = UILabel.create(font: .custom(.regular, size: 16), color: .black)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var titleIngredientsLbl: UILabel = {
        let label = UILabel.create(font: .custom(.semibold, size: 20), color: .black)
        label.text = "Ingredients"
        return label
    }()
        
    lazy var itemsLbl: UILabel = {
        let label = UILabel.create(font: .custom(.regular, size: 14),
                                   color: #colorLiteral(red: 0.5686, green: 0.5686, blue: 0.5686, alpha: 1))
        label.text = "\(recipe.extendedIngredients.count) items"
        return label
    }()
    
    lazy var hStackIngridients: UIStackView = {
        let stack = UIStackView.create(spacing: 8)
        stack.distribution = .equalSpacing
        stack.widthAnchor.constraint(equalToConstant: 300)
        stack.addArrangedSubviews(titleIngredientsLbl, itemsLbl)
        return stack
    }()
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(RecipeDetailCell.self, forCellReuseIdentifier: "RecipeDetailCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = 90
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        return $0
    }(UITableView())
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recipe detail"
        view.addSubview(scrollView)
        setupConstr()
        configureUI()
        
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        subtitleLbl.text = recipe.title
        
        // Image
        let recipeImageView = UIImageView()
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 18
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeView.addSubview(recipeImageView)
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: recipeView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: recipeView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: recipeView.trailingAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: recipeView.bottomAnchor)
        ])
        
        NetworkManager.shared.loadImage(from: recipe.image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    recipeImageView.image = image
                case .failure:
                    recipeImageView.image = UIImage(named: "defaultSearch")
                }
            }
        }
        
        // Ratings
        ratingNumberLbl.text = String(format: "%.1f", recipe.spoonacularScore / 10)
        reviewsLbl.text = "(\(recipe.aggregateLikes) Reviews)"
        
        // Instructions
        let steps = recipe.analyzedInstructions.first?.steps ?? []
        let instructionsText = steps.enumerated().map { "\($0.offset + 1). \($0.element.step)\n" }.joined()
        instructionsStepTextLbl.text = instructionsText.isEmpty ? "Инструкции отсутствуют" : instructionsText
        
        // Ingredients
        itemsLbl.text = "\(recipe.extendedIngredients.count) items"
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    // MARK: - Layout
    
    func setupConstr() {
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            subtitleLbl.topAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            subtitleLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            subtitleLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            recipeView.topAnchor.constraint(equalTo: subtitleLbl.bottomAnchor, constant: 16),
            recipeView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            recipeView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            recipeView.heightAnchor.constraint(equalTo: scrollContentView.widthAnchor, multiplier: 0.5),
            
            hStackRating.topAnchor.constraint(equalTo: recipeView.bottomAnchor, constant: 16),
            hStackRating.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            hStackRating.heightAnchor.constraint(equalToConstant: 20),
            
            titleInstructionsLbl.topAnchor.constraint(equalTo: hStackRating.bottomAnchor, constant: 16),
            titleInstructionsLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            titleInstructionsLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
            
            instructionsStepTextLbl.topAnchor.constraint(equalTo: titleInstructionsLbl.bottomAnchor, constant: 8),
            instructionsStepTextLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 32),
            instructionsStepTextLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -32),
            
            hStackIngridients.topAnchor.constraint(equalTo: instructionsStepTextLbl.bottomAnchor, constant: 31),
            hStackIngridients.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            hStackIngridients.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: hStackIngridients.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -115)
        ])
    }
    
    
}

// MARK: - UITableViewDataSource

extension RecipeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailCell", for: indexPath) as? RecipeDetailCell else {
            return UITableViewCell()
        }
        
        //
        cell.configure(with: recipe.extendedIngredients[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipe.extendedIngredients.count
    }
}
// MARK: - UITableViewDelegate & UIScrollViewDelegate
extension RecipeDetailViewController: UITableViewDelegate {}
extension RecipeDetailViewController: UIScrollViewDelegate {}

