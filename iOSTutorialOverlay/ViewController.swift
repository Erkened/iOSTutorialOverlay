//
//  ViewController.swift
//  iOSTutorialOverlay
//
//  Created by Jonathan Neumann on 20/02/2015.
//  Copyright (c) 2015 Audio Y. All rights reserved.
//  www.audioy.co

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = ColourConstants.brightTurquoise
        
        let screen1 = JNTutorialOverlay(overlayName: "Screen1", width: 300, opacity: 0.8, title: "Screen 1", message: "This is the default overlay.\n The default overlay comes with a dark theme, rounded corners and is centered, but you can change that.")
        
        screen1.showWithBlock(){ hidden in
            
            println("Screen 1 has been hidden")
            
            let screen2 = JNTutorialOverlay(overlayName: "Screen2", frame: CGRectMake(0, 100, ScreenConstants.width - 100, 200), opacity: 0.6, title: "Screen 2", message: "This one for example does not have a centered frame, and the opacity is less.")
            
            screen2.showWithBlock(){ hidden in
                
                println("Screen 2 has been hidden")
                
                let screen3 = JNTutorialOverlay(overlayName: "Screen3", frame: CGRectMake(100, ScreenConstants.height - 200, ScreenConstants.width - 100, 200), opacity: 0.8, title: "Screen 3", message: "This one also has a custom frame but with a light theme and straight corners.")
                screen3.theme = .Light
                screen3.corners = .Straight
                
                screen3.showWithBlock(){ hidden in
                    
                    println("Screen 3 has been hidden")
                    
                    let screen4 = JNTutorialOverlay(overlayName: "Screen4", width: 250, opacity: 0.7, title: "Screen 4", message: "Overlays can also include a picture under the text, like this one.", image: UIImage(named: "Birdcast"))
                    
                    screen4.showWithBlock(){ hidden in
                        
                        println("Screen 4 has been hidden")
                        
                        let screen5 = JNTutorialOverlay(overlayName: "Screen5", frame: CGRectMake(0, 200, ScreenConstants.width, 200), opacity: 0.8, title: nil, message: nil)
                        
                        screen5.title = "Screen 5"
                        screen5.message = "Of course all the optional values such as title, message, picture, corners and theme can be modified after the overlay has been created."
                        screen5.theme = .Light
                        screen5.corners = .Straight
                        
                        screen5.showWithBlock(){ hidden in
                            
                            println("Screen 5 has been hidden")
                            
                            let screen6 = JNTutorialOverlay(overlayName: "Screen6", width: 300, opacity: 0.8, title: "Screen 6", message: "And because these overlays are supposed to be shown to a first-time user only, they will only appear once!")
                            
                            screen6.showWithBlock(){ hidden in
                                
                                println("Screen 6 has been hidden")
                                
                                let screen7 = JNTutorialOverlay(overlayName: "Screen7", width: 300, opacity: 0.8, title: "Final screen", message: "You can see these overlays in action in our apps Birdcast and Q-Beat (available for free on the App Store).\n\nWe hope you enjoyed this run-through.\nLet us know if you end up using our tutorial overlays in your apps! :)")
                                
                                screen7.show()
                            }
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


}

