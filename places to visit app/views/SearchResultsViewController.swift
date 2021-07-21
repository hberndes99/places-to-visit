//
//  SearchResultsViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 21/07/2021.
//

import UIKit
import MapKit

protocol SearchResultsViewControllerDelegate {
    func updateTableWithSearch(response: [MKMapItem])
}

class SearchResultsViewController: UIViewController {

    private var searchController: UISearchController!
    private var searchResultsTable: UITableView!
    private var mapView: MKMapView?
    private var searchResultsVCViewModel: SearchResultsVCViewModel!
    
    private var searchResults: [MKMapItem] = []
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search for places to visit"
        searchResultsVCViewModel = SearchResultsVCViewModel()
        searchResultsVCViewModel.delegate = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        //searchController.obscuresBackgroundDuringPresentation = true
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        
        searchResultsTable = UITableView(frame: .zero, style: .plain)
        searchResultsTable.translatesAutoresizingMaskIntoConstraints = false
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        searchResultsTable.register(PlaceOfInterestTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(searchResultsTable)
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            searchResultsTable.topAnchor.constraint(equalTo: view.topAnchor),
            searchResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchResultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        if let searchText = searchText, let mapView = self.mapView {
            searchResultsVCViewModel.performSearch(mapView: mapView, searchText: searchText)
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceOfInterestTableViewCell
        let place = searchResults[indexPath.row]
        cell.configureMKMapItem(mapItem: place)
        return cell
    }

}


extension SearchResultsViewController: SearchResultsViewControllerDelegate {
    func updateTableWithSearch(response: [MKMapItem]) {
        searchResults = response
        searchResultsTable.reloadData()
    }
    
    
}
