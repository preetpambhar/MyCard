//
//  UserTableViewController.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-19.
//

import UIKit
import PhotosUI

class UserTableViewController: UITableViewController, UITextFieldDelegate{

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var occupation: UITextField!
    
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var formButton: UIButton!
    
   /// @IBOutlet weak var qrCodeUrl: UITextField!
    
    private let manager = DatabaseManager()
    private var imageSelectedByUser: Bool = false
    
    var user: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        name.delegate = self
        occupation.delegate = self
        number.delegate = self
        email.delegate = self
     
        configuration()
    }
    //MARK: - UI Configuration
    func configuration(){
        uiconfiguration()
        addGesture()
        userDetailConfiguration()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    func uiconfiguration(){
        navigationItem.title = "Add User"
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }
    
    func addGesture(){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.openGallery))
        profileImageView.addGestureRecognizer(imageTap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case name:
            occupation.becomeFirstResponder()
        case occupation:
            number.becomeFirstResponder()
        case number:
            email.becomeFirstResponder()
        case email:
            // If email is the last field, dismiss the keyboard
            email.resignFirstResponder()
        default:
            break
        }
        return true
    }

    
    func userDetailConfiguration(){
        if let user{
            formButton.setTitle("Update", for: .normal)
            navigationItem.title = "Update User"
            name.text = user.name
            email.text = user.email
            occupation.text = user.occupation
            number.text = user.number
            let imageURL = URL.documentsDirectory.appending(component: user.imageName ?? "").appendingPathExtension("png")
            profileImageView.image = UIImage(contentsOfFile: imageURL.path())
            imageSelectedByUser = true
            
        }else{
            navigationItem.title = "Add User"
            formButton.setTitle("Register", for: .normal)
        }
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
//        guard let userQRCodeUrl = qrCodeUrl.text, !userQRCodeUrl.isEmpty else{
//            openAlert(message: "Please enter your QR Code URL")
//            return
//        }
        
        
        if !imageSelectedByUser  {
            openAlert(message: "Please choose your profile image")
            return
        }
        //print("All Validatioin are done good to go...")
        
        if let user{
            //newUser- Mohan
            //user()
            //update
            let userQRCodeUrl = "hello"
            var newUser = UserModel(userName: userName, userOccupation: userOccupation, userNumber: userNumber, userEmail: userEmail, imageName: user.imageName ?? "", userQRCodeUrl: userQRCodeUrl)
            
            manager.updateUser(user: newUser, userEntity: user)
            saveImageTodocumentDirectory(imageName: newUser.imageName)
        }else{
            //add
            let userQRCodeUrl = "hello"
            let  imageName = UUID().uuidString
            let newUser = UserModel(userName: userName, userOccupation: userOccupation, userNumber: userNumber, userEmail: userEmail, imageName: imageName, userQRCodeUrl: userQRCodeUrl)
            
            saveImageTodocumentDirectory(imageName: imageName)
            manager.adduser(newUser)
        }
        navigationController?.popViewController(animated: true)
        
        name.text = ""
        occupation.text = ""
        number.text = ""
        email.text = ""
        
        //showAlert()
    }
    
    func  saveImageTodocumentDirectory(imageName: String){
        let fileURL = URL.documentsDirectory.appending(component: imageName).appendingPathExtension("png")
        if let data = profileImageView.image?.pngData(){
            do{
                try data.write(to: fileURL)
            }catch{
                print("Saving image to Document Directory error:", error)
            }
        }
    }
    func showAlert(){
        let alertController = UIAlertController(title: "User added", message: "New User added", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
    @objc func openGallery(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    @objc func dismissKeyboard(){
        print("dissmiss keyboard call")
        view.endEditing(true)
    }
    
}

extension UserTableViewController{
    func openAlert(message: String){
        let alertController  = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
}

extension UserTableViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            //BackGround thread use karta he
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let image = image as? UIImage else {return}
                DispatchQueue.main.async{
                    //Main-Where Ui related work happen
                    self.profileImageView.image = image
                    self.imageSelectedByUser = true
                }
            }
        }
    }
}


