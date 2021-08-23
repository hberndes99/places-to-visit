//
//  PlacesListViewViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//
import UIKit

class WishListViewTableViewController: UIViewController {
    private var wishListStore: WishListStore
    private var placesListViewModel: PlacesListViewModel!
    private var placesOfInterestTable: UITableView!
    
    init(wishListStore: WishListStore) {
        self.wishListStore = wishListStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Your saved lists"
        
        placesListViewModel = PlacesListViewModel(wishListStore: wishListStore)
        placesListViewModel.retrieveData()

        placesOfInterestTable = UITableView()
        placesOfInterestTable.translatesAutoresizingMaskIntoConstraints = false
        placesOfInterestTable.dataSource = self
        placesOfInterestTable.delegate = self
        placesOfInterestTable.register(WishListTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        view.addSubview(placesOfInterestTable)
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        placesListViewModel.retrieveData()
        placesOfInterestTable.reloadData()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            placesOfInterestTable.topAnchor.constraint(equalTo: view.topAnchor),
            placesOfInterestTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placesOfInterestTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placesOfInterestTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension WishListViewTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let placesListViewViewController = PlacesListViewViewController(wishListIndex: selectedIndex)
        navigationController?.pushViewController(placesListViewViewController, animated: true)
    }
}

extension WishListViewTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesListViewModel.wishListStore.wishLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = placesOfInterestTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WishListTableViewCell
        let wishList = placesListViewModel.wishListStore.wishLists[indexPath.row]
        cell.configureForWishlist(for: wishList)
        return cell
    }
}
