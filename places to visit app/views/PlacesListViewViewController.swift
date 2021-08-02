//
//  PlacesListViewViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//
import UIKit

class PlacesListViewViewController: UIViewController {
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
        navigationController?.navigationBar.topItem?.title = "Saved places"
        
        placesListViewModel = PlacesListViewModel(wishListStore: wishListStore)
        placesListViewModel.retrieveData()

        placesOfInterestTable = UITableView()
        placesOfInterestTable.translatesAutoresizingMaskIntoConstraints = false
        placesOfInterestTable.dataSource = self
        placesOfInterestTable.delegate = self
        placesOfInterestTable.register(PlaceOfInterestTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
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

extension PlacesListViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            placesListViewModel.deletePlaceOfInterest(at: indexPath.row, from: indexPath.section)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return placesListViewModel.wishListStore.wishLists[section].name
    }
}

extension PlacesListViewViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return placesListViewModel.wishListStore.wishLists.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let wishListForSection = placesListViewModel.wishListStore.wishLists[section]
        return wishListForSection.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = placesOfInterestTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceOfInterestTableViewCell
        let wishListForSection = placesListViewModel.wishListStore.wishLists[indexPath.section]
        let placeOfInterest = wishListForSection.items[indexPath.row]
        cell.configureAnnotationPoint(mapPoint: placeOfInterest)
        return cell
    }
    
    
}

