//
//  AllGroupsController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 14/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

protocol AllGroupsControllerDelegate {
    func addToTable(group: Group)
}

class AllGroupsController: UIViewController, GroupPageControllerDelegate {

    var delegate: AllGroupsControllerDelegate!
    
    var viewGroupArray: [Group] {
        get {
            let array = Group.allGroupsArray.filter { (value) -> Bool in
                !Group.userGroupsArray.contains(value)
            }
            return array
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ViewPageGroupSegue" else { return }
        
        let destinationVC = segue.destination as! GroupPageController
        destinationVC.delegate = self
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        destinationVC.group = viewGroupArray[indexPath.row]
    }
    
    func addGroup(group: Group) {
        Group.userGroupsArray.append(group)
        self.tableView.reloadData()
    }
    
    func deleteGroup(group: Group) {}
    
}

extension AllGroupsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewGroupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
        
        cell.iconGroup.image = UIImage(named: viewGroupArray[indexPath.row].nameIcon)
        cell.nameGroup.text = viewGroupArray[indexPath.row].nameGroup
        
        return cell
    }
}

extension AllGroupsController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionAdd = UIAlertAction(title: "Вступить в группу", style: .default) { (_) in
            let group = self.viewGroupArray[indexPath.row]
            self.delegate.addToTable(group: group)
            self.navigationController?.popViewController(animated: true)
            
        }
        let actionBrowse = UIAlertAction(title: "Перейти в группу", style: .default) { (_) in
            self.performSegue(withIdentifier: "ViewPageGroupSegue", sender: self)
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(actionAdd)
        alert.addAction(actionBrowse)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }

}
