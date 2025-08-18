//
//  SearchViewController.swift
//  PrepareRecipes
//
//  Created by Варвара Уткина on 12.08.2025.
//

import UIKit

final class SearchViewController: UIViewController {
    
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
    
    // MARK: - UI Elements
    private let searchTextField = SearchTextField()
    private let recipesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Drawing.spacing
        layout.minimumInteritemSpacing = Drawing.spacing
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.identifier
        )
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.alwaysBounceVertical = true
        collection.isScrollEnabled = true
        collection.backgroundColor = .clear
        collection.contentInset.top = Drawing.collectionVerticalInset
        collection.contentInset.bottom = Drawing.collectionVerticalInset
        return collection
    }()
    
    // MARK: - Private Properties
    private var allRecipes: [RecipeModel] = []
    private var filteredRecipes: [RecipeModel] = []
    private var isSearching: Bool = false

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setLayout()
        filteredRecipes = allRecipes
        
        NetworkManager.shared.fetchRandomRecipes { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let recipes):
                    self?.allRecipes = recipes
                    self?.filteredRecipes = recipes
                    self?.recipesCollection.reloadData()
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }
        }
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews(searchTextField, recipesCollection)
        
        recipesCollection.dataSource = self
        recipesCollection.delegate = self
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self
        searchTextField.searchDelegate = self
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Drawing.searchTopInset),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Drawing.horizontalEdges),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Drawing.horizontalEdges),
            searchTextField.heightAnchor.constraint(equalToConstant: Drawing.searchTFHeight),
            
            recipesCollection.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Drawing.searchBottomInset),
            recipesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Search Methods
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
        
        recipesCollection.reloadData()
    }
}

// MARK: - SearchTextFieldDelegate
extension SearchViewController: SearchTextFieldDelegate {
    func closeButtonTapped() {
        performSearch(with: "")
        print("❌ Close search")
//        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
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
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = textField.text?.isEmpty ?? true
        ? UIColor.searchBarGray.cgColor
        : UIColor.searchBar.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        performSearch(with: "")
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let recipe = filteredRecipes[indexPath.item]
        cell.configure(with: recipe)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = UIScreen.main.bounds.width - 2 * Drawing.horizontalEdges
        let height = ceil(width * Drawing.collectionRatioHtoW)
        return CGSize(width: width, height: height)
    }
}
