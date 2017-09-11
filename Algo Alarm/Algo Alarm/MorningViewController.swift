//
//  MorningViewController.swift
//  Algo Alarm
//
//  Created by Vinney Le on 9/10/17.
//  Copyright © 2017 T-SWIFT. All rights reserved.
//

import UIKit

class MorningViewController: UIViewController {
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//----- Gradient background created programmatically
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor( red:0.459, green:0.835, blue:1.000, alpha:1.000).cgColor,UIColor( red:0.459, green:0.835, blue:1.000, alpha:1.000).cgColor,UIColor( red:0.996, green:0.984, blue:0.000, alpha:1.000).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
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
