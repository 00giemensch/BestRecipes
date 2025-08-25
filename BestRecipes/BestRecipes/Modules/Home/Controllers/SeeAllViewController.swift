//
//  SeeAllViewController.swift
//  BestRecipes
//
//  Created by Ilnur on 23.08.2025.
//

import UIKit

final class SeeAllViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let sectionInset: CGFloat = 24
        static let titleTopInset: CGFloat = 12
        static let titleHorizontalInset: CGFloat = 16
        static let collectionTopInset: CGFloat = 16
    }
    enum CollectionType {
        case cuisenes
        case recipes
    }
    private let type: CollectionType
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.sectionInset
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(.semibold, size: 24)
        label.textColor = UIColor(named: "Neutral100") ?? .black
        label.textAlignment = .center
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
    private var cuisenes: [Kitchen] = []
    private let viewModel = HomeViewModel.shared
    private var sectionTitle: String = ""
    
    // MARK: - Initialization
    init(_ type: CollectionType = .recipes, recipes: [RecipeModel]) {
        self.recipes = recipes
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    init(_ type: CollectionType = .cuisenes, cuisenes: [Kitchen]) {
        self.cuisenes = cuisenes
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCell()
        setNavigationBar()
        setupUI()
        setupConstraints()
//        setupBindings()
//        updateRecipes()
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteRecipes()
        collectionView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearFavorite()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        titleLabel.text = sectionTitle
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateLabel)
    }
    private func setupCell() {
        switch type {
        case .cuisenes:
            collectionView.register(KitchenCollectionViewCell.self, forCellWithReuseIdentifier: KitchenCollectionViewCell.identifier)
        case .recipes:
            collectionView.register(DishCell.self, forCellWithReuseIdentifier: DishCell.cellId)
        }
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleHorizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.titleHorizontalInset),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.collectionTopInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
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
    
    private func setupBindings() {
        viewModel.callBack = { [weak self] in
            DispatchQueue.main.async {
                self?.updateRecipes()
            }
        }
    }
    
    // MARK: - Data Management
    private func updateRecipes() {
//        switch sectionTitle.lowercased() {
//        case "trending now":
//            recipes = viewModel.allRecipes
//        case "recent recipes":
//            recipes = viewModel.recentRecipes
//        default:
//            recipes = []
//        }
//        recipes = allRecipes
//        updateUI()
    }
    
    private func updateUI() {
        if recipes.isEmpty && cuisenes.isEmpty  {
            emptyStateView.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyStateView.isHidden = true
            collectionView.isHidden = false
        }
        collectionView.reloadData()
    }
    
    // MARK: - Favorite Management
    private func toggleFavorite(for recipe: RecipeModel) {
        viewModel.addOrRemoveFavorite(recipe)
        updateRecipes()
    }
    
    //MARK: - Setup NavigationBar
    func setNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.custom(.semibold, size: 24)]
    }
}

// MARK: - UICollectionViewDataSource
extension SeeAllViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .cuisenes:
            return cuisenes.count
        case .recipes:
            return recipes.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .cuisenes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KitchenCollectionViewCell.identifier, for: indexPath) as! KitchenCollectionViewCell
            let cuisene = cuisenes[indexPath.item]
            cell.configure(with: cuisene)
            
            return cell
        case .recipes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.cellId, for: indexPath) as! DishCell
            let recipe = recipes[indexPath.item]
            let isItInFavorites = viewModel.favoriteRecipes.contains { $0.image == recipe.image }
            cell.configure(with: recipe, isItInFavorites)
            cell.favoriteButtonAction = { [weak self] in
                self?.toggleFavorite(for: recipe)
            }
            
            return cell
        }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SeeAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.75)
    }
}

// MARK: - UICollectionViewDelegate
extension SeeAllViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .cuisenes:
            viewModel.searchRecipes(by: cuisenes[indexPath.row].name) { [weak self] in
                let seeAllVC = SeeAllViewController(recipes: self?.viewModel.foundRecipes ?? [])
                seeAllVC.navigationItem.title = self?.cuisenes[indexPath.row].name.capitalizingFirstLetter()
                self?.navigationController?.pushViewController(seeAllVC, animated: true)
            }
        case .recipes:
            let recipe = recipes[indexPath.item]
            let detailVC = RecipeDetailViewController(recipe: recipe)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
