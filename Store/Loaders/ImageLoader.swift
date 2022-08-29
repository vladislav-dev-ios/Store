//
//  ImageLoader.swift
//  Store
//
//  Created by Владислав Кузьмичёв on 26.08.2022.
//

import Foundation
import UIKit

protocol Loader {
    
    static func fetchImage(url: URL, _ completion : @escaping (_ image: UIImage?) -> Void)
    
}


class ImageLoader: Loader {
    
    static func fetchImage(url: URL, _ completion: @escaping (UIImage?) -> Void) {
        
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            if let imageData = try? Data(contentsOf: url) {
                let image = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
}
