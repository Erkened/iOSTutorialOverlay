//
//  JNTutorialOverlay.swift
//  iOSTutorialOverlay
//
//  Created by Jonathan Neumann on 20/02/2015.
//  Copyright (c) 2015 Audio Y. All rights reserved.
//  www.audioy.co

import Foundation
import UIKit

struct ScreenConstants {
    
    static var size: CGRect = UIScreen.mainScreen().bounds
    static var width = size.width
    static var height = size.height
    static var scale:CGFloat = UIScreen.mainScreen().scale
}

struct ColourConstants {
    // If the RGB value is 252831, pass 0x252831 as the HEX value
    
    static var mercury = getUIColorObjectFromHex("E6E6E6", 1.0) // Normal text colour, light grey
    static var shark = getUIColorObjectFromHex("1A1C22", 1.0) // Darker background colour, very dark blue
    static var brightTurquoise = getUIColorObjectFromHex("31D8F8", 1.0) // Bright turquoise colour
}

enum Corners{
    case Straight
    case Rounded
}

enum Theme{
    case Dark
    case Light
}

// Custom UIView with the name of the overlay (stored in NSUserDefaults)
class JNTutorialOverlay:UIView{
    
    var overlayName:String? // The name saved in NSUserDefaults once the overlay has been removed
    var opacity:CGFloat?
    let oneTap = UITapGestureRecognizer()
    var onHide: ((Bool) -> ())? // This is the completion handler to be called when hideOverlay is called
    
    var corners:Corners?{
        didSet {
            switch self.corners!{
                
            case .Straight:
                setStraightCorners()
            case .Rounded:
                setRoundedCorners()
            }
        }
    }
    
    var theme:Theme?{
        didSet {
            switch self.theme!{
                
            case .Dark:
                setDarkTheme()
            case .Light:
                setLightTheme()
            }
        }
    }
    
    private var overlayView:UIView?
    private var titleLabel:UILabel?
    private var messageLabel:UILabel?
    private var imageView:UIImageView?
    
    var title:String?{
        didSet{
            self.titleLabel?.text = self.title!
        }
    }
    
    var message:String?{
        didSet{
            if let message = message{
                setMessageLabel(message)
            }
        }
    }
    
    var image:UIImage?{
        didSet{
            if let image = self.image{
                setImageView(image)
            }
        }
    }
    
    /* -------- INIT METHODS -------- */
    
    // Init with a centred frame and no picture
    init(overlayName:String, width:CGFloat, height:CGFloat, opacity: CGFloat, title:String?, message:String?){
        
        super.init(frame: CGRectMake(0, 0, ScreenConstants.width, ScreenConstants.height))
        
        // Centre the frame within the screen
        //super.init(frame:CGRectMake((ScreenConstants.width - width)/2, (ScreenConstants.height - height)/2, width, height))
        // Create the overlay and centre it within the screen
        createOverlay(CGRectMake((ScreenConstants.width - width)/2, (ScreenConstants.height - height)/2, width, height), overlayName: overlayName, opacity: opacity, title: title, message: message, image: nil)
    }
    
    // Init with a centred frame and a picture
    init(overlayName:String, width:CGFloat, height:CGFloat, opacity: CGFloat, title:String?, message:String?, image:UIImage?){
        
        super.init(frame: CGRectMake(0, 0, ScreenConstants.width, ScreenConstants.height))
        // Centre the frame within the screen
        //super.init(frame:CGRectMake((ScreenConstants.width - width)/2, (ScreenConstants.height - height)/2, width, height))
        // Create the overlay and centre it within the screen
        createOverlay(CGRectMake((ScreenConstants.width - width)/2, (ScreenConstants.height - height)/2, width, height), overlayName: overlayName, opacity: opacity, title: title, message: message, image: image)
    }
    
    // Init with a set frame and no picture
    init(overlayName:String, frame:CGRect, opacity:CGFloat, title:String?, message:String?) {
        
        super.init(frame: CGRectMake(0, 0, ScreenConstants.width, ScreenConstants.height))
        // Init the frame
        //super.init(frame: frame)
        // Create the overlay
        createOverlay(frame, overlayName: overlayName, opacity: opacity, title: title, message: message, image: nil)
    }
    
