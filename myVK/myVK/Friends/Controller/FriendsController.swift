//
//  FriendsController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 02/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class FriendsController: UIViewController {

//TODO: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var charControl: CharControl!
    
    //TODO: - Propertis
    
    let searchController = UISearchController(searchResultsController: nil)
    let cellIdentifire = "FriendsViewCell"
    let segueIdentifire = "FotoAlbomSegue"
    let numberOfSectionImportantFrieds = 1
    
    var filterFriendsArray = [FriendsItem]()
    
    let friendsModelController = FriendsModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendsDataReceivedNotifications = Notification.Name(rawValue: "friendsDataReceived")
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived), name: friendsDataReceivedNotifications, object: nil)
        
        setupSearchController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dataReceived() {
        charControl.sectionName = friendsModelController.sectionName
        charControl.setupStackView()
        
        tableView.reloadData()
    }
    
    @IBAction func pressCharControl(_ sender: CharControl) {
        guard let char = sender.selectedChar else { return }
        print(char)
        guard let sectionIndex = friendsModelController.sectionName.firstIndex(of: char.uppercased()) else { return }
        let indexPath = IndexPath(row: 0, section: sectionIndex + 1)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    
    //TODO: - SearchController Methods
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск друга"
        definesPresentationContext = true
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltered() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func filterContentForSearchText(searchText: String) {
        
        let allFriends = friendsModelController.importantFriedsArray + friendsModelController.friendsAllButImportant
        filterFriendsArray = allFriends.filter{
            return $0.lastName.lowercased().contains(searchText.lowercased())
        }
        
        charControl.isHidden = isFiltered()
        tableView.reloadData()
    }
    
    //TODO: - Data transmission Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == segueIdentifire else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let friendAllFotoController = segue.destination as! FriendAllFotoController
        
        if isFiltered() {
            friendAllFotoController.userId = filterFriendsArray[indexPath.row].id
        } else {
            switch indexPath.section {
            case 0:
                friendAllFotoController.userId = friendsModelController.importantFriedsArray[indexPath.row].id
            default:
                let key = friendsModelController.sectionName[indexPath.section - 1]
                friendAllFotoController.userId = friendsModelController.friendsDictionary[key]?[indexPath.row].id
            }
        }
        
    }
    
}

//TODO: - Extensions

extension FriendsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltered() {
            return 1
        } else {
            return friendsModelController.sectionName.count + numberOfSectionImportantFrieds
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltered() {
            return filterFriendsArray.count
        } else {
            switch section {
            case 0:
                return friendsModelController.importantFriedsArray.count
            default:
                guard let numberOfRows = friendsModelController.friendsDictionary[friendsModelController.sectionName[section - numberOfSectionImportantFrieds]]?.count else { break }
                return numberOfRows
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! FriendsViewCell
        
        var urlString = ""
        var name = ""
        
        if isFiltered() {
            let friend = filterFriendsArray[indexPath.row]
            
            urlString = friend.photo100 ?? ""
            name = friend.firstName + " " + friend.lastName
        } else {
            switch indexPath.section {
            case 0:
                let friend = friendsModelController.importantFriedsArray[indexPath.row]
                
                urlString = friend.photo100 ?? ""
                name = friend.firstName  + " " + friend.lastName
                
            default:
                let key = friendsModelController.sectionName[indexPath.section - numberOfSectionImportantFrieds]
                guard let friend = friendsModelController.friendsDictionary[key]?[indexPath.row] else { break }
                
                urlString = friend.photo100 ?? ""
                name = friend.firstName + " " + friend.lastName
            }
        }
        
        cell.avatarView.downloadedFrom(link: urlString)
        cell.nameFriendLabel.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFiltered() {
            return "Найденно:"
        } else {
            switch section {
            case 0:
                return "Важные друзья"
            default:
                return friendsModelController.sectionName[section - numberOfSectionImportantFrieds]
            }
        }
    }
    
}

extension FriendsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
