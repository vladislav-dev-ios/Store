//
//  MainTabBarViewController.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 27.08.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
        
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
          
        setUpTabBarController()
        
    }
    
    //MARK: - Private funcs
    private func setUpTabBarController() {
        
        let productModule = ModuleBuilder.createProductListModule()
        let productNavController = generateNavigationController(vc: productModule, title: "Товары", image: UIImage(named: "products")!)
        
        let shoppingCartModule = ModuleBuilder.createShoppingCartModule()
        let shoppingCartNavController = generateNavigationController(vc: shoppingCartModule, title: "Корзина", image: UIImage(named: "trolley-cart")!)
        
        viewControllers = [productNavController, shoppingCartNavController]
        
    }
    
    private func generateNavigationController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController{
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
    
    
}
