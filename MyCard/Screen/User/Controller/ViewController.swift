//
//  ViewController.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var occupation: UITextField!
    
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    private let manager = DatabaseManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submit(_ sender: UIButton) {
        guard let userName = name.text, !userName.isEmpty else{
            openAlert(message: "Please enter your first name")
            return
        }
        guard let userOccupation = occupation.text, !userOccupation.isEmpty else{
            openAlert(message: "Please enter your occupation")
            return
        } 
        
        guard let userNumber = number.text, !userNumber.isEmpty else{
            openAlert(message: "Please enter your user number")
            return
        } 
        
        guard let userEmail = email.text, !userEmail.isEmpty else{
            openAlert(message: "Please enter your user email")
            return
        }
        let user = UserModel(userName: userName, userOccupation: userOccupation, userNumber: userNumber, userEmail: userEmail)
        manager.adduser(user)
    }
}

extension ViewController{
    func openAlert(message: String){
        let alertController  = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
}
