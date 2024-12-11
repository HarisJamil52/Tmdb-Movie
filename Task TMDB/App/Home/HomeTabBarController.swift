//
//  HomeTabBarController.swift
//  Task TMDB
//
//  Created by Haris Jamil on 11/12/2024.
//

import Foundation
import CoreData
import UIKit

class HomeTabBarController: UITabBarController {
    init(_ viewContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        
        let popularVC = PopularViewController(viewContext)
        let savedItemsVC = SavedItemsViewController(viewContext)

        let popularTabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "play.fill"), tag: 0)
        let savedItemsTabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "star.fill"), tag: 1)

        popularVC.tabBarItem = popularTabBarItem
        savedItemsVC.tabBarItem = savedItemsTabBarItem
        self.viewControllers = [popularVC, savedItemsVC]

        // Configure tabBar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black // Set tabBar background color

        // Unselected tab appearance
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Selected tab appearance
        appearance.stackedLayoutAppearance.selected.iconColor = .yellow
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.yellow]

        // Apply appearance
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

