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
        static var horizontalEdges: CGFloat { 16 }
    }
    
    // MARK: - UI Elements
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
        return collection
    }()
    
    // MARK: - Private Properties
    private let recipes: [SearchModel] = SearchModel.getSearchModels()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setLayout()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(recipesCollection)
        
        recipesCollection.dataSource = self
        recipesCollection.delegate = self
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            recipesCollection.topAnchor.constraint(equalTo: view.topAnchor),
            recipesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        let recipe = recipes[indexPath.item]
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
