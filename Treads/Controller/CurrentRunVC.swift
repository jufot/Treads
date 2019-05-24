//
//  CurrentRunVC.swift
//  Treads
//
//  Created by Jeremiah Ufot on 1/17/19.
//  Copyright © 2019 Jeremiah Ufot. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {
    
    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var timer = Timer()
    
    var runDistance = 0.0
    var pace = 0
    var counter = 0
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Creates a slide slide recognizer
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate

    }
    
    //Starts run when view apears
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    //Starts run
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(UIImage(named: "pauseButton"), for: .normal) //changes image pause
    }
    
    //Ends run and updates Realm
    func endRun() {
        manager?.stopUpdatingLocation()
        //Adds object to Realm
    }
    
    //Pauses run
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate() //stops the timer
        manager?.stopUpdatingLocation() //stops updating location
        pauseBtn.setImage(UIImage(named: "resumeButton"), for: .normal) //changes the image to resume button
    }
    
    //Start timer
    func startTimer() {
        durationLbl.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLbl.text = counter.formatTimeDurationToString()
    }
    
    func calculatePace(time seconds: Int, miles: Double) -> String {
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeDurationToString()
    }
    
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        if timer.isValid { //checks to see if the timer is valid
            pauseRun()
        } else {
            startRun()
        }
    }
    
    
    
    //Determines the location of the circle image view on the slider image view
    @objc func endRunSwiped(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat =  128
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: sender.view) //Gives the translation of the sender being passed in
                if sliderView.center.x >= (swipeBGImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBGImageView.center.x + maxAdjust)  {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= (swipeBGImageView.center.x + maxAdjust) { //If it's greater than our max point set it to the max point
                    sliderView.center.x = swipeBGImageView.center.x + maxAdjust
                    endRun()
                    dismiss(animated: true, completion: nil) //Dismisses current view and goes back to the main view
                } else {
                    sliderView.center.x = swipeBGImageView.center.x - minAdjust
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended { //Animates the image view back to the origin position
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBGImageView.center.x - minAdjust
                }
            }
        }
    }
}




extension CurrentRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    //Updates location if it has changed or not
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            distanceLbl.text = "\(runDistance.metersToMiles(places: 2))"
            if counter > 0 && runDistance > 0 {
                paceLbl.text = calculatePace(time: counter, miles: runDistance.metersToMiles(places: 2))
            }
        }
        lastLocation = locations.last
    }
}
