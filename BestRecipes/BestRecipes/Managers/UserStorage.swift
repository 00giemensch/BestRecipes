//
//  UserStorage.swift
//  BestRecipes
//
//  Created by Andrei Kovryzhenko on 20.08.2025.
//

import Foundation

final class UserStorage {
    
    static let shared = UserStorage()
    
    private init() {}
    
    var pastOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "OnboardingShown") }
        set { UserDefaults.standard.set(newValue, forKey: "OnboardingShown") }
    }
    var favoriteDishes: [Data] {
        get { UserDefaults.standard.array(forKey: "favorite") as? [Data] ?? [Data]()}
        set { UserDefaults.standard.set(newValue, forKey: "favorite") }
    }
    var recentRecipes: [Data] {
        get { UserDefaults.standard.array(forKey: "recentRecipes") as? [Data] ?? [Data]()}
        set { UserDefaults.standard.set(newValue, forKey: "recentRecipes") }
    }
}
