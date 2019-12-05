//
//  SecondViewController.swift
//  CoPilot
//
//  Created by George Chilian on 05/12/2019.
//  Copyright © 2019 George Chilian. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {

    var resultSearchController:UISearchController? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Find User Location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true

        //Zoom to User Location
        if let userLocation = locationManager.location?.coordinate {
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
            
        //Set up Search Results table
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //Set up Search Bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Destinations..."
        navigationItem.titleView = resultSearchController?.searchBar
        
        //Configure UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
            
        locationSearchTable.mapView = mapView
            
    }


}

}

extension SecondViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}
