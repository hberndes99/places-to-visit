//
//  WishListSelectionViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 30/07/2021.
//

import UIKit
import MapKit

class WishListSelectionViewController: UIViewController {

    var mapViewController: MapViewController
    var mapView: MKMapView
    var wishListStore: WishListStore
    var wishListSelectionViewModel: WishListSelectionViewModel!
    
    var wishListSelectionTableView: UITableView!
    
    init(mapViewController: MapViewController, mapView: MKMapView, wishListStore: WishListStore) {
        self.mapViewController = mapViewController
        self.mapView = mapView
        self.wishListStore = wishListStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add to your saved lists"
        
        wishListSelectionViewModel = WishListSelectionViewModel(wishListStore: wishListStore)
        wishListSelectionViewModel.retrieveData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTapped))
        
        wishListSelectionTableView = UITableView()
        wishListSelectionTableView.translatesAutoresizingMaskIntoConstraints = false
        wishListSelectionTableView.delegate = self
        wishListSelectionTableView.dataSource = self
        wishListSelectionTableView.register(WishListTableViewCell.self, forCellReuseIdentifier: Constants.wishListCell)
        
        view.addSubview(wishListSelectionTableView)
        
      
        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        wishListSelectionViewModel.retrieveData()
        wishListSelectionTableView.reloadData()
    }
    
    @objc private func buttonTapped() {
        let newWishListViewController = NewWishListViewController()
        newWishListViewController.delegate = self
        self.present(newWishListViewController, animated: true)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            wishListSelectionTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            wishListSelectionTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            wishListSelectionTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            wishListSelectionTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension WishListSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedListPosition = indexPath.row
        let searchResultsViewController = SearchResultsViewController(mapView: mapView, selectedListPosition: selectedListPosition)
        searchResultsViewController.searchResultsVCMapViewVCDelegate = mapViewController
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
}

extension WishListSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListSelectionViewModel.wishListStore.wishLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wishListSelectionTableView.dequeueReusableCell(withIdentifier: Constants.wishListCell, for: indexPath) as! WishListTableViewCell
        let selectedWishList = wishListSelectionViewModel.wishListStore.wishLists[indexPath.row]
        cell.configureForWishlist(for: selectedWishList)
        return cell
    }
}


extension WishListSelectionViewController: NewWishListVCDelegate {
    func saveNewWishList(name: String, description: String) {
        wishListSelectionViewModel.saveNewWishList(name: name, description: description)
        wishListSelectionTableView.reloadData()
    }
}
