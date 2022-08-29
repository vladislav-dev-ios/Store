//
//  ShoppingCartTableViewCell.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 27.08.2022.
//

import Foundation
import UIKit

class ShoppingCartTableViewCell: UITableViewCell {
    
    // MARK: -  Properties
    static let identifier = "ShoppingCartTableViewCell"
    
    weak var delegate: ShoppingCartTableViewCellDelagete?
    
    private var product: Product?
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var reduceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(reduceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: -  Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
    }
    
}

// MARK: -  Private Methods
extension ShoppingCartTableViewCell {
    private func setupConstraints() {
        contentView.addSubviews([
            productImageView,
            nameLabel,
            countLabel,
            priceLabel,
            deleteButton,
            addButton,
            reduceButton
        ])
        NSLayoutConstraint.activate([
            productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 5/6),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            
            priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.rightAnchor.constraint(equalTo: addButton.rightAnchor),
            deleteButton.leftAnchor.constraint(equalTo: reduceButton.leftAnchor),
            
            addButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            addButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -5),
            
            countLabel.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -10),
            countLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            
            reduceButton.rightAnchor.constraint(equalTo: countLabel.leftAnchor, constant: -10),
            reduceButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
    
    @objc
    private func deleteButtonTapped() {
        guard let product = product else { return }

        delegate?.deleteButtonTapped(product: product)
    }
    
    @objc
    private func addButtonTapped(_ sender: UIButton) {
        guard let product = product else { return }
        
        delegate?.addButtonTapped(product: product, row: sender.tag)
    }
    
    @objc
    private func reduceButtonTapped(_ sender: UIButton) {
        guard let product = product else { return }
        
        delegate?.reduceButtonTapped(product: product, row: sender.tag)
    }
}

// MARK: - Configure Cell
extension ShoppingCartTableViewCell {
    func configure(product: Product, count: Int, row: Int) {
        addButton.tag = row
        reduceButton.tag = row
        
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "Цена: \(product.price)"
        countLabel.text = "\(count)"
        
        guard let url = URL(string: product.image) else { return }
        
        ImageLoader.fetchImage(url: url) { image in
            if let image = image {
                self.productImageView.image = image
            }
        }
    }
}
