//
//  RecipeDetailViewController.swift
//  BestRecipes
//
//  Created by Ilnur on 14.08.2025.
//

import UIKit

struct IngredientItem {
    let title: String
    let image: String
}

class RecipeDetailViewController: UIViewController {
    
   
    /*
    отсюда приходит название рецепт(из recent recipe).
    передается от туда же картинка.
    эта модель для шапки экрана(название+картинка рецепта).
    */
    let recipe: Recipe

    
    // тестовые данные для верстки таблицы
    private var mockTableData: [IngredientItem] = []
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        $0.addSubviews(subtitleLbl, recipeVw, hStackRating, titleInstructionsLbl, instructionsStepNumberLbl, instructionsStepTextLbl, footerInstructionsLbl, hStackIngridients, tableView)
        return $0
    }(UIView())
    
    
    lazy var subtitleLbl: UILabel = {
        $0.text = recipe.title
        $0.font = .custom(.semibold, size: 24)
        $0.textColor = .black
        $0.numberOfLines = 3
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    // картинка рецепта(у меня пока просто вью)
    lazy var recipeVw: UIView = {
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
    
    //значение рейтинга - найти в модели
    lazy var ratingNumberLbl: UILabel = {
        $0.font = .custom(.regular, size: 14)
        $0.textColor = .black
        $0.text = "4.5"
        return $0
    }(UILabel())
    
    // кол-во отзывов - найти в модели
    lazy var reviewsLbl: UILabel = {
        $0.text = "(300 Reviews)"
        $0.font = .custom(.regular, size: 14)
        $0.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
        return $0
    }(UILabel())
    
    lazy var titleInstructionsLbl: UILabel = {
        $0.text = "Instructions"
        $0.font = .custom(.semibold, size: 20)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var hStackRating: UIStackView = {
        let stack = UIStackView.create(spacing: 8)
        stack.distribution = .equalSpacing
        stack.widthAnchor.constraint(equalToConstant: 300)
        stack.addArrangedSubviews(ratingStarImg, ratingNumberLbl,reviewsLbl)
        return stack
    }()
    
    
    // RecipeModel/analyzedInstructions/Instruction/number
    lazy var instructionsStepNumberLbl: UILabel = {
        $0.text = "1."
        $0.font = .custom(.regular, size: 16)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    // RecipeModel/analyzedInstructions/Instruction/step
    lazy var instructionsStepTextLbl: UILabel = {
        $0.text = """
            Place eggs in a saucepan and cover with cold water. Bring water to a boil and immediately remove from heat. Cover and let eggs stand in hot water for 10 to 12 minutes. Remove from hot water, cool, peel, and chop.
            """
        $0.font = .custom(.regular, size: 16)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    lazy var footerInstructionsLbl: UILabel = {
        $0.text = """
            Stir and serve on your favorite bread or crackers.
            """
        $0.font = .custom(.regular, size: 16)
        $0.textColor = .systemRed
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var titleIngredientsLbl: UILabel = {
        $0.text = "Ingredients"
        $0.font = .custom(.semibold, size: 20)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    
    var numberOfItemsInIngredients = 5
    
    lazy var itemsLbl: UILabel = {
        $0.text = "\(numberOfItemsInIngredients) items"
        $0.font = .custom(.regular, size: 14)
        $0.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
        return $0
    }(UILabel())
    
    lazy var hStackIngridients: UIStackView = {
        let stack = UIStackView.create(spacing: 8)
        stack.distribution = .equalSpacing
        stack.widthAnchor.constraint(equalToConstant: 300)
        stack.addArrangedSubviews(titleIngredientsLbl, itemsLbl)
        return stack
    }()
    
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recipe detail"
        view.addSubview(scrollView)
        setupConstr()
        
        // mockData
        mockTableData = [
            IngredientItem(title: "Eggs", image: "defaultSearch"),
            IngredientItem(title: "Tomatoes", image: "defaultSearch"),
            IngredientItem(title: "Lettuce", image: "defaultSearch"),
            IngredientItem(title: "Lettuce", image: "defaultSearch"),
            IngredientItem(title: "Lettuce", image: "defaultSearch"),
            IngredientItem(title: "Lettuce", image: "defaultSearch"),
            IngredientItem(title: "Lettuce", image: "defaultSearch"),
        ] // должны приходить еще граммы
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    

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
            
            recipeVw.topAnchor.constraint(equalTo: subtitleLbl.bottomAnchor, constant: 16),
            recipeVw.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            recipeVw.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            recipeVw.heightAnchor.constraint(equalTo: scrollContentView.widthAnchor, multiplier: 0.5),
            
            hStackRating.topAnchor.constraint(equalTo: recipeVw.bottomAnchor, constant: 16),
            hStackRating.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            hStackRating.heightAnchor.constraint(equalToConstant: 20),
            
            titleInstructionsLbl.topAnchor.constraint(equalTo: hStackRating.bottomAnchor, constant: 16),
            titleInstructionsLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
            titleInstructionsLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
                        
            instructionsStepNumberLbl.topAnchor.constraint(equalTo: titleInstructionsLbl.bottomAnchor, constant: 8),
            instructionsStepNumberLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 32),
            
            instructionsStepTextLbl.topAnchor.constraint(equalTo: titleInstructionsLbl.bottomAnchor, constant: 8),
            instructionsStepTextLbl.leadingAnchor.constraint(equalTo: instructionsStepNumberLbl.trailingAnchor, constant: 4),
            instructionsStepTextLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -32),
            
            footerInstructionsLbl.topAnchor.constraint(equalTo: instructionsStepTextLbl.bottomAnchor, constant: 1),
            footerInstructionsLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            footerInstructionsLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            hStackIngridients.topAnchor.constraint(equalTo: footerInstructionsLbl.bottomAnchor, constant: 31),
            hStackIngridients.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            hStackIngridients.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: hStackIngridients.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -110),
            
            
        ])
    }
  
    
}



extension RecipeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailCell", for: indexPath) as? RecipeDetailCell else {
            return UITableViewCell() //если будет ошибка(nil там, где "Cell"), то вернется просто пустая ячейка
        }
        cell.setupCell(item: mockTableData[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockTableData.count
    }
}

extension RecipeDetailViewController: UITableViewDelegate {}
extension RecipeDetailViewController: UIScrollViewDelegate {}

