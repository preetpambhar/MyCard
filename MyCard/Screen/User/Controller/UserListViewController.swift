//
//  UserListViewController.swift
//  MyCard
//
//  Created by Preet Pambhar on 2024-05-13.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    
    private var users: [UserData] = []
    private let manager = DatabaseManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        // Do any additional setup after loading the view.
        //userTableView.rowHeight = 90
    }
    
    override func viewWillAppear(_ animated: Bool) {
        users = manager.fetchUser()
        userTableView.reloadData()
    }
    
    @IBAction func addUserButtonTapped(_ sender: UIBarButtonItem) {
        addUpdateUserNavigation()
    }
    
    func addUpdateUserNavigation(user: UserData? = nil){
        guard let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else{
            print("fail")
            return
        }
        registerVC.user = user
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func viewCard(user: UserData? = nil){
        guard let cardVC = self.storyboard?.instantiateViewController(withIdentifier: "CardViewController") as? CardViewController else {
            print("Fail to load card controller")
            return
        }
        cardVC.user = user
        navigationController?.pushViewController(cardVC, animated: true)
    }
    
}

extension UserListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else{
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.user = user
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewCard(user: self.users[indexPath.row])
    }
}


extension UserListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteUser(userEntity: self.users[indexPath.row])
            self.users.remove(at: indexPath.row)
            self.userTableView.reloadData()
        }
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.addUpdateUserNavigation(user: self.users[indexPath.row])
        }
        update.backgroundColor = .systemIndigo
        
        let card = UIContextualAction(style: .normal, title: "View Card") { _, _, _ in
            self.viewCard(user: self.users[indexPath.row])
        }
        card.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [delete, update, card])
    }
}
