//
//  DatabaseManager.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-13.
//

import Foundation
import UIKit

struct UserModel{
    let userName:String
    let userOccupation: String
    let userNumber: String
    let userEmail: String
}

class DatabaseManager{
    func adduser(_ user: UserModel){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
        let userEntity = UserData(context: context)
        userEntity.name = user.userName
        userEntity.occupation = user.userOccupation
        userEntity.number = user.userNumber
        userEntity.email = user.userEmail
        
        
        //Database : to view in database we have to save this data
        do{
            try context.save()
            print("Successful")//Most important
        }catch{
            print("User saving error, \(error)")
        }
    }
}
