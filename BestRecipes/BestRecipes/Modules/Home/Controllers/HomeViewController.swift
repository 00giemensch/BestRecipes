//
//  HomeViewController.swift
//  BestRecipes
//
//  Created by Ilnur on 11.08.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    //MARK: - Properties
    private enum Drawing {
        static var spacing: CGFloat { 24 }
        static var collectionRatioHtoW: CGFloat { 200 / 343 }
        static var collectionVerticalInset: CGFloat { 12 }
        static var horizontalEdges: CGFloat { 16 }
        
        static var searchTopInset: CGFloat { 7 }
        static var searchRightInset: CGFloat { 8 }
        static var searchBottomInset: CGFloat { 2 }
        static var searchBarHeight: CGFloat { 60 }
        static var searchTFHeight: CGFloat { 44 }
        static var iconSize: CGFloat { 16 }
        
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

    private var viewModel = HomeViewModel.shared
    private var searchTFBottomCT = NSLayoutConstraint()
    private var titleHeight: CGFloat = 0.0
    private var isSearching: Bool = false
    
    private var allRecipes: [RecipeModel] = []
    private var allDishTypes: Set<String> = [] {
        didSet {
            addButtons(with: allDishTypes)
        }
    }
    private var filteredRecipes: [RecipeModel] = [] {
        didSet {
            popularCategoryCollection.reloadData()
        }
    }
    
    //MARK: - UI Components
    private let titleLabel = UILabel()
    private let searchTextField = SearchTextField()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let trendingNowHeader = CollectionHeader()
    private let recentRecipeHeader = CollectionHeader()
    private let popularCategoryHeader = CollectionHeader(false)
    private let popularKitchensHeader = CollectionHeader()
    private let popularCategoryMainStack = UIStackView()
    private let dishCategoriesScrollView = UIScrollView()
    private let categoriesButtonsStack = UIStackView()
    private var selectedButton: UIButton?
    
    //MARK: Collections
    private lazy var searchRecipesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Drawing.spacing
        layout.minimumInteritemSpacing = Drawing.spacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 0
        
        return collection
    }()
    private let trendingNowCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 1
        
        return collection
    }()
    private let popularCategoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 2
        
        return collection
    }()
    private let recentRecipeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 3
        
        return collection
    }()
    private let popularKitchensCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 4
        
        return collection
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewModel.callBack = { [weak self] in
            DispatchQueue.main.async {
//                self?.setupLayout()
                self?.trendingNowCollection.reloadData()
                self?.recentRecipeCollection.reloadData()
                self?.popularKitchensCollection.reloadData()
                
                self?.prepareCategoryCollection()
            }
        }
        viewModel.categoryRecipesCallBack = { [weak self] in
            DispatchQueue.main.async {
                self?.prepareCategoryCollection()
            }
        }
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        recentRecipeCollection.reloadData()
        guard !viewModel.recentRecipes.isEmpty else { return }
        showRecentRecipe()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    //MARK: - Methods
    // Search Methods
    private func performSearch(with query: String) {
        if query.isEmpty {
            filteredRecipes = allRecipes
            isSearching = false
        } else {
            filteredRecipes = allRecipes.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(query)
            }
            isSearching = true
        }
        searchRecipesCollection.reloadData()
    }
    private func showRecentRecipe() {
        recentRecipeHeader.isHidden = false
        recentRecipeCollection.isHidden = false
        recentRecipeHeader.heightAnchor.constraint(equalToConstant: 40).isActive = true
        recentRecipeCollection.heightAnchor.constraint(equalToConstant: 190).isActive = true
    }
    private func prepareCategoryCollection() {
        var temp: Set<String> = []
        allRecipes = viewModel.categoryRecipes
        popularCategoryCollection.reloadData()
        allRecipes.forEach { recipe in temp.formUnion(recipe.dishTypes) }
        allDishTypes = temp
        filteredRecipes = allRecipes
    }
    
    // MARK: - Testing Methods
    func showRecipeDetail(for recipe: RecipeModel) {
        let detailVC = RecipeDetailViewController(recipe: recipe)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showSeeAllVC(for recipe: [RecipeModel], with title: String) {
        navigationItem.backBarButtonItem
        let seeAllVC = SeeAllViewController(recipes: recipe)
        seeAllVC.navigationItem.title = title
        navigationController?.pushViewController(seeAllVC, animated: true)
    }
    
    //MARK: - Setup Layout
    private func setupLayout() {
        setupTitleLabel()
        setupSearchTextField()
        setupScrollView()
        setupContentView()
        setupSearchRecipesCollection()
        setupTrendingNowHeader()
        setupTrendingNowCollection()
        setupDishCategoriesScrollView()
        setupCategoriesButtonsStack()
        setupPopularCategoryHeader()
        setupPopularCategoryCollection()
        setupPopularCategoryMainStack()
        setupRecentRecipeLabel()
        setupRecentRecipeCollection()
        setupPopularKitchensLabel()
        setupPopularKitchensCollection()
        setScrollViewHeight()
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Get amazing recipes for cooking"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.custom(.bold, size: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Drawing.searchTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Drawing.horizontalEdges),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Drawing.horizontalEdges)
        ])
    }
    private func setupSearchTextField() {
        view.addSubviews(searchTextField)
        searchTextField.delegate = self
        searchTextField.searchDelegate = self
        searchTFBottomCT = searchTextField.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: Drawing.spacing
        )
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTFBottomCT,
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Drawing.horizontalEdges),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Drawing.horizontalEdges),
            searchTextField.heightAnchor.constraint(equalToConstant: Drawing.searchTFHeight)
        ])
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Drawing.searchBottomInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    private func setupSearchRecipesCollection() {
        view.addSubviews(searchRecipesCollection)
        searchRecipesCollection.dataSource = self
        searchRecipesCollection.delegate = self
        searchRecipesCollection.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.identifier
        )
        searchRecipesCollection.showsVerticalScrollIndicator = false
        searchRecipesCollection.alwaysBounceVertical = true
        searchRecipesCollection.isScrollEnabled = true
        searchRecipesCollection.backgroundColor = .white
        searchRecipesCollection.alpha = 0
        searchRecipesCollection.contentInset.top = Drawing.collectionVerticalInset
        searchRecipesCollection.contentInset.bottom = Drawing.collectionVerticalInset
        searchRecipesCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchRecipesCollection.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Drawing.searchBottomInset),
            searchRecipesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchRecipesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchRecipesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupTrendingNowHeader() {
        contentView.addSubview(trendingNowHeader)
        trendingNowHeader.setTitle("Trending now 🔥")
        trendingNowHeader.action = { [weak self] in
            if let allRecipe = self?.viewModel.allRecipes {
                self?.showSeeAllVC(for: allRecipe, with: "Trending now")
            }
            print("Trending now see all")
        }
        trendingNowHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trendingNowHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawing.horizontalEdges),
            trendingNowHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawing.horizontalEdges),
            trendingNowHeader.heightAnchor.constraint(equalToConstant: 40),
            trendingNowHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Drawing.collectionVerticalInset),
        ])
    }
    private func setupTrendingNowCollection() {
        contentView.addSubview(trendingNowCollection)
        trendingNowCollection.delegate = self
        trendingNowCollection.dataSource = self
        trendingNowCollection.showsHorizontalScrollIndicator = false
        trendingNowCollection.register(DishCell.self, forCellWithReuseIdentifier: DishCell.cellId)
        trendingNowCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trendingNowCollection.topAnchor.constraint(equalTo: trendingNowHeader.bottomAnchor),
            trendingNowCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trendingNowCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trendingNowCollection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32)
        ])
    }
    private func setupRecentRecipeLabel() {
        contentView.addSubview(recentRecipeHeader)
        recentRecipeHeader.setTitle("Recent recipe")
        recentRecipeHeader.action = { [weak self] in
            if let recentRecipe = self?.viewModel.recentRecipes {
                self?.showSeeAllVC(for: recentRecipe, with: "Recent recipe")
            }
            print("Recent recipe see all")
        }
        recentRecipeHeader.isHidden = true
        recentRecipeHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recentRecipeHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawing.horizontalEdges),
            recentRecipeHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawing.horizontalEdges),
            recentRecipeHeader.topAnchor.constraint(equalTo: popularCategoryMainStack.bottomAnchor, constant: Drawing.collectionVerticalInset),
        ])
    }
    private func setupRecentRecipeCollection() {
        contentView.addSubview(recentRecipeCollection)
        recentRecipeCollection.dataSource = self
        recentRecipeCollection.delegate = self
        recentRecipeCollection.register(RecipeItemCell.self, forCellWithReuseIdentifier: RecipeItemCell.reuseId)
        recentRecipeCollection.backgroundColor = .systemBackground
        recentRecipeCollection.showsHorizontalScrollIndicator = false
        recentRecipeCollection.isHidden = true
        recentRecipeCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recentRecipeCollection.topAnchor.constraint(equalTo: recentRecipeHeader.bottomAnchor, constant: Drawing.horizontalEdges),
            recentRecipeCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recentRecipeCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    private func setupPopularKitchensLabel() {
        contentView.addSubview(popularKitchensHeader)
        popularKitchensHeader.setTitle("Popular cuisines")
        popularKitchensHeader.action = { [weak self] in
            if let popCuisines = self?.viewModel.kitchens {
//                self?.showSeeAllVC(for: popCuisines, with: "Popular cuisines")
            }
            print("Popular cuisines see all")
        }
        popularKitchensHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popularKitchensHeader.topAnchor.constraint(equalTo: recentRecipeCollection.bottomAnchor, constant: Drawing.searchTopInset),
            popularKitchensHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Drawing.horizontalEdges),
            popularKitchensHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Drawing.horizontalEdges),
            popularKitchensHeader.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    private func setupPopularKitchensCollection() {
        contentView.addSubview(popularKitchensCollection)
        popularKitchensCollection.dataSource = self
        popularKitchensCollection.delegate = self
        popularKitchensCollection.register(KitchenCollectionViewCell.self,
                                           forCellWithReuseIdentifier: KitchenCollectionViewCell.identifier)
        popularKitchensCollection.showsHorizontalScrollIndicator = false
        popularKitchensCollection.backgroundColor = .white
        popularKitchensCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popularKitchensCollection.topAnchor.constraint(equalTo: popularKitchensHeader.bottomAnchor, constant: Drawing.collectionVerticalInset),
            popularKitchensCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            popularKitchensCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            popularKitchensCollection.heightAnchor.constraint(equalToConstant: 190)
        ])
    }
    private func setupDishCategoriesScrollView() {
        dishCategoriesScrollView.showsHorizontalScrollIndicator = false
        dishCategoriesScrollView.showsVerticalScrollIndicator = false
        dishCategoriesScrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupCategoriesButtonsStack() {
        categoriesButtonsStack.axis = .horizontal
        categoriesButtonsStack.spacing = Drawing.buttonStackSpacing
        categoriesButtonsStack.distribution = .fillProportionally
        categoriesButtonsStack.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupPopularCategoryHeader() {
        popularCategoryHeader.action = { [weak self] in
                print("popularCategory see all")
        }
        popularCategoryHeader.setTitle(Drawing.popularCategoryTitle)
        popularCategoryHeader.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupPopularCategoryCollection() {
        popularCategoryCollection.showsHorizontalScrollIndicator = false
        popularCategoryCollection.translatesAutoresizingMaskIntoConstraints = false
        popularCategoryCollection.delegate = self
        popularCategoryCollection.dataSource = self
        popularCategoryCollection.register(PopularCategoryCell.self, forCellWithReuseIdentifier: PopularCategoryCell.identifier)
    }
    private func setupPopularCategoryMainStack() {
        contentView.addSubview(popularCategoryMainStack)
        popularCategoryMainStack.addArrangedSubview(popularCategoryHeader)
        popularCategoryMainStack.addArrangedSubview(dishCategoriesScrollView)
        popularCategoryMainStack.addArrangedSubview(popularCategoryCollection)
        
        popularCategoryMainStack.axis = .vertical
        popularCategoryMainStack.spacing = Drawing.popularCategoryStackSpacing
        popularCategoryMainStack.distribution = .fillProportionally
       
        popularCategoryMainStack.translatesAutoresizingMaskIntoConstraints = false
        dishCategoriesScrollView.addSubview(categoriesButtonsStack)
        
        NSLayoutConstraint.activate([
            popularCategoryMainStack.topAnchor.constraint(equalTo: trendingNowCollection.bottomAnchor, constant: Drawing.collectionVerticalInset),
            popularCategoryMainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawing.horizontalEdges),
            popularCategoryMainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawing.horizontalEdges),
            
            popularCategoryHeader.heightAnchor.constraint(equalToConstant: Drawing.popCatTitleLabelHeight),
            
            dishCategoriesScrollView.heightAnchor.constraint(equalToConstant: Drawing.buttonsScrollViewHeight),
            
            categoriesButtonsStack.topAnchor.constraint(equalTo: dishCategoriesScrollView.topAnchor),
            categoriesButtonsStack.bottomAnchor.constraint(equalTo: dishCategoriesScrollView.bottomAnchor),
            categoriesButtonsStack.leadingAnchor.constraint(equalTo: dishCategoriesScrollView.leadingAnchor, constant: Drawing.horizontalEdges),
            categoriesButtonsStack.trailingAnchor.constraint(equalTo: dishCategoriesScrollView.trailingAnchor, constant: -Drawing.horizontalEdges),
            categoriesButtonsStack.heightAnchor.constraint(equalTo: dishCategoriesScrollView.heightAnchor),
            
            popularCategoryCollection.heightAnchor.constraint(equalToConstant: Drawing.popCatCollectionViewHeight)
        ])
    }
    private func setScrollViewHeight() {
        contentView.bottomAnchor.constraint(equalTo: popularKitchensCollection.bottomAnchor).isActive = true
    }
}

