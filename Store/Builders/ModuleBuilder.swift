//
//  ModuleBuilder.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 26.08.2022.
//

import Foundation
import UIKit

protocol Builder {
    
    static func createProductListModule() -> UIViewController
    static func createShoppingCartModule() -> UIViewController
    static func createProductDetailModule(products: [Product], index: Int) -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createProductListModule() -> UIViewController {
        let view = ProductListViewController()
        let networkService = NetworkService()
        let presenter = ProductListPresenter(view: view, networkService: networkService, repository: ProductRepository())
        view.presenter = presenter
        
        return view
    }
    
    static func createShoppingCartModule() -> UIViewController {
        let view = ShoppingCartViewController()
        let presenter = ShoppingCartPresenter(view: view, repository: ProductRepository())
        view.presenter = presenter
        
        return view
    }
    
    static func createProductDetailModule(products: [Product], index: Int) -> UIViewController {
        let view = ProductDetailViewController()
        let presenter = ProductDetailPresenter(view: view, repository: ProductRepository(), products: products, index: index)
        view.presenter = presenter
        
        return view
        
    }
    
}
