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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let animationView = LOTAnimationView(name: "preloader")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        
        animationView.play{ (finished) in
            // Do Something
            animationView.play{ (finished) in
                // Do Something
                animationView.play{ (finished) in
                    // Do Something
                    animationView.play{ (finished) in
                        // Do Something
                        animationView.play{ (finished) in
                            // Do Something
                                self.performSegue(withIdentifier: "splashScreenSeg", sender: self)
                        }
                    }
                }
            }
        }
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