// MARK: - SearchTextField Delegate
extension HomeViewController: SearchTextFieldDelegate {
    func closeButtonTapped() {
        //performSearch(with: "")
        guard searchRecipesCollection.alpha == 1 else { return }
        print("❌ Close search")
        viewModel.clearSearchResults()
        searchTextField.endEditing(true)
        DispatchQueue.main.async {
            self.searchRecipesCollection.reloadData()
        }
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 1
            self.searchRecipesCollection.alpha = 0
            self.titleLabel.alpha = 1
            self.searchTFBottomCT.constant += self.titleHeight
            self.view.layoutIfNeeded()
        }
    }
}
// MARK: - TextField Delegate
extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        DispatchQueue.main.async {
            textField.layer.borderColor = newText.isEmpty
            ? UIColor.searchBarGray.cgColor
            : UIColor.searchBar.cgColor
        }
        
        if newText.contains("  ") {
            textField.text = newText.replacingOccurrences(of: "  ", with: " ")
            return false
        }
        performSearch(with: newText)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.searchBar.cgColor
        
        guard contentView.alpha > 0 else { return }
        titleHeight = titleLabel.frame.height + Drawing.spacing + Drawing.searchTopInset
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 0
            self.searchRecipesCollection.alpha = 1
            self.searchTFBottomCT.constant -= self.titleHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.titleLabel.alpha = 0
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = textField.isEnabled
        ? UIColor.searchBarGray.cgColor
        : UIColor.searchBar.cgColor
        textField.text = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {
            textField.resignFirstResponder()
            return false
        }
        viewModel.searchRecipes(by: query) { [weak self] in
            DispatchQueue.main.async {
                self?.searchRecipesCollection.reloadData()
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return viewModel.foundRecipes.count
        case 1:
            return viewModel.allRecipes.count
        case 2:
            return filteredRecipes.count
        case 3:
            return viewModel.recentRecipes.count
        case 4:
            return 10
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchCollectionViewCell.identifier,
                for: indexPath
            ) as? SearchCollectionViewCell else { return UICollectionViewCell() }
            
            let recipe = viewModel.foundRecipes[indexPath.item]
            cell.configure(with: recipe)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.cellId, for: indexPath) as! DishCell
            let recipe = viewModel.allRecipes[indexPath.item]
            let isItInFavorites = viewModel.favoriteRecipesIDDic.keys.contains(recipe.image)
            cell.configure(with: recipe, isItInFavorites)
            cell.favoriteButtonAction = { [weak self] in
                self?.viewModel.addOrRemoveFavorite(recipe)
            }
            /// this action print all favorites
            cell.ratingButton.action = { [weak self] in
                let favorites = self?.viewModel.favoriteRecipes
                favorites?.forEach { data in
                    print(data.title)
                }
            }
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCategoryCell.identifier, for: indexPath) as! PopularCategoryCell
            let cellItem = filteredRecipes[indexPath.item]
            let isItInFavorites = viewModel.favoriteRecipesIDDic.keys.contains(cellItem.image)
            cell.configureCell(with: cellItem, isItInFavorites)
            cell.favoriteButtonAction = { [weak self] in
                self?.viewModel.addOrRemoveFavorite(cellItem)
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeItemCell.reuseId, for: indexPath) as? RecipeItemCell else {
                return UICollectionViewCell()
            }
            let recentRecipe = viewModel.recentRecipes[indexPath.item]
            cell.setupRecipe(recentRecipe)
            
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: KitchenCollectionViewCell.identifier,
                for: indexPath
            ) as? KitchenCollectionViewCell else { return UICollectionViewCell() }
            let kitchen = viewModel.kitchens[indexPath.item]
            cell.configure(with: kitchen)
            
            return cell
        default :
            return UICollectionViewCell()
        }
    }
}

//MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            let selectedRecipe = viewModel.foundRecipes[indexPath.item]
            viewModel.addRecentRecipes(selectedRecipe)
            showRecipeDetail(for: selectedRecipe)
        case 1:
            let selectedRecipe = viewModel.allRecipes[indexPath.item]
            viewModel.addRecentRecipes(selectedRecipe)
            showRecipeDetail(for: selectedRecipe)
        case 2:
            let selectedRecipe = filteredRecipes[indexPath.item]
            viewModel.addRecentRecipes(selectedRecipe)
            showRecipeDetail(for: selectedRecipe)
        case 3:
            let selectedRecipe = viewModel.recentRecipes[indexPath.item]
            showRecipeDetail(for: selectedRecipe)
        default:
            break
        }
    }
}

// MARK: - CollectionViewFlowLayout Delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch collectionView.tag {
        case 0:
            let width = UIScreen.main.bounds.width - 2 * Drawing.horizontalEdges
            let height = ceil(width * Drawing.collectionRatioHtoW)
            return CGSize(width: width, height: height)
        case 1:
            return CGSize(width: 280,height: 254)
        case 2:
            return Drawing.collectionViewCellSize
        case 3:
            return CGSize(width: 124, height: 190)
        case 4:
            return CGSize(width: 120, height: 160)
        default:
            return .zero
        }
    }
}

