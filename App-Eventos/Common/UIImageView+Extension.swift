//
//  UIImageView+Extension.swift
//  App-Eventos
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(with url: URL?) {
        guard let url = url else {
            image = nil
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let newImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        strongSelf.image = newImage
                    }
                } else {
                    print("Fetch image error: \(error?.localizedDescription ?? "n/a")")
                }
            }.resume()
        }
    }
}
