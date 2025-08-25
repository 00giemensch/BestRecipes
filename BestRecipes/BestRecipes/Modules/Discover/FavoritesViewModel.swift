//
//  FavoritesViewModel.swift
//  BestRecipes
//
//  Created by Ilnur on 24.08.2025.
//

import Foundation

class FavoritesViewModel {
    static let shared = FavoritesViewModel()
    
    var favoriteRecipesUpdated: (() -> Void)?
    private let userStorage = UserStorage.shared
    private(set)var favoriteRecipesIDDic = [String: Int]()
    var favoriteRecipes: [RecipeModel] = [] {
        didSet {
            favoriteRecipesUpdated?()
        }
    }

    //MARK: - Lifecycle
    private init() {
        fetchFavoriteRecipes()
    }

    //MARK: - Methods
    open func fetchFavoriteRecipes() {
        userStorage.favoriteDishes.forEach { data in
            guard let recipe = try? JSONDecoder().decode(RecipeModel.self, from: data) else { return }
            favoriteRecipes.append(recipe)
            favoriteRecipesIDDic[recipe.image] = favoriteRecipes.count - 1
        }
    }
    public func removeFavorite(_ recipe: RecipeModel) {
        guard let index = favoriteRecipesIDDic[recipe.image] else { return }
        favoriteRecipesIDDic.forEach { key, value in
            if value > index {
                favoriteRecipesIDDic[key] = value - 1
            } else if value == index {
                favoriteRecipesIDDic[key] = nil
            }
        }
        favoriteRecipes.remove(at: index)
        userStorage.favoriteDishes.remove(at: index)
    }
    public func clearFavorite() {
        favoriteRecipesIDDic = [:]
        favoriteRecipes = []
    }
}
