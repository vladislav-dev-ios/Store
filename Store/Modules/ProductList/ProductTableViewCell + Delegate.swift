//
//  ProductTableViewCell + Delegate.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 29.08.2022.
//

import Foundation

protocol ProductTableViewCellDelegate: AnyObject {
    func addToCartButtonTapped(at row: Int)
}
