//
//  ProductListViewController.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 26.08.2022.
//

import Foundation
import UIKit

class ProductListViewController: UIViewController {
    
    // MARK: -  Properties
    var presenter: ProductListPresenterProtocol?
    
    private lazy var productTableView: UITableView = {
        let table = UITableView()
        table.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Сортировать по:"
        label.textColor = .black
        return label
    }()
    
    private lazy var sortByPriceButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.setTitle("Цене", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.addTarget(self, action: #selector(sortForPriceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortByRatingButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.setTitle("Рейтингу", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.addTarget(self, action: #selector(sortForRatingButtonTapped), for: .touchUpInside)
        return button
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
        
        succes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: -  Private Methods
extension ProductListViewController {
    private func configure() {
        view.addSubviews([
            productTableView,
            sortByPriceButton,
            sortByRatingButton,
            sortLabel
        ])
        NSLayoutConstraint.activate([
            sortLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 10),
            sortLabel.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 5),
            
            sortByPriceButton.leftAnchor.constraint(equalTo: sortLabel.leftAnchor, constant: 20),
            sortByPriceButton.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 5),
            
            sortByRatingButton.leftAnchor.constraint(equalTo: sortByPriceButton.rightAnchor, constant: 10),
            sortByRatingButton.topAnchor.constraint(equalTo: sortByPriceButton.topAnchor),
            
            productTableView.topAnchor.constraint(equalTo: sortByPriceButton.bottomAnchor, constant: 10),
            productTableView.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            productTableView.rightAnchor.constraint(equalTo: view.safeRightAnchor),
            productTableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor)
        ])
    }
    
    @objc
    private func sortForPriceButtonTapped() {
        presenter?.sortProductByPrice()
    }
    
    @objc
    private func sortForRatingButtonTapped() {
        presenter?.sortProductByRating()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.returnProductsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        
        cell.prepareForReuse()
        
        let product = presenter?.getProduct(at: indexPath.row)
        let isAddedToCart = presenter?.isProductAddedToCart(at: indexPath.row)
        
        if let product = product {
            cell.configure(product: product, row: indexPath.row)
        }
        if let isAddedToCart = isAddedToCart {
            cell.configureCartButton(isAddedToCart: isAddedToCart)
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = productTableView.bounds.height / 4.0
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.openModule(at: indexPath.row)
    }
    
}

// MARK: - ProductListView Protocol
extension ProductListViewController: ProductListViewProtocol {
   
    func succes() {
        productTableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func selectPriceButton() {
        sortByPriceButton.isSelected = true
        sortByRatingButton.isSelected = false
    }
    
    func selectRatingButton() {
        sortByRatingButton.isSelected = true
        sortByPriceButton.isSelected = false
    }

    func reloadCell(at row: Int) {
        let indexPath = IndexPath(item: row, section: 0)
        productTableView.reloadRows(at: [indexPath], with: .left)
    }
    
    func presentView(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - ProductTableViewCell Delegate
extension ProductListViewController: ProductTableViewCellDelegate {
    
    func addToCartButtonTapped(at row: Int) {
        presenter?.addProductToCart(at: row)
    }
}
