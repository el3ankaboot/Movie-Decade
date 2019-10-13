//
//  FlickrClient.swift
//  Movie Decade
//
//  Created by Gamal Gamaleldin on 10/12/19.
//  Copyright © 2019 el3ankaboot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FlickrClient {
    static let apiKey = "3e7eeb4c8932f66add6ddb8a08ca63aa"
    static let secret = "798bb5c5a6b7e6da"
    static let imageCache = NSCache<NSString, UIImage>()
    static let imageUrlsCache = NSCache<NSString,NSArray>()
    
    enum Endpoints {
        static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)"
        
        case search(String)
        
        var stringValue : String {
            switch self {
            case .search(let movieTitle):
                return Endpoints.baseURL + "&text=\(movieTitle)&format=json&nojsoncallback=1&page=1&per_page=10"
            }
        }
        
        var url: URL {
            let urlString = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return URL(string: urlString!)!
        }
    }//Closing of enum
    
    class func getImagesURLs (movieTitle:String, completion: @escaping ([ImageUrl]? , String) -> Void){
        if let imagesInCache = imageUrlsCache.object(forKey: movieTitle as NSString) as? [ImageUrl] {
            completion(imagesInCache,"")
        }else {
            Alamofire.request(Endpoints.search(movieTitle).url, method: .get, encoding: JSONEncoding.default, headers: [:])
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Success")
                    case .failure(_):
                        completion(nil,"Failed to retrieve images.")
                        print("Failure")
                    }
                }
                .response { response in
                    if let data = response.data {
                        switch response.response?.statusCode {
                        case 200 :
                            let json = JSON(data)
                            let photos = json["photos"]
                            let photo = photos["photo"]
                            var imageURLs = [ImageUrl]()
                            var returnCount = 0
                            for p in photo {
                                let farmID = p.1["farm"].int ?? 0
                                let serverID = p.1["server"].string ?? "1"
                                let id = p.1["id"].string ?? "1"
                                let secret = p.1["secret"].string ?? ""
                                let imageUrl = ImageUrl(farmID: farmID, serverID: serverID, id: id, secret: secret)
                                imageURLs.append(imageUrl)
                                returnCount += 1
                                if returnCount == photo.count {completion(imageURLs ,"")}
                                imageUrlsCache.setObject(imageURLs as NSArray, forKey: movieTitle as NSString)
                            }
                            if photo.count == 0{
                                completion([],"Empty")
                                imageUrlsCache.setObject([] as NSArray, forKey: movieTitle as NSString)
                            }
                            
                            
                        default :
                            completion(nil ,"Failed to retrieve images.")
                        }
                        
                    }
            }
        }//Closing of else (Not cached)
    }//Closing of getImagesURLs Func
    
    class func images(imageUrlString: ImageUrl?, cell: ImagesCell ) {
        guard let imageUrlString = imageUrlString else {
            return
        }
        if let imageInCache = imageCache.object(forKey: imageUrlString.getURL() as NSString) {
            DispatchQueue.main.async {
                cell.imageView.image = imageInCache
                cell.shimmer?.isShimmering = false
            }
        }
        else {
            let imageURL = URL(string: imageUrlString.getURL())
            DispatchQueue.global().async {() in
                if let data = try? Data(contentsOf: imageURL!) {
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: imageUrlString.getURL() as NSString)
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                            cell.shimmer.isShimmering = false
                            
                        }
                    }
                }
            }
            
        }
    }
}
