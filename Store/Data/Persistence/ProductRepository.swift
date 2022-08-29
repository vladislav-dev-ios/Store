//
//  AnyRepository.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 27.08.2022.
//

import Foundation
import RealmSwift

class ProductRepository<RepositoryObject>: Repository
where RepositoryObject: Entity,
      RepositoryObject.StoreType: Object {
    
    typealias RealmObject = RepositoryObject.StoreType
    
    private let realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func getAll(where predicate: NSPredicate?) -> [RepositoryObject] {
        var objects = realm.objects(RealmObject.self)
        
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        return objects.compactMap{ ($0).model as? RepositoryObject }
    }
    
    func insert(item: RepositoryObject) throws {
        try realm.write {
            realm.add(item.toStorable())
        }
    }
    
    func update(item: RepositoryObject) throws {
        try delete(item: item)
        try insert(item: item)
    }
    
    func delete(item: RepositoryObject) throws {
        try realm.write {
            let predicate = NSPredicate(format: "uuid == %@", item.toStorable().uuid)
            if let productToDelete = realm.objects(RealmObject.self)
                .filter(predicate).first {
                realm.delete(productToDelete)
            }
        }
    }
    
    func updateRealmObject(item: RepositoryObject, with dictionary: [String:Any?]) throws {
        try realm.write {
            let predicate = NSPredicate(format: "uuid == %@", item.toStorable().uuid)
            if let productToUpdate = realm.objects(RealmObject.self)
                .filter(predicate).first {
                for (key, value) in dictionary {
                    productToUpdate.setValue(value, forKey: key)
                }
            }
        }
    }
    
    func getRealmObject(item: RepositoryObject) -> RealmObject? {
        let predicate = NSPredicate(format: "uuid == %@", item.toStorable().uuid)
        if let product = realm.objects(RealmObject.self)
            .filter(predicate).first {
            return product
        }
        
        return nil
    }   
    
}
