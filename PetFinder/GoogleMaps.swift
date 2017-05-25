//
//  GoogleMaps.swift
//  PetFinder
//
//  Created by Laban on 2017/5/18.
//  Copyright © 2017年 Cheng Jung Chen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMaps: UIViewController {

    var gmsFetcher: GMSAutocompleteFetcher!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
    
        let currentLocation = CLLocationCoordinate2DMake(24.147573, 120.575581)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: 15)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.view = mapView
        let marker = GMSMarker(position: currentLocation)
        marker.title = "臺中市中途動物醫院"
        marker.snippet = "408台中市南屯區中台路601號"
        marker.map = mapView
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self as? GMSAutocompleteFetcherDelegate
    }
    
    @IBAction func toMyLocation(_ sender: Any) {
        //
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
