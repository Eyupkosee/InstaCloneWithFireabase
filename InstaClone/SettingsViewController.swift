//
//  SettingsViewController.swift
//  InstaClone
//
//  Created by eyüp köse on 9.05.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutButtonClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewVC", sender: nil)
        }catch{
            print("error")
        }
        
    }
    
}
