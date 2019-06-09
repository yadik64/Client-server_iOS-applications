//
//  UserGroupsController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 14/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit
import RealmSwift

class UserGroupsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let dbManager = DBManager.shared
    var notificationToken: NotificationToken?
    lazy var userGroupsArray: Results<GroupsItem> = { self.dbManager.getDataFromDb()}()
    var localFilterGroupsArray = [GroupsItem]()
    var globalFilterGroupsArray = [GroupsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = userGroupsArray._observe({ [weak self](changes) in
            guard let self = self else { return }
            
            switch changes {
            case .initial(_):
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.reloadRows(at: modifications.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NetworkService.loadingData(for: .groups, completion: { [weak self](response: Result<GroupsModel, Error>) in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                do {
                    try self.dbManager.addData(result.response.items)
                } catch {
                    print(error)
                }
                self.setupSearchController()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    deinit {
        notificationToken?.invalidate()
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
