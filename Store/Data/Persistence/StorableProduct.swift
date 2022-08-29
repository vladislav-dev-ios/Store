//
//  StorableProduct.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 27.08.2022.
//

import Foundation
import RealmSwift

extension Product: Entity {
    private var storableProduct: StorableProduct {
        let realmProduct = StorableProduct()
        realmProduct.image = image
        realmProduct.price = price
        realmProduct.name = name
        realmProduct.weight = weight
        realmProduct.id = id
        realmProduct.desc = desc
        realmProduct.uuid = id
        return realmProduct
    }
    
    func toStorable() -> StorableProduct {
        return storableProduct
    }
}

class StorableProduct: Object, Storable {
    
    @objc dynamic var image: String = ""
    @objc dynamic var price: Double = 0.0
    @objc dynamic var name: String = ""
    @objc dynamic var weight: Double = 0.0
    @objc dynamic var id: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var uuid: String = ""
    @objc dynamic var count: Int = 1
    
    var model: Product {
        get {
            return Product(image: image, price: price, name: name, weight: weight, id: id, desc: desc)
        }
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
}
