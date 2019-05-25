//
//  UserGroupsController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 14/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class UserGroupsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var userGroupsArray = [GroupsItem]()
    
    var localFilterGroupsArray = [GroupsItem]()
    var globalFilterGroupsArray = [SearchItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            GroupsService.loadingGroupData { (array) in
                self.userGroupsArray = array
                self.tableView.reloadData()
                self.setupSearchController()
            }
        }
        
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

        
        localFilterGroupsArray = userGroupsArray.filter{
            guard let name = $0.name else { return false }
            return name.lowercased().contains(searchText.lowercased())
        }
        NetworkService.groupSearch(by: searchText) { (resultArray) in
            self.globalFilterGroupsArray = resultArray
        }
        tableView.reloadData()
    }
    
    
}

extension UserGroupsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = isFiltered() ? 2 : 1
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            let numberOfRows = isFiltered() ? localFilterGroupsArray.count : userGroupsArray.count
            return numberOfRows
        default:
            let numberOfRows = isFiltered() ? globalFilterGroupsArray.count : 0
            return numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupsCell", for: indexPath) as! UserGroupsCell
        
        switch indexPath.section {
        case 0:
            let url = isFiltered() ? localFilterGroupsArray[indexPath.row].photo100 : userGroupsArray[indexPath.row].photo100
            let name = isFiltered() ? localFilterGroupsArray[indexPath.row].name : userGroupsArray[indexPath.row].name
            
            cell.iconGroup.downloadedFrom(link: url)
            cell.nameGroup.text = name
        default:
            let url = globalFilterGroupsArray[indexPath.row].photo100 
            let name = globalFilterGroupsArray[indexPath.row].name
            
            cell.iconGroup.downloadedFrom(link: url!)
            cell.nameGroup.text = name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        default:
            return "Глобальный поиск:"
        }
    }
}

extension UserGroupsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
