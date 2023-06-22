//
//  HomeTabBarController.swift
//  KickStartTask
//
//  Created by MohamedOsama on 22/06/2023.
//

import UIKit

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBar()
    }
    
    private func setupViewControllers() {
        delegate = self
        let nav = UINavigationController(rootViewController: ProductsViewController())
        let viewController1 = nav
        viewController1.tabBarItem.image = UIImage(named: "ic_home_selected_tab_bar")
        viewController1.tabBarItem.selectedImage = UIImage(named: "ic_home_selected_tab_bar")
        viewController1.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)

        let viewController2 = ListViewController()
        viewController2.tabBarItem.image = UIImage(named: "ic_list_unselected_tab_bar")
        
        let viewController3 = StoreViewController()
        viewController3.tabBarItem.image = UIImage(named: "ic_store_unselected_tab_bar")
        
        let viewController4 = FavoritesViewController()
        viewController4.tabBarItem.image = UIImage(named: "ic_heart_unselected_tab_bar")
        
        let viewController5 = ProfileViewController()
        viewController5.tabBarItem.image = UIImage(named: "ic_profile_unselected_tab_bar")
        
        viewControllers = [
            viewController1,
            viewController2,
            viewController3,
            viewController4,
            viewController5
        ]
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.tintColor = UIColor(red: 190/255, green: 138/255, blue: 255/255, alpha: 1.0)
        tabBar.unselectedItemTintColor = .white
        tabBar.shadowImage = .init()
        
        tabBar.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        }
    }
}

extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
