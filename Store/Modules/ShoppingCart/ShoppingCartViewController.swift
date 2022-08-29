//
//  ShoppingCartViewController.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 27.08.2022.
//

import Foundation
import UIKit

class ShoppingCartViewController: UIViewController {
    
    // MARK: -  Properties
    var presenter: ShoppingCartPresenterProtocol?
    
    private lazy var productTableView: UITableView = {
        let table = UITableView()
        table.register(ShoppingCartTableViewCell.self, forCellReuseIdentifier: ShoppingCartTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        presenter?.getProducts()
    }
}

// MARK: -  Private Methods
extension ShoppingCartViewController {
    private func configure() {
        view.addSubviews([
            productTableView,
            totalCostLabel
        ])
        NSLayoutConstraint.activate([
            productTableView.topAnchor.constraint(equalTo: view.safeTopAnchor),
            productTableView.bottomAnchor.constraint(equalTo: totalCostLabel.topAnchor, constant: -5),
            productTableView.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            productTableView.rightAnchor.constraint(equalTo: view.safeRightAnchor),
            
            totalCostLabel.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 10),
            totalCostLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.returnProductsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartTableViewCell.identifier, for: indexPath) as! ShoppingCartTableViewCell
        
        cell.prepareForReuse()
        
        let product = presenter?.getProduct(at: indexPath.row)
       
        if let product = product {
            let count = presenter?.returnCountOfProduct(product: product)
            
            if let count = count {
                cell.configure(product: product, count: count, row: indexPath.row)
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = productTableView.bounds.height / 4.0
        
        return height
    }
    
}

// MARK: - ShoppingCartView Protocol
extension ShoppingCartViewController: ShoppingCartViewProtocol {
    
    func setupProducts() {
        productTableView.reloadData()
    }
    
    func setupTotalCost(cost: Double) {
        totalCostLabel.text = "Общая стоимость: \(cost)"
    }
    
    func reloadCell(at row: Int) {
        let indexPath = IndexPath(item: row, section: 0)
        productTableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension ShoppingCartViewController: ShoppingCartTableViewCellDelagete {
    
    func addButtonTapped(product: Product, row: Int) {
        presenter?.addCountOfProduct(product: product, row: row)
    }
    
    func reduceButtonTapped(product: Product, row: Int) {
        presenter?.reduceCountOfProduct(product: product, row: row)
    }
        
    func deleteButtonTapped(product: Product) {
        presenter?.deleteProduct(product: product)
    }
    
    
    
}