    // Init with a set frame and a picture
    init(overlayName:String, frame:CGRect, opacity:CGFloat, title:String?, message:String?, image:UIImage?) {
        
        super.init(frame: CGRectMake(0, 0, ScreenConstants.width, ScreenConstants.height))
        // Init the frame
        //super.init(frame: frame)
        // Create the overlay
        createOverlay(frame, overlayName: overlayName, opacity: opacity, title: title, message: message, image: image)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* -------- OVERLAY VIEW METHODS -------- */
    func createOverlay(frame: CGRect, overlayName:String, opacity: CGFloat, title:String?, message:String?, image:UIImage?){
        
        // Init the name
        self.overlayName = overlayName
        // Init the opacity
        self.opacity = opacity
        // Init the tap to get rid of the overlay
        oneTap.addTarget(self, action: "hideOverlay:")
        self.addGestureRecognizer(oneTap)
        
        // Prepare the overlay view
        overlayView = UIView(frame: frame)
        
        // Set a dark theme by default
        setDarkTheme()
        // Set rounded corners by default
        setRoundedCorners()
        
        // Prepare the title label
        var font = UIFont(name: "Helvetica-Bold", size: 19.0)
        titleLabel = UILabel(frame: CGRectMake(10, 20, overlayView!.frame.width - 20, 50))
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .Center
        titleLabel?.font = font!
        titleLabel?.textColor = ColourConstants.mercury
        // Assign it the text if it has been set
        if let title = title{
            self.title = title
            titleLabel?.text = title
        }
        
        // Prepare the message label
        font = UIFont(name: "Helvetica", size: 16.0)
        messageLabel = UILabel(frame: CGRectMake(20, 90, overlayView!.frame.width - 40, 0))
        messageLabel?.numberOfLines = 0
        messageLabel?.textAlignment = .Center
        messageLabel?.font = font!
        messageLabel?.textColor = ColourConstants.mercury
        // Assign it the message if it has been set
        if let message = message{
            self.message = message
            setMessageLabel(message)
        }
        
        // Prepare the image view
        self.imageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        if let image = image{
            self.image = image
            setImageView(image)
        }
        
        overlayView?.addSubview(titleLabel!)
        overlayView?.addSubview(messageLabel!)
        overlayView?.addSubview(imageView!)
        self.addSubview(overlayView!)
    }
    
    // Use this function to show the view
    func show(){
        
        if checkScreenShownBefore(self.overlayName!) == false{
            animateWithPopIn()
        }
    }
    
    // Use this function to show the view and know when it's been hidden thanks to the block
    func showWithBlock(onHide: (Bool) -> ()){
        
        self.onHide = onHide
        
        if checkScreenShownBefore(self.overlayName!) == false{
            animateWithPopIn()
        }
        
    }
    
    func hideOverlay(sender:UITapGestureRecognizer){
        
        if let name = self.overlayName{
            // Save in NSUserDefaults as this overlay is not to be shown again
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: name)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        // Animate
        animateWithPopOut()
    }
    
    /* -------- SETTING METHODS IN ORDER TO AVOIR REPEATING CODE -------- */
    func setStraightCorners(){
        overlayView?.layer.borderWidth = 3
        overlayView?.layer.cornerRadius = 0
    }
    
    func setRoundedCorners(){
        overlayView?.layer.borderWidth = 3
        overlayView?.layer.cornerRadius = 10
        overlayView?.clipsToBounds = true
    }
    
    func setDarkTheme(){
        self.backgroundColor = getUIColorObjectFromHex("000000", 0.5)
        overlayView?.backgroundColor = getUIColorObjectFromHex("000000", opacity!)
        overlayView?.layer.borderColor = UIColor.blackColor().CGColor
        self.titleLabel?.textColor = ColourConstants.mercury
        self.messageLabel?.textColor = ColourConstants.mercury
    }
    
    func setLightTheme(){
        self.backgroundColor = getUIColorObjectFromHex("FFFFFF", 0.5)
        overlayView?.backgroundColor = getUIColorObjectFromHex("FFFFFF", opacity!)
        overlayView?.layer.borderColor = UIColor.whiteColor().CGColor
        self.titleLabel?.textColor = ColourConstants.shark
        self.messageLabel?.textColor = ColourConstants.shark
    }
    
    func setMessageLabel(message:String){
        self.messageLabel?.text = message
        self.messageLabel?.sizeToFit()
        self.messageLabel?.frame = CGRectMake(20, 90, overlayView!.frame.width - 40, self.messageLabel!.frame.height)
        // Move the image if it already exists
        if let image = self.image{
            setImageView(image)
        }
    }
    
    func setImageView(image:UIImage){
        // Reset the imageView frame to the dimensions of the image
        self.imageView?.frame.size.width = image.size.width
        self.imageView?.frame.size.height = image.size.height
        // Set the frame in the middle
        self.imageView?.frame.origin.y = messageLabel!.frame.origin.y + messageLabel!.frame.height + 20
        self.imageView?.frame.origin.x = (overlayView!.frame.width - image.size.width)/2
        // Finally, set the image
        self.imageView?.image = self.image!
    }
    
    /* -------- ANIMATION METHODS -------- */
    func animateWithPopIn(){
        
        let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!!
        let originalFrame = overlayView!.frame
        
        // Start at the centre
        overlayView!.frame.origin.x = originalFrame.origin.x + originalFrame.width/2
        overlayView!.frame.size.width = 0
        overlayView!.frame.origin.y = originalFrame.origin.y + originalFrame.height/2
        overlayView!.frame.size.height = 0
        
        // Hide everything
        hideElements()
        
        rootViewController.view.addSubview(self)
        
        // Animate
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
            
            // Expand too much!
            self.overlayView!.frame.origin.x = originalFrame.origin.x - 10
            self.overlayView!.frame.size.width = originalFrame.width + 20
            self.overlayView!.frame.origin.y = originalFrame.origin.y - 10
            self.overlayView!.frame.size.height = originalFrame.height + 20
            
            }, completion: { finished in
                
                // Shrink back to the intended frame
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    self.overlayView!.frame = originalFrame
                    self.showElements()
                    }, nil)
        })
    }
    
    func animateWithPopOut(){
        
        // Hide everything
        hideElements()
        
        // Animate
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseOut, animations: {
            
            // Step 1 - Expand a little bit...
            self.overlayView!.frame.origin.x = self.overlayView!.frame.origin.x - 10
            self.overlayView!.frame.size.width = self.overlayView!.frame.width + 20
            self.overlayView!.frame.origin.y = self.overlayView!.frame.origin.y - 10
            self.overlayView!.frame.size.height = self.overlayView!.frame.height + 20
            }, completion: { finished in
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    // Step 2 - Shrink!
                    self.overlayView!.frame.origin.x = self.overlayView!.frame.origin.x + self.overlayView!.frame.width/2
                    self.overlayView!.frame.size.width = 0
                    self.overlayView!.frame.origin.y = self.overlayView!.frame.origin.y + self.overlayView!.frame.height/2
                    self.overlayView!.frame.size.height = 0
                    
                    }, completion: { finished in
                        self.removeFromSuperview()
                        self.onHide?(true) // Let the block know the overlay has finished being removed
                })
        })
    }
    
    func hideElements(){
        
        self.titleLabel?.alpha = 0
        self.messageLabel?.alpha = 0
        self.imageView?.alpha = 0
    }
    
    func showElements(){
        
        self.titleLabel?.alpha = 1
        self.messageLabel?.alpha = 1
        self.imageView?.alpha = 1
    }
    
}

/* -------- CUSTOM METHODS -------- */

func checkScreenShownBefore(name:String) -> BooleanLiteralType{
    
    if let hasBeenShown:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(name){
        // If an object was returned, it means that something was shown. No need to create the overlay then!
        return true
    }
    else {
        return false
    }
}

func getUIColorObjectFromHex(hex:String, alpha:CGFloat) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(advance(cString.startIndex, 1))
    }
    
    if (countElements(cString) != 6) {
        return UIColor.grayColor()
    }
    
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha)
    )
}