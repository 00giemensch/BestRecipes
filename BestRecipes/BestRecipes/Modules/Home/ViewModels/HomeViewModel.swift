//
//  HomeViewModel.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 19.08.2025.
//

import UIKit

class HomeViewModel {
    //MARK: - Properties
    var callBack: (() -> Void)?
   
    private(set) var allRecipes = [RecipeModel]() {
        didSet {
            callBack?()
        }
    }
    
    //MARK: - Lifecycle
    init() {
        fetchDishes()
    }
    
    //MARK: - Methods
    private func fetchDishes() {
        NetworkManager.shared.fetchRandomRecipes { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let recipes):
                    self?.allRecipes = recipes
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }
        }
    }
}
