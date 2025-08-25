//
//  HomeViewModel.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 19.08.2025.
//

import UIKit

class HomeViewModel {
    static let shared = HomeViewModel()
    
    //MARK: - Properties
    var callBack: (() -> Void)?
    var categoryRecipesCallBack: (() -> Void)?
    private(set) var allRecipes = [RecipeModel]() {
        didSet {
            callBack?()
        }
    }
    private(set) var categoryRecipes = [RecipeModel]() {
        didSet {
            categoryRecipesCallBack?()
        }
    }
    private let userStorage = UserStorage.shared
    private(set)var favoriteRecipes = [RecipeModel]()
    private(set)var favoriteRecipesIDDic = [String: Int]()
    private(set)var recentRecipes = [RecipeModel]()
    private(set)var recentRecipesIDSet = Set<String>()
    private(set)var kitchens = Kitchen.getKitchens()
    private(set)var foundRecipes: [RecipeModel] = []
    
    //MARK: - Lifecycle
    private init() {
        self.kitchens = Kitchen.getKitchens()
        //        getMock()
        fetchDishes()
        fetchCategoryDishes()
        fetchFavoriteRecipes()
        fetchRecentRecipes()
    }
    
    //MARK: - Private methods
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
    private func fetchCategoryDishes() {
        NetworkManager.shared.fetchRandomRecipes { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let recipes):
                    self?.categoryRecipes = recipes
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }
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
        let arrData = userStorage.recentRecipes.count > 10 ? Array(userStorage.recentRecipes[0..<10]) : userStorage.recentRecipes
        arrData.forEach { data in
            guard let recipe = try? JSONDecoder().decode(RecipeModel.self, from: data) else { return }
            recentRecipes.append(recipe)
            recentRecipesIDSet.insert(recipe.image)
        }
    }
    //MARK: - Public methods
    public func addRecentRecipes(_ recipe: RecipeModel) {
        guard !recentRecipesIDSet.contains(recipe.image) else { return }
        guard let data = try? JSONEncoder().encode(recipe) else { return }
        userStorage.recentRecipes.insert(data, at: 0)
        recentRecipes.insert(recipe, at: 0)
        recentRecipesIDSet.insert(recipe.image)
        if recentRecipes.count > 10 {
            let lastID = recentRecipes.last!.image
            recentRecipesIDSet.remove(lastID)
            recentRecipes.removeLast()
        }
        if recentRecipes.count > 20 {
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
    public func searchRecipes(by query: String, completion: (() -> Void)?) {
        NetworkManager.shared.searchRecipes(query: query) {[weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let recipes):
                    self?.foundRecipes = recipes
                    completion?()
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }
        }
    }
    public func clearSearchResults() {
        foundRecipes.removeAll()
    }
    public func fetchFavoriteRecipes() {
        userStorage.favoriteDishes.forEach { data in
            guard let recipe = try? JSONDecoder().decode(RecipeModel.self, from: data) else { return }
            favoriteRecipes.append(recipe)
            favoriteRecipesIDDic[recipe.image] = favoriteRecipes.count - 1
        }
    }
    public func clearFavorite() {
        favoriteRecipesIDDic = [:]
        favoriteRecipes = []
    }
}
