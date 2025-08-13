//
//  SearchModel.swift
//  PrepareRecipes
//
//  Created by Варвара Уткина on 12.08.2025.
//

import Foundation

struct SearchModel {
    let title: String
    let ingredients: String
    let time: String
    let rate: String
    let imageName: String
}

extension SearchModel {
    static func getSearchModels() -> [SearchModel] {
        [
            SearchModel(
                title: """
                How to make yam & vegetable sauce at home
                & vegetable sauce at home
                """,
                ingredients: "9 Ingredients",
                time: "25 min",
                rate: "5,0",
                imageName: "defaultSearch"
            ),
            SearchModel(
                title: """
                How to make yam & vegetable sauce at home
                & vegetable sauce at home
                """,
                ingredients: "9 Ingredients",
                time: "25 min",
                rate: "5,0",
                imageName: "defaultSearch"
            ),
            SearchModel(
                title: """
                How to make yam & vegetable sauce at home
                & vegetable sauce at home
                """,
                ingredients: "9 Ingredients",
                time: "25 min",
                rate: "5,0",
                imageName: "defaultSearch"
            )
        ]
    }
}
