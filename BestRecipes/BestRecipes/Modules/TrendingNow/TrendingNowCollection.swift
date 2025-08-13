//
//  TrendingNowCollection.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 12.08.2025.
//

import UIKit

class TrendingNowCollection: UIViewController {
    //MARK: - Properties
    
    //MARK: - UI Components
    private let trendingNowLabel = UILabel()
    private let seeAllButton = UIButton()
    private let trendingNowCollection = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collection
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        
        setupTrendingNowCollection()
        setupTrendingNowLabel()
        setupSeeAllButton()
    }
    //MARK: - Methods
    @objc private func showNewVC() {
        let newVC = UIViewController()
        newVC.view.backgroundColor = .red
        present(newVC, animated: true)
    }
    //MARK: - Setup Layout
    private func setupTrendingNowCollection() {
        view.addSubview(trendingNowCollection)
        trendingNowCollection.delegate = self
        trendingNowCollection.dataSource = self
        trendingNowCollection.showsHorizontalScrollIndicator = false
        trendingNowCollection.register(DishCell.self, forCellWithReuseIdentifier: DishCell.cellId)
        trendingNowCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trendingNowCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trendingNowCollection.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trendingNowCollection.widthAnchor.constraint(equalTo: view.widthAnchor),
            trendingNowCollection.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    private func setupTrendingNowLabel() {
        view.addSubview(trendingNowLabel)
        trendingNowLabel.text = "Trending now 🔥"
        trendingNowLabel.font = .boldSystemFont(ofSize: 18)
        trendingNowLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trendingNowLabel.leadingAnchor.constraint(equalTo: trendingNowCollection.leadingAnchor, constant: 16),
            trendingNowLabel.bottomAnchor.constraint(equalTo: trendingNowCollection.topAnchor),
        ])
    }
    private func setupSeeAllButton() {
        view.addSubview(seeAllButton)
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(.red, for: .normal)
        seeAllButton.addTarget(self, action: #selector(showNewVC), for: .touchUpInside)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seeAllButton.centerYAnchor.constraint(equalTo: trendingNowLabel.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: trendingNowCollection.trailingAnchor, constant: -20),
            seeAllButton.widthAnchor.constraint(equalToConstant: 71),
            seeAllButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

//MARK: - CollectionView Delegate and DataSource
extension TrendingNowCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.cellId, for: indexPath) as! DishCell
        cell.configure(
            title: "How to sharwama at home",
            subtitle: "By Zeelicious foods",
            imageUrl: "https://img.spoonacular.com/recipes/716429-312x231.jpg",
            avatarImageUrl: "https://sun6-22.userapi.com/x4LcbN3OMOyr_NPbDUTmy72LgRqnkJkSXlpGCg/qDHljoTibhY.jpg"
        )
        cell.favoriteButtonAction = { [weak self] in
            print("favoriteButton tup")
        }
        return cell
    }
}

//MARK: - CollectionViewFlowLayout Delegate
extension TrendingNowCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: view.frame.height * 0.4)
    }
}
