//
//  ViewController.swift
//  OpenJiroMap
//
//  Created by 清 貴幸 on 2017/11/23.
//  Copyright © 2017年 Takayuki Sei. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

let OpenJiroAPIEndpoint = ""

class ViewController: UIViewController {
    var shouldUpdate = true
    var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleMap()
        
        Alamofire.request(OpenJiroAPIEndpoint).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    func setupGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        
        view.addSubview(mapView)
        
        DispatchQueue.main.async() {
            self.mapView.isMyLocationEnabled = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !shouldUpdate {
            return
        }
        
        shouldUpdate = false
        let location: CLLocation = change![.newKey] as! CLLocation
        mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14)
    }
    
    deinit {
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
}

