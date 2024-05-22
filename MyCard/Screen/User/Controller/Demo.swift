//
//  Demo.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-21.
//

import UIKit
import PhotosUI

class Demo: UIViewController  {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var formButton: UIButton!
    
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
            }
  
    @IBAction func genrate(_ sender: UIButton) {
        
        guard let urlString = name.text, !urlString.isEmpty else {
                  showAlert(message: "Please enter a URL")
                  return
              }
              
              // Encode the URL
              let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
              
              // Create the QR code URL
              let qrCodeAPIURLString = "https://api.qrserver.com/v1/create-qr-code/?data=\(encodedURLString)&size=200x200"
              
              // Fetch the QR code image
              fetchQRCode(from: qrCodeAPIURLString)
    }
    
    private func fetchQRCode(from urlString: String) {
            guard let url = URL(string: urlString) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching QR code: \(error)")
                    self.showAlert(message: "Failed to generate QR code")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.showAlert(message: "Failed to generate QR code")
                    return
                }
                
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
            
            task.resume()
        }
        
        private func showAlert(message: String) {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(okayAction)
            present(alertController, animated: true)
        }

}
