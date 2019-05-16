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
    var sectionName = [String]()
    var friendsDictionary = [String: [FriendsModel]]()
    
// FriendsController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        sortFriendsAlphabetically()
    }
    
    @IBAction func pressCharControl(_ sender: CharControl) {
        guard let char = sender.selectedChar else { return }
        guard let sectionIndex = FriendsModel.sectionName.firstIndex(of: char.uppercased()) else { return }
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func sortFriendsAlphabetically() {
        
        for name in FriendsModel.userFriendsArray {
            let key = name.friendStartChar
            if friendsDictionary[key] == nil {
                sectionName.append(key)
                friendsDictionary[key] = [name]
            } else {
                friendsDictionary[key]?.append(name)
            }
        }
        sectionName.sort()
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
        FriendsModel.filterFriendsArray = FriendsModel.userFriendsArray.filter{ $0.nameFriend.lowercased().contains(searchText.lowercased())}
        
        charControl.isHidden = true
        tableView.reloadData()
    }
    
//TODO: - Data transmission Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == segueIdentifire else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let friendAllFotoController = segue.destination as! FriendAllFotoController
        let key = sectionName[indexPath.section]
        guard let friends = friendsDictionary[key] else { return }
        let friendData = isFiltered() ?
            FriendsModel.filterFriendsArray[indexPath.row] :
            friends[indexPath.row]
        
        friendAllFotoController.friendData = friendData
    }

}

//TODO: - Extensions

extension FriendsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard !isFiltered() else { return 1 }
        return sectionName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !isFiltered() else { return FriendsModel.filterFriendsArray.count }
        
        let key = sectionName[section]
        guard let returnData = friendsDictionary[key] else { return 0 }
        return returnData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! FriendsViewCell
        
        let key = sectionName[indexPath.section]
        guard let friend = friendsDictionary[key] else { return cell }
        
        let avatar = isFiltered() ?
            UIImage(named: FriendsModel.filterFriendsArray[indexPath.row].fotoFriend) :
            UIImage(named: friend[indexPath.row].fotoFriend)
        let name = isFiltered() ?
            FriendsModel.filterFriendsArray[indexPath.row].nameFriend :
            friend[indexPath.row].nameFriend
        
        cell.avatarView.image = avatar
        cell.nameFriendLabel.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isFiltered() else { return "Найденно:"}
        return sectionName[section]
    }
    
}

extension FriendsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
