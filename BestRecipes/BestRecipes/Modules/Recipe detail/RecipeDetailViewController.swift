//
//  RecipeDetailViewController.swift
//  BestRecipes
//
//  Created by Ilnur on 14.08.2025.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        view.backgroundColor = .white
        title = recipe.title
    }
}
