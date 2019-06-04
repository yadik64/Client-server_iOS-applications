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
    var globalFilterGroupsArray = [GroupsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            NetworkService.loadingData(for: .groups, completion: { (response: Result<GroupsModel, Error>) in
                switch response {
                case .success(let result):
                    self.userGroupsArray = result.response.items
                    self.tableView.reloadData()
                    self.setupSearchController()
                case .failure(let error):
                    print(error)
                }
                
            })
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
        guard searchText != "" else { return }
        
        localFilterGroupsArray = userGroupsArray.filter{
            return $0.name.lowercased().contains(searchText.lowercased())
        }
        NetworkService.groupSearch(by: searchText) { (response) in
            switch response {
            case .success(let result):
                    self.globalFilterGroupsArray = result.response.items
                    self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
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
        var group = GroupsItem()
        
        switch indexPath.section {
        case 0:
            group = isFiltered() ? localFilterGroupsArray[indexPath.row] : userGroupsArray[indexPath.row]
        default:
            group = globalFilterGroupsArray[indexPath.row]
        }
        
        cell.configure(with: group)
        
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
