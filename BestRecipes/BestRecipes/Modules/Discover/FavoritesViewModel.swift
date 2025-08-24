//
//  FavoritesViewModel.swift
//  BestRecipes
//
//  Created by Ilnur on 24.08.2025.
//

import Foundation

class FavoritesViewModel {
    static let shared = FavoritesViewModel()
    private init() {}
    
    var favoriteRecipes: [RecipeModel] = []
    var favoriteRecipesUpdated: (() -> Void)?
    
    func addOrRemoveFavorite(_ recipe: RecipeModel) {
        if let index = favoriteRecipes.firstIndex(where: { $0.image == recipe.image }) {
            favoriteRecipes.remove(at: index)
        } else {
            favoriteRecipes.append(recipe)
        }
        favoriteRecipesUpdated?() // Уведомляем об изменении
    }
    
    func isFavorite(_ recipe: RecipeModel) -> Bool {
        favoriteRecipes.contains { $0.image == recipe.image }
    }
}
