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
    private let userStorage = UserStorage.shared
    private(set)var favoriteRecipes = [RecipeModel]()
    private(set)var favoriteRecipesIDDic = [String: Int]()
    
    //MARK: - Lifecycle
    init() {
        fetchDishes()
//        getMockData()
        fetchFavoriteRecipes()
    }
    
    //MARK: - Methods
    private func fetchDishes() {
        NetworkManager.shared.fetchRandomRecipes { [weak self] result in
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
    private func fetchFavoriteRecipes() {
        userStorage.favoriteDishes.forEach { data in
            guard let recipe = try? JSONDecoder().decode(RecipeModel.self, from: data) else { return }
            favoriteRecipes.append(recipe)
            favoriteRecipesIDDic[recipe.image] = favoriteRecipes.count - 1
        }
    }
    private func addFavorite(_ recipe: RecipeModel) {
        guard let data = try? JSONEncoder().encode(recipe) else { return }
        userStorage.favoriteDishes.append(data)
        favoriteRecipes.append(recipe)
        favoriteRecipesIDDic[recipe.image] = favoriteRecipes.count - 1
    }
    private func removeFavorite(at index: Int) {
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
    public func addOrRemoveFavorite(_ recipe: RecipeModel) {
        if let index = favoriteRecipesIDDic[recipe.image] {
            removeFavorite(at: index)
        } else {
            addFavorite(recipe)
        }
    }
    
    //TODO: Del this method
    func getMockData() {
        DispatchQueue.main.async {
            self.allRecipes =  [RecipeModel(
                image: "https://img.spoonacular.com/recipes/650225-556x370.jpg",
                title: "One",
                readyInMinutes: 1,
                spoonacularScore: 12,
                creditsText: "By Zeelicious foods",
                cuisines: [],
                dishTypes: [],
                extendedIngredients: [],
                analyzedInstructions: []
            ),
                                RecipeModel(
                                    image: "https://img.spoonacular.com/recipes/648432-556x370.jpg",
                                    title: "Two",
                                    readyInMinutes: 1,
                                    spoonacularScore: 12,
                                    creditsText: "By Zeelicious foods",
                                    cuisines: [],
                                    dishTypes: [],
                                    extendedIngredients: [],
                                    analyzedInstructions: []
                                ),
                                RecipeModel(
                                    image: "https://img.spoonacular.com/recipes/631738-556x370.jpg",
                                    title: "three",
                                    readyInMinutes: 1,
                                    spoonacularScore: 12,
                                    creditsText: "By Zeelicious foods",
                                    cuisines: [],
                                    dishTypes: [],
                                    extendedIngredients: [],
                                    analyzedInstructions: []
                                ),
                                RecipeModel(
                                    image: "https://img.spoonacular.com/recipes/665329-556x370.jpg",
                                    title: "four",
                                    readyInMinutes: 1,
                                    spoonacularScore: 12,
                                    creditsText: "By Zeelicious foods",
                                    cuisines: [],
                                    dishTypes: [],
                                    extendedIngredients: [],
                                    analyzedInstructions: []
                                )
            ]
        }
    }
}


