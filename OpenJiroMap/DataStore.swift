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

class DataStore {
    public static let shared = DataStore()
    public var jiroItems: [JiroItem] = []
    
    public func fetchItems(completion: @escaping ([JiroItem]) -> Void) {
        let decoder = JSONDecoder()
        Alamofire.request(OpenJiroAPIEndpoint).responseDecodableObject(keyPath: nil, decoder: decoder) { (response: DataResponse<[JiroItem]>) in
            let jiroItems = response.result.value
            
            guard let items = jiroItems else {
                return
            }
            
            self.jiroItems = items
            
            let filterdItems = Filter.shared.exec(items: items)
            completion(filterdItems)
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
    
    func exec(items: [JiroItem]) -> [JiroItem] {
        let typeFiltered = items.filter { typeFilter(item: $0) }
        return typeFiltered
    }
    
    func typeFilter(item: JiroItem) -> Bool {
        let typeInt = item.type
        let typeFilterdItems = types.map { str -> Int in
            return jiroTypes.index(of: JiroType(rawValue: str)!)!
        }
        
        return typeFilterdItems.contains(typeInt)
    }
    
    static func registerDefaults() {
        let ud = UserDefaults.standard
        ud.register(defaults: [
            "type" : ["直系", "インスパイア", "亜流"],
            ])
    }
}

enum JiroType: String {
    case Chokkei = "直系"
    case Inspire = "インスパイア"
    case Aryu = "亜流"
}

let jiroTypes: [JiroType] = [.Chokkei, .Inspire, .Aryu]
