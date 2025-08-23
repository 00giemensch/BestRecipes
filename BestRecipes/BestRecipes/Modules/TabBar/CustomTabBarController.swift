//
//  CustomTabBarController.swift
//  BestRecipes
//
//  Created by Варвара Уткина on 19.08.2025.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupViewControllers()
    }
    
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
    }
    
    private func setupViewControllers() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        
        let vc1NormalImage = UIImage(named: "homeIcon")?.withRenderingMode(.alwaysOriginal)
        let vc1SelectedImage = UIImage(named: "homeIconSelected")?.withRenderingMode(.alwaysOriginal)
        
        vc1.tabBarItem = UITabBarItem(title: nil, image: vc1NormalImage, selectedImage: vc1SelectedImage)
        vc1.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let vc2 = UINavigationController(rootViewController: DiscoverViewController())
        
        let v2NormalImage = UIImage(named: "savedIcon")?.withRenderingMode(.alwaysOriginal)
        let v2SelectedImage = UIImage(named: "savedIconSelecred")?.withRenderingMode(.alwaysOriginal)
        
        vc2.tabBarItem = UITabBarItem(title: nil, image: v2NormalImage, selectedImage: v2SelectedImage)
        vc2.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        // Пустой контроллер для центральной кнопки
        let emptyVC = TempViewController()
        emptyVC.tabBarItem = UITabBarItem(title: "", image: nil, tag: 2)
        emptyVC.tabBarItem.isEnabled = false
        
        let vc3 = TempViewController()
        
        let vc3NormalImage = UIImage(named: "bellIcon")?.withRenderingMode(.alwaysOriginal)
        let vc3SelectedImage = UIImage(named: "bellIconSelected")?.withRenderingMode(.alwaysOriginal)
        
        vc3.tabBarItem = UITabBarItem(title: nil, image: vc3NormalImage, selectedImage: vc3SelectedImage)
        vc3.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let vc4 = TempViewController()
        
        let vc4NormalImage = UIImage(named: "personIcon")?.withRenderingMode(.alwaysOriginal)
        let vc4SelectedImage = UIImage(named: "personIconSelected")?.withRenderingMode(.alwaysOriginal)
        
        vc4.tabBarItem = UITabBarItem(title: nil, image: vc4NormalImage, selectedImage: vc4SelectedImage)
        vc4.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.viewControllers = [vc1, vc2, emptyVC, vc3, vc4]
    }
}
