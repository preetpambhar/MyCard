//
//  DatabaseManager.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-13.
//

import UIKit
import CoreData


private var context: NSManagedObjectContext{
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

class DatabaseManager{
    func adduser(_ user: UserModel){
        let userEntity = UserData(context: context) //User create karte the
        addUpdateUser(userEntity: userEntity, user: user)
    }
    func  updateUser(user: UserModel, userEntity: UserData){
        addUpdateUser(userEntity: userEntity, user: user)
        //Database : to view in database we have to save this data
    }
    
    func addUpdateUser(userEntity: UserData, user: UserModel){
        userEntity.name = user.userName
        userEntity.occupation = user.userOccupation
        userEntity.number = user.userNumber
        userEntity.email = user.userEmail
        userEntity.imageName = user.imageName
        userEntity.qrCodeUrl = user.userQRCodeUrl
        saveContext()
    }
    func fetchUser() -> [UserData] {
        var users: [UserData] = []
        do{
            users = try context.fetch(UserData.fetchRequest())
        }catch{
            print("Fetch user error", error)
        }
        
        return users
    }
    
    func saveContext(){
        do{
            try context.save()
            print("Successful")//Most important
        }catch{
            print("User saving error, \(error)")
        }
    }
    
    
    func deleteUser(userEntity: UserData){
        let imageURL = URL.documentsDirectory.appending(component: userEntity.imageName ?? "").appendingPathExtension("png")
        do{
            try FileManager.default.removeItem(at: imageURL)
        }catch{
            print("Remove image from DD", error)
        }
        context.delete(userEntity)
        saveContext()
    }
}
