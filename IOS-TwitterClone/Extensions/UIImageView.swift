//
//  UIImageView.swift
//  IOS-TwitterClone
//
//  Created by Đoàn Văn Khoan on 23/04/2024.
//

import SwiftUI

extension UIImageView {
    func loadImage(from urlString: String, completion: ((UIImage?) -> Void)? = nil) {
        
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error fetching image: \(error)")
                completion?(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion?(nil)
                return
            }
            
            
            if let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.image = image
                    completion?(image)
                }
            } else {
                print("Failed to create image from data")
                completion?(nil)
            }
        }
        
        
        task.resume()
    }
}