//MARK: - Extension ViewController with scrollView
extension HomeViewController {
    private func addButtons(with categories: Set<String>) {
        let sortedDishTypes = categories.sorted()
        
        for (index, sortedDishType) in sortedDishTypes.enumerated() {
            let button: UIButton = {
                
                // Настраиваем первоначальное оборажение кнопки
                var buttonConfiguration = UIButton.Configuration.filled()
                buttonConfiguration.title = sortedDishType.capitalizingFirstLetter()
                buttonConfiguration.attributedTitle?.font = UIFont.custom(.semibold, size: 12)
                buttonConfiguration.contentInsets = Drawing.categoryButtonsPadding
                buttonConfiguration.baseBackgroundColor = Drawing.categoryButtonNormalBackgroundColor
                buttonConfiguration.baseForegroundColor = Drawing.categoryButtonNormalForegroundColor
                buttonConfiguration.background.cornerRadius = Drawing.categoryButtonRadius
                
                let button = UIButton(configuration: buttonConfiguration)
                button.tag = index

                button.translatesAutoresizingMaskIntoConstraints = false
                
                //Обновляем отображение кнопки при смене состояния
                button.configurationUpdateHandler = { button in
                    var updatedConfiguration = button.configuration
                    
                    switch button.state {
                    case .selected:
                        updatedConfiguration?.baseBackgroundColor = Drawing.categoryButtonSelectedBackgroundColor
                        updatedConfiguration?.baseForegroundColor = Drawing.categoryButtonSelectedForegroundColor
                    case .normal:
                        updatedConfiguration?.baseBackgroundColor = Drawing.categoryButtonNormalBackgroundColor
                        updatedConfiguration?.baseForegroundColor = Drawing.categoryButtonNormalForegroundColor
                    default:
                        break
                    }
                    
                    // Анимация изменения отображения кнопки
                    UIView.transition(with: button, duration: Drawing.categoryButtonAnimationDuration, options: .transitionCrossDissolve) {
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
        
        guard let currentDishType = sender.titleLabel?.text?.lowercased() else { return }
        filteredRecipes = allRecipes.filter { $0.dishTypes.contains(currentDishType) }
        popularCategoryCollection.reloadData()
    }
}

//MARK: - Extension String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
