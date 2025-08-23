//
//  HomeViewModel.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 19.08.2025.
//

import UIKit

class HomeViewModel {
    //MARK: - Properties
    
    static let shared: HomeViewModel = {
            let vm = HomeViewModel()
            vm.setupInitialData()
            return vm
        }()
    
    private init() {} // Приватный инициализатор, чтобы нельзя было создать новый экземпляр
    
    var callBack: (() -> Void)?
    
    var favoriteRecipesUpdated: (() -> Void)? // Новый callback для обновления избранного
    
    private(set) var allRecipes = [RecipeModel]() {
        didSet {
            callBack?()
        }
    }
    private let userStorage = UserStorage.shared
    public private(set) var favoriteRecipes = [RecipeModel]() {
            didSet {
                favoriteRecipesIDDic.removeAll()
                for (index, recipe) in favoriteRecipes.enumerated() {
                    favoriteRecipesIDDic[recipe.image] = index
                }
                saveFavoritesToStorage()
                favoriteRecipesUpdated?() // Уведомляем об обновлении избранного
            }
        }
    public private(set)var favoriteRecipesIDDic = [String: Int]()
    private(set)var recentRecipes = [RecipeModel]()
    private(set)var kitchens = [Kitchen]()
    //MARK: - Lifecycle
//    init() {
//        //        fetchDishes()
//        getMockData()
//        fetchFavoriteRecipes()
//        fetchRecentRecipes()
//        
//    }
    private func setupInitialData() {
            getMockData()
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
//            favoriteRecipesIDDic[recipe.image] = favoriteRecipes.count - 1
        }
    }
    
    private func saveFavoritesToStorage() {
            userStorage.favoriteDishes.removeAll()
            favoriteRecipes.forEach { recipe in
                if let data = try? JSONEncoder().encode(recipe) {
                    userStorage.favoriteDishes.append(data)
                }
            }
        }
    
    private func addFavorite(_ recipe: RecipeModel) {
        guard let data = try? JSONEncoder().encode(recipe) else { return }
        userStorage.favoriteDishes.append(data)
        favoriteRecipes.append(recipe)
//        favoriteRecipesIDDic[recipe.image] = favoriteRecipes.count - 1
    }
    private func removeFavorite(at index: Int) {
//        favoriteRecipesIDDic.forEach { key, value in
//            if value > index {
//                favoriteRecipesIDDic[key] = value - 1
//            } else if value == index {
//                favoriteRecipesIDDic[key] = nil
//            }
//        }
//        favoriteRecipes.remove(at: index)
//        userStorage.favoriteDishes.remove(at: index)
        guard index < favoriteRecipes.count else { return }
                favoriteRecipes.remove(at: index)
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
//        if let index = favoriteRecipesIDDic[recipe.image] {
        if let index = favoriteRecipes.firstIndex(where: { $0.image == recipe.image }) {
            removeFavorite(at: index)
        } else {
            addFavorite(recipe)
        }
    }
    
    //TODO: Del this method
    func getMockData() {
        DispatchQueue.main.async {
            self.kitchens = [
                Kitchen(name: "African", flag: "🌍", imageUrl: "https://img.spoonacular.com/recipes/638646-312x231.jpg"),
                Kitchen(name: "Asian", flag: "🌏", imageUrl: "https://img.spoonacular.com/recipes/654959-556x370.jpg"),
                Kitchen(name: "American", flag: "🇺🇸", imageUrl: "https://img.spoonacular.com/recipes/716426-556x370.jpg"),
                Kitchen(name: "British", flag: "🇬🇧", imageUrl: "https://img.spoonacular.com/recipes/716627-312x231.jpg"),
                Kitchen(name: "Cajun", flag: "🎺", imageUrl: "https://img.spoonacular.com/recipes/633841-312x231.jpg"),
                Kitchen(name: "Caribbean", flag: "🏝️", imageUrl: "https://img.spoonacular.com/recipes/648275-556x370.jpg"),
                Kitchen(name: "Chinese", flag: "🇨🇳", imageUrl: "https://img.spoonacular.com/recipes/641803-312x231.jpg"),
                Kitchen(name: "Eastern European", flag: "🇷🇺", imageUrl: "https://img.spoonacular.com/recipes/715538-312x231.jpg"),
                Kitchen(name: "European", flag: "🇪🇺", imageUrl: "https://img.spoonacular.com/recipes/716429-312x231.jpg"),
                Kitchen(name: "French", flag: "🇫🇷", imageUrl: "https://img.spoonacular.com/recipes/715447-312x231.jpg"),
                Kitchen(name: "German", flag: "🇩🇪", imageUrl: "https://img.spoonacular.com/recipes/716417-312x231.jpg"),
                Kitchen(name: "Greek", flag: "🇬🇷", imageUrl: "https://img.spoonacular.com/recipes/715495-556x370.jpg"),
                Kitchen(name: "Indian", flag: "🇮🇳", imageUrl: "https://img.spoonacular.com/recipes/660306-556x370.jpg"),
                Kitchen(name: "Irish", flag: "🇮🇪", imageUrl: "https://img.spoonacular.com/recipes/631763-312x231.jpg"),
                Kitchen(name: "Italian", flag: "🇮🇹", imageUrl: "https://img.spoonacular.com/recipes/716429-312x231.jpg"),
                Kitchen(name: "Japanese", flag: "🇯🇵", imageUrl: "https://img.spoonacular.com/recipes/654959-556x370.jpg"),
                Kitchen(name: "Jewish", flag: "✡️", imageUrl: "https://img.spoonacular.com/recipes/655247-556x370.jpg"),
                Kitchen(name: "Korean", flag: "🇰🇷", imageUrl: "https://img.spoonacular.com/recipes/660405-312x231.jpg"),
                Kitchen(name: "Latin American", flag: "🌎", imageUrl: "https://img.spoonacular.com/recipes/632660-556x370.jpg"),
                Kitchen(name: "Mediterranean", flag: "🌊", imageUrl: "https://img.spoonacular.com/recipes/648279-556x370.jpg"),
                Kitchen(name: "Mexican", flag: "🇲🇽", imageUrl: "https://img.spoonacular.com/recipes/632660-556x370.jpg"),
                Kitchen(name: "Middle Eastern", flag: "🧆", imageUrl: "https://img.spoonacular.com/recipes/635329-556x370.jpg"),
                Kitchen(name: "Nordic", flag: "❄️", imageUrl: "https://img.spoonacular.com/recipes/652997-312x231.jpg"),
                Kitchen(name: "Southern", flag: "🎸", imageUrl: "https://img.spoonacular.com/recipes/648275-556x370.jpg"),
                Kitchen(name: "Spanish", flag: "🇪🇸", imageUrl: "https://img.spoonacular.com/recipes/650495-556x370.jpg"),
                Kitchen(name: "Thai", flag: "🇹🇭", imageUrl: "https://img.spoonacular.com/recipes/652423-556x370.jpg"),
                Kitchen(name: "Vietnamese", flag: "🇻🇳", imageUrl: "https://img.spoonacular.com/recipes/660636-312x231.jpg")
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

