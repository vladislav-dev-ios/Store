//
//  ProductListTableViewCell.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 26.08.2022.
//

import Foundation
import UIKit

class ProductTableViewCell: UITableViewCell {
    
    // MARK: -  Properties
    static let identifier = "ProductTableViewCell"
    
    weak var delegate: ProductTableViewCellDelegate?
    
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
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var addToCartButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
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

// MARK: - Priavate Methods
extension ProductTableViewCell {
    private func setupConstraints() {
        contentView.addSubviews([
            productImageView,
            nameLabel,
            priceLabel,
            ratingLabel,
            addToCartButton
        ])
        NSLayoutConstraint.activate([
            productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 5/6),
            
            nameLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            ratingLabel.leftAnchor.constraint(equalTo: priceLabel.leftAnchor),
            
            addToCartButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addToCartButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3),
            addToCartButton.widthAnchor.constraint(equalTo: addToCartButton.heightAnchor)
        ])
    }
    
    @objc
    private func addToCartButtonTapped(_ sender: UIButton) {
        delegate?.addToCartButtonTapped(at: sender.tag)
    }
}

// MARK: - Configure Cell
extension ProductTableViewCell {
    func configure(product: Product, row: Int) {
        
        addToCartButton.tag = row
        
        nameLabel.text = product.name
        priceLabel.text = "Цена: \(product.price)"
        ratingLabel.text = "Рейтинг: \(product.weight)"
        
        guard let url = URL(string: product.image) else { return }
        
        ImageLoader.fetchImage(url: url) { image in
            if let image = image {
                self.productImageView.image = image
            }
        }
        
    }
    
    func configureCartButton(isAddedToCart: Bool) {
        if isAddedToCart {
            addToCartButton.setImage(UIImage(named: "cart true"), for: .normal)
            addToCartButton.isUserInteractionEnabled = false
        } else {
            addToCartButton.setImage(UIImage(named: "cart false"), for: .normal)
            addToCartButton.isUserInteractionEnabled = true
        }

    }
}
