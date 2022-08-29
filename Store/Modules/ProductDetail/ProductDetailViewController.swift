//
//  ProductViewController.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 29.08.2022.
//

import Foundation
import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: -  Properties
    var presenter: ProductDetailPresenterProtocol?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    private lazy var addToCartButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configure()
        setupSwipes()
    }
    
    override func viewDidLayoutSubviews() {
        let height = contentView.subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY
        if let height = height {
            scrollView.contentSize.height = height
        }
        
    }
}

// MARK: -  Private Methods
extension ProductDetailViewController {
    private func configure() {
        contentView.addSubviews([
            productImageView,
            nameLabel,
            descriptionLabel,
            priceLabel,
            ratingLabel,
            addToCartButton
        ])
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            nameLabel.leftAnchor.constraint(equalTo: contentView.safeLeftAnchor, constant: 40),
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            
            descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.safeRightAnchor, constant: -40),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            ratingLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            
            addToCartButton.rightAnchor.constraint(equalTo: contentView.safeRightAnchor, constant: -20),
            addToCartButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            addToCartButton.widthAnchor.constraint(equalToConstant: 40),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeTopAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
        ])
        
    }
    
    private func setupSwipes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc
    private func addToCartButtonTapped() {
        presenter?.addProductToCart()
    }
    
    @objc
    private func didSwipeLeft(gesture: UISwipeGestureRecognizer) {
        presenter?.loadNextProduct()
    }
    
    @objc
    private func didSwipeRight(gesture: UISwipeGestureRecognizer) {
        presenter?.loadPreviousProduct()
    }
}

// MARK: - ProductDetailView Protocol 
extension ProductDetailViewController: ProductDetailViewProtocol {
    
    func setupProduct(product: Product) {
        title = product.name
        nameLabel.text = product.name
        priceLabel.text = "Цена: \(product.price)"
        ratingLabel.text = "Рейтинг: \(product.weight)"
        
        let data = Data(product.desc.utf8)

        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            descriptionLabel.attributedText = attributedString
        }
        
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

