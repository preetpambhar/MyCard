//
//  ViewController.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-12.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var occupation: UITextField!
    
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var formButton: UIButton!
    
    @IBOutlet weak var qrCodeUrl: UITextField!
    
    private let manager = DatabaseManager()
    private var imageSelectedByUser: Bool = false
    
    var user: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        configuration()
        
        // Set the delegates
        name.delegate = self
        occupation.delegate = self
        number.delegate = self
        email.delegate = self
        qrCodeUrl.delegate = self
        // Add keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - UI Configuration
    func configuration(){
        uiconfiguration()
        addGesture()
        userDetailConfiguration()
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
            qrCodeUrl.becomeFirstResponder()
        case qrCodeUrl:
            qrCodeUrl.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func uiconfiguration(){
        navigationItem.title = "Add User"
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }
    
    func addGesture(){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.openGallery))
        profileImageView.addGestureRecognizer(imageTap)
    }
    
    func userDetailConfiguration(){
        if let user{
            formButton.setTitle("Update", for: .normal)
            navigationItem.title = "Update User"
            name.text = user.name
            email.text = user.email
            occupation.text = user.occupation
            number.text = user.number
            qrCodeUrl.text = user.qrCodeUrl
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
        guard let userQRCodeUrl = qrCodeUrl.text, !userQRCodeUrl.isEmpty else{
            openAlert(message: "Please enter your QR Code URL")
            return
        }
        if !imageSelectedByUser  {
            openAlert(message: "Please choose your profile image")
            return
        }
        if let email = email.text{
            if !email.validateEmail(){
                openAlert(message: "Please enter valid email")
                return
            }
        }
        if let number = number.text{
            if !number.validatePhone(){
                openAlert(message: "Please enter valid Phone Number")
                return
                }
        }
        if let url = qrCodeUrl.text{
            if !url.validateURL(){
                openAlert(message: "Please enter valid URL Link")
                return
                }
        }

        print("All Validatioin are done good to go...")
        print("\(qrCodeUrl!)")
        
        if let user{
            //newUser- Mohan
            //user()
            //update
            
            var newUser = UserModel(userName: userName, userOccupation: userOccupation, userNumber: userNumber, userEmail: userEmail, imageName: user.imageName ?? "", userQRCodeUrl: userQRCodeUrl)
            
            manager.updateUser(user: newUser, userEntity: user)
            saveImageTodocumentDirectory(imageName: newUser.imageName)
        }else{
            //add
            
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
        qrCodeUrl.text = ""
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
    
    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset.bottom = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
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

extension ViewController: PHPickerViewControllerDelegate{
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
    
