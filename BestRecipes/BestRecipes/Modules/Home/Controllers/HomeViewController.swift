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
    }
    private var viewModel = HomeViewModel()
    private var searchTFBottomCT = NSLayoutConstraint()
    private var titleHeight: CGFloat = 0.0
    private var allRecipes: [RecipeModel] = []
    private var filteredRecipes: [RecipeModel] = []
    private var isSearching: Bool = false
    
    //MARK: - UI Components
    private let titleLabel = UILabel()
    private let searchTextField = SearchTextField()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let trendingNowHeader = CollectionHeader()
    private let recentRecipeHeader = CollectionHeader()
    private let popularKitchensHeader = CollectionHeader()
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
    
    // MARK: - Testing Methods
    func showRecipeDetail(for recipe: RecipeModel) {
        let detailVC = RecipeDetailViewController(recipe: recipe)
        //        present(detailVC,animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
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
        setupRecentRecipeLabel()
        setupRecentRecipeCollection()
        setupPopularKitchensLabel()
        setupPopularKitchensCollection()
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
        scrollView.showsVerticalScrollIndicator = true
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //TODO: - Only for mock data
            contentView.heightAnchor.constraint(equalToConstant: 2000)
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
            trendingNowCollection.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    private func setupRecentRecipeLabel() {
        contentView.addSubview(recentRecipeHeader)
        recentRecipeHeader.setTitle("Recent recipe")
        recentRecipeHeader.action = { [weak self] in
            print("Recent recipe see all")
        }
        recentRecipeHeader.isHidden = true
        recentRecipeHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recentRecipeHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Drawing.horizontalEdges),
            recentRecipeHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Drawing.horizontalEdges),
            recentRecipeHeader.topAnchor.constraint(equalTo: trendingNowCollection.bottomAnchor, constant: Drawing.collectionVerticalInset),
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
            recentRecipeCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            recentRecipeCollection.heightAnchor.constraint(equalToConstant: 190)
        ])
    }
    private func setupPopularKitchensLabel() {
        contentView.addSubview(popularKitchensHeader)
        popularKitchensHeader.setTitle("Popular kitchens")
        popularKitchensHeader.action = { [weak self] in
            print("Popular kitchens see all")
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
        textField.resignFirstResponder()
        guard let query = textField.text else { return false }
        viewModel.searchRecipes(by: query) { [weak self] in
            DispatchQueue.main.async {
                self?.searchRecipesCollection.reloadData()
            }
        }
        return true
    }
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        //        performSearch(with: "")
//        return true
//    }
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
            return 0
        case 3:
            return viewModel.recentRecipes.count
        case 4:
            return viewModel.kitchens.count
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
            return UICollectionViewCell()
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeItemCell.reuseId, for: indexPath) as? RecipeItemCell else {
                return UICollectionViewCell()
            }
            cell.setupRecipe(viewModel.recentRecipes[indexPath.item])
            
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
            break
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
            return CGSize(width: view.frame.width * 0.9, height: view.frame.height * 0.4)
        case 2:
            return.zero
        case 3:
            return CGSize(width: 124, height: 190)
        case 4:
            return CGSize(width: 120, height: 160)
        default:
            return .zero
        }
    }
}
