//
//  DataStore.swift
//  OpenJiroMap
//
//  Created by 清 貴幸 on 2017/12/12.
//  Copyright © 2017年 Takayuki Sei. All rights reserved.
//

import Foundation
import Alamofire


let OpenJiroAPIEndpoint = "https://openjiro-169415.firebaseapp.com/jiro.json"

struct LatLng: Codable {
    let latitude: Float
    let longitude: Float
}

struct JiroItem: Codable {
    let adress: String
    let holiday: String
    let id: Int
    let name: String
    let open: String
    let type: Int
    let urls: [String: String]
    let latlng: LatLng
    
}

enum JiroType: String {
    case Chokkei = "直系"
    case Aryu = "亜流"
    case Inspire = "インスパイア"
}

let jiroTypes: [JiroType] = [.Chokkei, .Aryu, .Inspire]

class DataStore {
    public func fetchItems(completion: @escaping ([JiroItem]) -> Void) {
        let decoder = JSONDecoder()
        Alamofire.request(OpenJiroAPIEndpoint).responseDecodableObject(keyPath: nil, decoder: decoder) { (response: DataResponse<[JiroItem]>) in
            let jiroItems = response.result.value
            
            guard let items = jiroItems else {
                return
            }
            
            completion(items)
        }
    }
}

class Filter {
    static let shared = Filter()
    
    var types: [String] {
        didSet {
            UserDefaults.standard.set(types, forKey: "type")
        }
    }
    
    init() {
        if let types = UserDefaults.standard.object(forKey: "type") {
            self.types = types as! [String]
        } else {
            self.types = []
        }
    }
}
