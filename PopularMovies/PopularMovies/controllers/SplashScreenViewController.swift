//
//  SplashScreenViewController.swift
//  PopularMovies
//
//  Created by Ahmed Mokhtar on 4/23/18.
//  Copyright © 2018 Ahmed Mokhtar. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    private var boatAnimation: LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Create Boat Animation
        boatAnimation = LOTAnimationView(name: "preloader")
        // Set view to full screen, aspectFill
        boatAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation!.contentMode = .scaleAspectFill
        boatAnimation!.frame = view.bounds
        // Add the Animation
        view.addSubview(boatAnimation!)
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
