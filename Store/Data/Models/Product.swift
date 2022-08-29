//
//  Product.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 26.08.2022.
//

import Foundation

struct Product: Decodable {
    var image: String
    var price: Double
    var name: String
    var weight: Double
    var id: String
    var desc: String
}
