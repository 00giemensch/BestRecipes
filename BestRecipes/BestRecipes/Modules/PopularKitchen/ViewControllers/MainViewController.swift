//
//  MainViewController.swift
//  BestRecipes
//
//  Created by Анастасия Тихонова on 22.08.2025.
//
import UIKit

// MARK: - MainViewController
class MainViewController: UIViewController {
    private var popularKitchensView: PopularKitchensView!
    private let kitchenService = KitchenService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

    private func setupUI() {
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        popularKitchensView = PopularKitchensView()
        popularKitchensView.translatesAutoresizingMaskIntoConstraints = false

        popularKitchensView.onKitchenSelected = { [weak self] kitchen in
            self?.handleKitchenSelection(kitchen)
        }
        popularKitchensView.onSeeAllTapped = { [weak self] in
            self?.handleSeeAllTapped()
        }

        view.addSubview(popularKitchensView)

        NSLayoutConstraint.activate([
            popularKitchensView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            popularKitchensView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popularKitchensView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popularKitchensView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func loadData() {
        let kitchens = kitchenService.getPopularKitchens()
        popularKitchensView.kitchens = kitchens
    }

    private func handleKitchenSelection(_ kitchen: Kitchen) {
        let vc = DishesListViewController(kitchen: kitchen)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func handleSeeAllTapped() {
        let vc = AllKitchensViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
