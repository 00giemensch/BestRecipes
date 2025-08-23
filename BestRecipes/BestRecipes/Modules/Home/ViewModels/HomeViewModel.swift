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
    private(set)var recentRecipes = [RecipeModel]() 
    private(set)var kitchens = [Kitchen]()
    private(set)var foundRecipes: [RecipeModel] = []
    //MARK: - Lifecycle
    init() {
        fetchDishes()
//        getMockData()
        fetchFavoriteRecipes()
        fetchRecentRecipes()
        
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
    private func fetchRecentRecipes() {
        userStorage.recentRecipes.forEach { data in
            guard let recipe = try? JSONDecoder().decode(RecipeModel.self, from: data) else { return }
            recentRecipes.append(recipe)
        }
    }
    public func addRecentRecipes(_ recipe: RecipeModel) {
        guard let data = try? JSONEncoder().encode(recipe) else { return }
        userStorage.recentRecipes.insert(data, at: 0)
        recentRecipes.insert(recipe, at: 0)
        if recentRecipes.count > 10 {
            recentRecipes.removeLast()
            userStorage.recentRecipes.removeLast()
        }
        
    }
    public func addOrRemoveFavorite(_ recipe: RecipeModel) {
        if let index = favoriteRecipesIDDic[recipe.image] {
            removeFavorite(at: index)
        } else {
            addFavorite(recipe)
        }
    }
    public func searchRecipes(by query: String, completition: (() -> Void)?) {
        clearSearchResults()
        NetworkManager.shared.searchRecipes(query: query) {[weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let recipes):
                    self?.foundRecipes = recipes
                    completition?()
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }
        }
    }
    public func clearSearchResults() {
        foundRecipes.removeAll()
    }
    //TODO: Del this method
    func getMockData() {
        DispatchQueue.main.async {
            self.kitchens = [
                Kitchen(id: 1, name: "Italian cuisine", flagEmoji: "🇮🇹",
                        imageUrl: "https://img.spoonacular.com/recipes/716429-312x231.jpg", isPopular: true),
                Kitchen(id: 2, name: "Asian cuisine", flagEmoji: "🇯🇵",
                        imageUrl: "https://img.spoonacular.com/recipes/654959-556x370.jpg", isPopular: true),
                Kitchen(id: 3, name: "Russian cuisine", flagEmoji: "🇷🇺",
                        imageUrl: "https://img.spoonacular.com/recipes/715538-312x231.jpg", isPopular: true),
                Kitchen(id: 4, name: "Mexican cuisine", flagEmoji: "🇲🇽",
                        imageUrl: "https://img.spoonacular.com/recipes/632660-556x370.jpg", isPopular: true),
                Kitchen(id: 5, name: "French cuisine", flagEmoji: "🇫🇷",
                        imageUrl: "https://img.spoonacular.com/recipes/715447-312x231.jpg", isPopular: true)
            ]
            
            self.allRecipes =  [RecipeModel(
                image: "https://img.spoonacular.com/recipes/650225-556x370.jpg",
                title: "One",
                readyInMinutes: 1,
                spoonacularScore: 12,
                aggregateLikes: 10,
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
                                    aggregateLikes: 15,
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
                                    aggregateLikes: 20,
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
                                    aggregateLikes: 25,
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


