//
//  ViewController.swift
//  test audio interruption
//
//  Created by Patrick Lau on 2016-08-05.
//  Copyright © 2016 PLauDev. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player = AVAudioPlayer()
    
    let audioPath = NSBundle.mainBundle().pathForResource("rachmaninov-romance-sixhands-alianello", ofType: "mp3")!
    
    /*
    func handleInterruption(notification: NSNotification) {
        
        //guard let interruptionType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? AVAudioSessionInterruptionType else { print("wrong type"); return }
        
        if notification.name != AVAudioSessionInterruptionNotification
            || notification.userInfo == nil{
            return
        }
        
        var info = notification.userInfo!
        var intValue: UInt = 0
        (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
        if let interruptionType = AVAudioSessionInterruptionType(rawValue: intValue) {
        
            switch interruptionType {
                
            case .Began:
                print("began")
                // player is paused and session is inactive. need to update UI)
                player.pause()
                print("audio paused")
                
            default:
                print("ended")
                /** /
                if let option = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? AVAudioSessionInterruptionOptions where option == .ShouldResume {
                    // ok to resume playing, re activate session and resume playing
                    // need to update UI
                    player.play()
                    print("audio resumed")
                }
                / **/
                player.play()
                print("audio resumed")
            }
        }
    }
    */
    
    func handleInterruption(notification: NSNotification) {
        // new from Leo Dabus http://stackoverflow.com/a/38800403/1827488
        print("handleInterruption")
        guard
            let value = (notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber)?.unsignedIntegerValue,
            let interruptionType = AVAudioSessionInterruptionType(rawValue: value)
            else { return }
        switch interruptionType {
        case .Began:
            print("began")
        // player is paused and session is inactive. need to update UI)
        default :
            print("ended")
            if let option = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? AVAudioSessionInterruptionOptions where option == .ShouldResume {
                // ok to resume playing, re activate session and resume playing
                // need to update UI
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            player.numberOfLoops = -1 // play indefinitely
            player.prepareToPlay()
            //player.delegate = player
            
        } catch {
            // process error here
        }
        
        // enable play in background http://stackoverflow.com/a/30280699/1827488 but this audio still gets interrupted by alerts
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // will this resume play? http://stackoverflow.com/a/32635113/1827488
        /*
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)

        } catch {
            
        }
        */
        
        // add observer to handle audio interruptions
        // using 'object: nil' does not have a noticeable effect
        /**/
        let theSession = AVAudioSession.sharedInstance()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.handleInterruption(_:)), name: AVAudioSessionInterruptionNotification, object: theSession)
        /**/
        
        // start playing audio
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

