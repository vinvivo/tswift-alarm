//
//  AlarmViewController.swift
//  Algo Alarm
//
//  Created by Vinney Le on 9/10/17.
//  Copyright © 2017 T-SWIFT. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import MediaPlayer

class AlarmViewController: UIViewController {
    var manager: CMMotionManager?
    var rotationCount: Int?
    var songSelection: String?
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var alarmImage: UIImageView!
    
    
    var rotationSelection: Int = Int()  // generated in ViewDidLoad
    
    //- Set minumum rotation rate for turning off alarm [x, y, z] units of radians/second
    var expected:[Double] = [60, 60, 60]
    
    //- StartAlarm
    func StartAlarm(Manager: CMMotionManager, Expected: [Double]){
        let myq = OperationQueue() //declares a new queue
        var count = 0
        var lazy = 0
        //  self.rotationRate.text = String("Hello!")
        
        Manager.startDeviceMotionUpdates(to: myq){ //callback function from starting the updates and adding them to the queue
            (data: CMDeviceMotion?, error: Error?) in //data that is expected tp come in from the device motion updates
            if let mydata = data {
                let rotation = mydata.rotationRate
                var rotationArray: [Double] = []
                let rx = abs(self.degrees(radians: rotation.x))
                let ry = abs(self.degrees(radians: rotation.y))
                let rz = abs(self.degrees(radians: rotation.z))
                rotationArray.append(rx)
                rotationArray.append(ry)
                rotationArray.append(rz)
                
                if lazy > 10 {
                    count = 0
                    lazy = 0
                }
                if rotationArray[self.rotationSelection] < Expected[self.rotationSelection]{
                    print("going too slow")
                    lazy += 1
                }
                else{
                    count += 1
                }
                
                print(rotationArray[self.rotationSelection])
                
                print(count)
                print(lazy)
                if let alarmDifficulty = self.rotationCount {
                    if count > alarmDifficulty {
                        print("YAY!")
                        Manager.stopDeviceMotionUpdates()
                        self.audioPlayer.pause()
                        DispatchQueue.main.async {
                            //self.morningLabel.isHidden = false
                            self.performSegue(withIdentifier: "goodMorningSegue", sender: nil)
                        }
                        //self.performSegue(withIdentifier: "goodMorningSegue", sender: nil)
                        
                        
                        // The next line moves the
                        //DispatchQueue.main.async {
                        //    self.rotateLabel.text = "G O O D   M O R N I N G"
                        //}
                    }
                }
            }
        }
    }
    
    //----- Reset alarm
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(songSelection)
        if let manager = manager {
            self.StartAlarm(Manager: manager, Expected: self.expected)
        }
        
        //----- Gradient background created programmatically
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor( red:0.557, green:0.000, blue:0.000, alpha:1.000).cgColor,UIColor( red:1.000, green:0.000, blue:0.000, alpha:1.000).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        //----- randomly select rotation axis on load
        let randomNumber = Int(arc4random_uniform(3))
        rotationSelection = randomNumber     // this sets var rotation to an integer used in func StartAlarm
        if randomNumber == 0 {
            alarmImage.image = UIImage(named: "pitchAxis")
        } else if randomNumber == 1 {
            alarmImage.image = UIImage(named: "rollAxis")
        } else {
            alarmImage.image = UIImage(named: "yawAxis")
        }
        
        //----- Display instructions in label on UI
        //rotateLabel.text = "Rotate phone \(aroundAxis) to turn off alarm"
        
        //----- Auto-play audio on load
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: songSelection, ofType: "mp3")!))
            print(songSelection)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch{
                //
            }
        }
        catch {
            print(error)
        }
        
//----- Maximize volume
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)
        
    }
    
    func degrees(radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//- Prevent change in phone orientation (i.e., only allow portrait orientation)
    override open var shouldAutorotate: Bool {
        return false
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
