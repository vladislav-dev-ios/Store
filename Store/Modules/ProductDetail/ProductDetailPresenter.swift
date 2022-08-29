//
//  ProductDetailPresenter.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 29.08.2022.
//

import Foundation

protocol ProductDetailViewProtocol: AnyObject {
    func setupProduct(product: Product)
    func configureCartButton(isAddedToCart: Bool)
}

protocol ProductDetailPresenterProtocol: AnyObject {
    init(view: ProductDetailViewProtocol, repository: ProductRepository<Product>, products: [Product], index: Int)
    
    func addProductToCart()
    func loadPreviousProduct()
    func loadNextProduct()
}

class ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    // MARK: -  Properties
    private weak var view: ProductDetailViewProtocol?
    private let repository: ProductRepository<Product>
    private let products: [Product]
    private var index: Int
    
    // MARK: -  Init
    required init(view: ProductDetailViewProtocol, repository: ProductRepository<Product>, products: [Product], index: Int) {
        self.view = view
        self.products = products
        self.index = index
        self.repository = repository
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.view?.setupProduct(product: products[index])
            self.view?.configureCartButton(isAddedToCart: self.isProductAddedToCart())
        }
    }
    
    
    // MARK: -  Public methods
    func addProductToCart() {
        let product = products[index]
        
        try? repository.insert(item: product)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.view?.configureCartButton(isAddedToCart: self.isProductAddedToCart())
        }
    }
    
    func loadPreviousProduct() {
        if index == 0 {
            index = products.count-1
        } else {
            index = index - 1
        }
            
        self.view?.setupProduct(product: self.products[self.index])
        self.view?.configureCartButton(isAddedToCart: self.isProductAddedToCart())
    }
    
    func loadNextProduct() {
        if index == products.count-1 {
            index = 0
        } else {
            index = index + 1
        }
            
        self.view?.setupProduct(product: self.products[self.index])
        self.view?.configureCartButton(isAddedToCart: self.isProductAddedToCart())
    }
    
    // MARK: -  Private methods
    private func isProductAddedToCart() -> Bool {
        
        let product = products[index]
        
        let storableProducts = repository.getAll()
        
        for storableProduct in storableProducts {
            if product.id == storableProduct.id {
                return true
            }
        }
        
        return false
    }
    
}
