//
//  KitchenModel.swift
//  BestRecipes
//
//  Created by Анастасия Тихонова on 22.08.2025.
//

import UIKit
// MARK: - Kitchen Model
struct Kitchen {
    let id: Int
    let name: String
    let flagEmoji: String
    let imageUrl: String
    let isPopular: Bool

    init(id: Int, name: String, flagEmoji: String, imageUrl: String, isPopular: Bool = false) {
        self.id = id
        self.name = name
        self.flagEmoji = flagEmoji
        self.imageUrl = imageUrl
        self.isPopular = isPopular
    }
