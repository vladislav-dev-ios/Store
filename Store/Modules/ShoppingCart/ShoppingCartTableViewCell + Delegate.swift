//
//  ShoppingCartTableViewCell + Delegate.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 27.08.2022.
//

import Foundation

protocol ShoppingCartTableViewCellDelagete: AnyObject {
    func deleteButtonTapped(product: Product)
    func addButtonTapped(product: Product, row: Int)
    func reduceButtonTapped(product: Product, row: Int)
}
