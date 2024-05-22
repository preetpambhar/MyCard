//
//  CardViewController.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-17.
//

import Foundation
import UIKit
import PhotosUI

class CardViewController: UIViewController{
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var occupationLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UIButton!
    
    @IBOutlet weak var emailLabel: UIButton!
   
    @IBOutlet weak var QRCode: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userDetailConfiguration()
        uiConfiguration()
    }
    //private var users: [UserData] = []
    var user: UserData?
    
    func userDetailConfiguration(){
        if let user{
            //navigationItem.title = "Card"
            nameLabel.text = user.name
            emailLabel.setTitle(user.email, for: .normal)
            occupationLabel.text = user.occupation
            phoneLabel.setTitle(user.number, for: .normal)
            let imageURL = URL.documentsDirectory.appending(component: user.imageName ?? "").appendingPathExtension("png")
            profileImage.image = UIImage(contentsOfFile: imageURL.path())
            qrgenrator()
            //imageSelectedByUser = true
            print("\(user.name!)")
        }else{
            navigationItem.title = "No User"
           // formButton.setTitle("Register", for: .normal)
            print("fail")
        }
    }
    
    func uiConfiguration(){
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
    }
}


extension CardViewController{
      func qrgenrator(){
        
        
        guard let urlString = user?.qrCodeUrl, !urlString.isEmpty else {
                  showAlert(message: "Please enter a URL")
                  return
              }
              let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
              
              // Create the QR code URL
              let qrCodeAPIURLString = "https://api.qrserver.com/v1/create-qr-code/?data=\(urlString)&size=200x200"
              
              // Fetch the QR code image
              fetchQRCode(from: qrCodeAPIURLString)
        
         func fetchQRCode(from urlString: String) {
                guard let url = URL(string: urlString) else { return }
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error fetching QR code: \(error)")
                       // self.showAlert(message: "Failed to generate QR code")
                        showAlert(message: "Failed to generate QR code")
                        return
                    }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        showAlert(message: "Failed to generate QR code")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.QRCode.image = image
                    }
                }
                
                task.resume()
            }
         func showAlert(message: String) {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(okayAction)
            present(alertController, animated: true)
        }
    }
}

