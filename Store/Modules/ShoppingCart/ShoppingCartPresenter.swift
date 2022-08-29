//
//  ShoppingCartPresenter.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 27.08.2022.
//

import Foundation


protocol ShoppingCartViewProtocol: AnyObject {
    func setupProducts()
    func setupTotalCost(cost: Double)
    
    func reloadCell(at row: Int)
}

protocol ShoppingCartPresenterProtocol: AnyObject {
    init(view: ShoppingCartViewProtocol, repository: ProductRepository<Product>)
    
    func getProducts()
    
    func returnProductsCount() -> Int
    func getProduct(at row: Int) -> Product?
    func calculateTotalCost()
    func deleteProduct(product: Product)
    func returnCountOfProduct(product: Product) -> Int
    func addCountOfProduct(product: Product, row: Int)
    func reduceCountOfProduct(product: Product, row: Int)
    
    var products: [Product]? { get set }
}

class ShoppingCartPresenter: ShoppingCartPresenterProtocol {
    
    // MARK: -  Properties
    private weak var view: ShoppingCartViewProtocol?
    private let repository: ProductRepository<Product>
    
    var products: [Product]? {
        didSet {
            calculateTotalCost()
        }
    }
    
    // MARK: -  Init
    required init(view: ShoppingCartViewProtocol, repository: ProductRepository<Product>) {
        self.view = view
        self.repository = repository
        
        getProducts()
    }
    
    // MARK: -  Public methods
    func getProducts() {
        self.products = repository.getAll()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.view?.setupProducts()
        }
    }
    
    func returnProductsCount() -> Int {
        return products?.count ?? 0
    }
    
    func getProduct(at row: Int) -> Product? {
        return products?[row]
    }
    
    func calculateTotalCost()  {
        guard let products = products else { return }
        
        var cost = Double()
        
        for product in products {
            let storableProduct = repository.getRealmObject(item: product)
            let count = storableProduct?.count
            
            if let count = count {
                cost += product.price * Double(count)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.view?.setupTotalCost(cost: cost)
        }
    }
    
    func deleteProduct(product: Product) {
        try? repository.delete(item: product)

        getProducts()
    }
    
    func addCountOfProduct(product: Product, row: Int) {
        let storableProduct = repository.getRealmObject(item: product)
        let count = storableProduct?.count
        
        if let count = count {
            try? repository.updateRealmObject(item: product, with: ["count" : count+1])
            
            calculateTotalCost()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.view?.reloadCell(at: row)
            }
        }
        
    }
    
    func reduceCountOfProduct(product: Product, row: Int) {
        let storableProduct = repository.getRealmObject(item: product)
        let count = storableProduct?.count
        
        if let count = count {
            if count > 1 {
                try? repository.updateRealmObject(item: product, with: ["count" : count-1])
                
                calculateTotalCost()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.view?.reloadCell(at: row)
                }
            }
        }
    }
    
    func returnCountOfProduct(product: Product) -> Int {
        let storableProduct = repository.getRealmObject(item: product)
        
        if let storableProduct = storableProduct {
            return storableProduct.count
        } else {
            return 0
        }
    
    }
}
