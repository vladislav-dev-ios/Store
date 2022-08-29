//
//  ProductListPresenter.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 26.08.2022.
//

import Foundation
import UIKit

protocol ProductListViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
    
    func selectPriceButton()
    func selectRatingButton()
    func reloadCell(at row: Int)
    
    func presentView(vc: UIViewController)
}

protocol ProductListPresenterProtocol: AnyObject {
    init(view: ProductListViewProtocol, networkService: NetworkServiceProtocol, repository: ProductRepository<Product>)
    
    func fetchProducts()
    
    func returnProductsCount() -> Int
    func getProduct(at row: Int) -> Product?
    
    func sortProductByPrice()
    func sortProductByRating()
    func addProductToCart(at row: Int)
    func isProductAddedToCart(at row: Int) -> Bool
    
    func openModule(at index: Int)
    
    var products: [Product]? { get set }
}

class ProductListPresenter: ProductListPresenterProtocol {
    
    // MARK: -  Properties
    private weak var view: ProductListViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private let repository: ProductRepository<Product>
    
    var products: [Product]?
    
    // MARK: -  Init
    required init(view: ProductListViewProtocol, networkService: NetworkServiceProtocol, repository: ProductRepository<Product>) {
        self.view = view
        self.networkService = networkService
        self.repository = repository
        
        fetchProducts()
    }
    
    // MARK: -  Public methods
    func fetchProducts() {
        networkService.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.products = products
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func returnProductsCount() -> Int {
        return products?.count ?? 0
    }
    
    func getProduct(at row: Int) -> Product? {
        return products?[row]
    }
    
    func sortProductByPrice() {
        products?.sort {
            $0.price > $1.price
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.succes()
            self.view?.selectPriceButton()
        }
        
    }
    
    func sortProductByRating() {
        products?.sort {
            $0.weight > $1.weight
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.succes()
            self.view?.selectRatingButton()
        }
    }
    
    func addProductToCart(at row: Int) {
        let product = products?[row]
        
        if let product = product {
            try? repository.insert(item: product)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.reloadCell(at: row)
        }
      
    }
    
    func isProductAddedToCart(at row: Int) -> Bool {
        
        let product = products?[row]
        
        let storableProducts = repository.getAll()
        
        for storableProduct in storableProducts {
            if product?.id == storableProduct.id {
                return true
            }
        }
        
        return false
    }
    
    func openModule(at index: Int) {
        guard let products = products else {
            return
        }

        let productDetailModule = ModuleBuilder.createProductDetailModule(products: products, index: index)
        
        view?.presentView(vc: productDetailModule)
    }
}
