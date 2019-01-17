//
//  BeginRunVC.swift
//  Treads
//
//  Created by Jeremiah Ufot on 1/4/19.
//  Copyright © 2019 Jeremiah Ufot. All rights reserved.
//

import UIKit
import MapKit

class BeginRunVC: LocationVC {
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate =  self
    }
    
    //Starts updating user's location
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    //Stops updating user's location
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    

    @IBAction func locationCenterBtnPressed(_ sender: Any) {
        
    }
    
}

//After location is authorized the dot for the user's location will appear
extension BeginRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}






