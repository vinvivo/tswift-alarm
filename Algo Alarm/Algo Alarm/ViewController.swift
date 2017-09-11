//
//  ViewController.swift
//  Algo Alarm
//
//  Created by Liseth Cardozo Sejas, Shantini Vyas, Jonathan Poso, and Vinney Le
//  on 9/8/17.
//  Copyright © 2017 T-SWIFT. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var motionManager: CMMotionManager?
    var seconds: TimeInterval = 0
    var timer = Timer()
    var songSelection: String = "Ding"
  
    @IBOutlet weak var SetDate: UIDatePicker!
    
//--Switch to enable alarm
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBAction func alarmSwitchEnabled(_ sender: UISwitch) {
        if alarmSwitch.isOn == true {
            print("Alarm switch toggled ON")
            runTimer()
        }
        if alarmSwitch.isOn == false {
            print("Alarm switch toggled OFF")
            timer.invalidate()
        }
    }
    
    func runTimer() {
        if self.SetDate != nil {
            let someDateTime = self.SetDate.date
            self.seconds = someDateTime.timeIntervalSinceNow
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        }
    }

//--What to do when alarm goes off
    func updateTimer() {
        if Int(seconds) < 1 {
            print("Alarm going off")
            timer.invalidate()
            performSegue(withIdentifier: "mySegue", sender: nil)
        }
        else {
            seconds -= 1
            print(seconds)
        }
    }

//--Picker to select alarm sound
    @IBOutlet weak var soundPickerLabel: UILabel!
    @IBOutlet weak var soundPickerView: UIPickerView!
    let alarmSounds = ["Algo", "Ding", "Roll", "Happy", "Yellow"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    // we only need one row in the picker view
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(alarmSounds[row])
        songSelection = alarmSounds[row]
        return alarmSounds[row]     // return the String value for the picker selection
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alarmSounds.count    // gets number of rows in array
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //label.text = alarmSounds[row]
    }

//--Slider to select alarm length/ intensity
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBAction func sliderDidChange(_ sender: UISlider) {
        print("Slider has been changed")
        print(Int(sliderView.value))
        sliderValueLabel.text = "\(Int(sliderView.value)) rotations"
    }
    
    
//--VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
//------Motion Manager declaration
        motionManager = CMMotionManager()
        if let manager = motionManager {
            print("We have a motion manager \(manager)")
            if manager.isDeviceMotionAvailable {
                print("We can detect motion!")
                let myq = OperationQueue()
                manager.deviceMotionUpdateInterval = 1
                manager.startDeviceMotionUpdates(to: myq){
                    (data: CMDeviceMotion?, error: Error?) in
                    if data != nil {
                        print("we have motion data!")
                    }
                }
            }
            else { print("We cannot detect motion") }
        }
        else { print("No manager") }

//------Customize slider
        sliderView.tintColor = UIColor.black
        sliderView.isContinuous = false

//------Customize switch
        alarmSwitch.tintColor = UIColor.black
        alarmSwitch.onTintColor = UIColor.black
        
//----- Gradient background created programmatically
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor( red:0.557, green:0.000, blue:0.000, alpha:1.000).cgColor,UIColor( red:1.000, green:0.000, blue:0.000, alpha:1.000).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//- Prevent change in phone orientation (i.e., only allow portrait orientation)
    override open var shouldAutorotate: Bool {
        return false
    }
    
//--Pass information through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlarmViewController
        destination.manager = self.motionManager
        destination.rotationCount = Int(sliderView.value)
        destination.songSelection = songSelection
    }


}

