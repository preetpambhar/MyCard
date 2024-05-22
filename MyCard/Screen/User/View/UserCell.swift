//
//  UserCell.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-14.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user: UserData?{
        didSet{ //property observer
            userConfiguration()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   func userConfiguration(){
       guard let user else{
           return
       }
       
       name.text = (user.name ?? " ") + " " + (user.occupation ?? "") //title
       emailLabel.text = "Email: \(user.email ?? "")" //subtitle
       
       let imageURL = URL.documentsDirectory.appending(component: user.imageName ?? "").appendingPathExtension("png")
       profileImageView.image = UIImage(contentsOfFile: imageURL.path())
    }
}
