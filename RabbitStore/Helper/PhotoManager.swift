//
//  PhotoManager.swift
//  RabbitStore
//
//  Created by 蔡忠翊 on 2021/9/14.
//

import Foundation
import UIKit
import Alamofire

struct UploadImageResult: Decodable {
    struct Data: Decodable {
        let link: URL
    }
    let data: Data
}

class PhotoManager {
    static let shared = PhotoManager()
    private var imageCache = NSCache<NSURL, NSData>()
    
    // upload Image
    func uploadImage(image: UIImage,completion:@escaping(UploadImageResult.Data) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID 10d48f72db0ee44",
        ]
        AF.upload(multipartFormData: { (data) in
            let imageData = image.jpegData(compressionQuality: 0.9)
            data.append(imageData!, withName: "image")
        }, to: "https://api.imgur.com/3/image", headers: headers).responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result {
            case .success(let result):
                print(result.data.link)
                completion(result.data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // download Image
    func downloadImage(url:URL,completion: @escaping (UIImage?)-> Void) {
        
        guard let imageData = imageCache.object(forKey: url as NSURL)
              else {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.imageCache.setObject(data as NSData, forKey: url as NSURL)
                completion(image)
            }.resume()
            
            return
            
        }
        
        completion(UIImage(data: imageData as Data))
    }
    
}
