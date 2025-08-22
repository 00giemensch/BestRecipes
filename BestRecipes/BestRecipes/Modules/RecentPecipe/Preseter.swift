//
//  Preseter.swift
//  BestRecipes
//
//  Created by Анастасия Тихонова on 15.08.2025.
//

import UIKit

// MARK: - Presenter
class RecipesPresenter {
    private(set) var recipes: [RecipeModel] = [] // Теперь полные модели из API
    
    func fetchRecipes(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchRandomRecipes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecipes):
                    self?.recipes = fetchedRecipes // Рандомные рецепты
                    completion()
                case .failure(let error):
                    print("Ошибка загрузки recent recipes: \(error)")
                    
                    self?.recipes = []
                    completion()
                }
            }
        }
    }
}
