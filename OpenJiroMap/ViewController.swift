//
//  ViewController.swift
//  OpenJiroMap
//
//  Created by 清 貴幸 on 2017/11/23.
//  Copyright © 2017年 Takayuki Sei. All rights reserved.
//

import UIKit
import GoogleMaps
import CodableAlamofire

class ViewController: UIViewController, GMSMapViewDelegate {
    var shouldUpdate = true
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.clear()
        
        let store = DataStore.shared
        store.fetchItems { items in
            for item in items {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: CLLocationDegrees(item.latlng.latitude), longitude: CLLocationDegrees(item.latlng.longitude)))
                marker.title = item.name
                marker.snippet = item.open
                marker.map = self.mapView
            }
        }
    }
    
    func setupGoogleMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView.camera = camera
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        mapView.delegate = self
                
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }

}

