//
//  CurrentRunVC.swift
//  Treads
//
//  Created by Jeremiah Ufot on 1/17/19.
//  Copyright © 2019 Jeremiah Ufot. All rights reserved.
//

import UIKit

class CurrentRunVC: LocationVC {
    
    @IBOutlet weak var swipeBGImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Creates a slide slide recognizer
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate

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
                    //End Run code goes here
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
