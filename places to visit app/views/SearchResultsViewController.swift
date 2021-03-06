//
//  SearchResultsViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 21/07/2021.
//

import UIKit
import MapKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func updateTableWithSearch()
}

protocol SearchResultsVCMapViewVCDelegate: AnyObject {
    func savePlaceOfInterest(placeOfInterest: MKMapItem, wishListPositionIndex: Int)
}

class SearchResultsViewController: UIViewController {

    private var searchController: UISearchController!
    private var searchResultsTable: UITableView!
    private var mapView: MKMapView?
    private var selectedListPosition: Int
    private var searchResultsVCViewModel: SearchResultsVCViewModel!
    weak var searchResultsVCMapViewVCDelegate: SearchResultsVCMapViewVCDelegate?
    
    init(mapView: MKMapView, selectedListPosition: Int) {
        self.mapView = mapView
        self.selectedListPosition = selectedListPosition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search for places to visit"
        view.accessibilityIdentifier = "search for place of interest screen"
        searchResultsVCViewModel = SearchResultsVCViewModel(searchNetworkManager: SearchNetworkManager())
        searchResultsVCViewModel.delegate = self
        self.definesPresentationContext = true
        searchResultsTable = UITableView(frame: .zero, style: .plain)
        searchController = UISearchController(searchResultsController: nil)
        
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        
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
        if let searchText = searchText, searchText.count > 2, let mapView = self.mapView {
            searchResultsVCViewModel.performSearch(mapView: mapView, searchText: searchText)
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = searchResultsVCViewModel.searchResults[indexPath.row]
        searchResultsVCMapViewVCDelegate?.savePlaceOfInterest(placeOfInterest: selectedPlace, wishListPositionIndex: self.selectedListPosition)
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsVCViewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceOfInterestTableViewCell
        let place = searchResultsVCViewModel.searchResults[indexPath.row]
        cell.configureMKMapItem(mapItem: place)
        cell.selectionStyle = .none
        return cell
    }

}


extension SearchResultsViewController: SearchResultsViewControllerDelegate {
    func updateTableWithSearch() {
        searchResultsTable.reloadData()
    }
}
