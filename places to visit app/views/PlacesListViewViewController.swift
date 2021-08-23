//
//  PlacesListViewViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 23/08/2021.
//

import UIKit

class PlacesListViewViewController: UIViewController {
    private var detailWishListViewModel: DetailWishListViewModel!
    private var wishListTitle: UILabel!
    private var wishListTableView: UITableView!
    
    var wishListIndex: Int
    
    init(wishListIndex: Int) {
        self.wishListIndex = wishListIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailWishListViewModel = DetailWishListViewModel()
        detailWishListViewModel.retrieveData()
        
        view.backgroundColor = .white
        
        wishListTitle = UILabel()
        wishListTitle.translatesAutoresizingMaskIntoConstraints = false
        wishListTitle.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        
        wishListTableView = UITableView()
        wishListTableView.translatesAutoresizingMaskIntoConstraints = false
        wishListTableView.dataSource = self
        wishListTableView.delegate = self
        wishListTableView.register(PlaceOfInterestTableViewCell.self, forCellReuseIdentifier: "places cell")
        
        view.addSubview(wishListTitle)
        view.addSubview(wishListTableView)
        setTitleText()
        setUpConstraints()
    }
    
    private func setTitleText() {
        let wishListToDisplay = detailWishListViewModel.wishListStore.wishLists[wishListIndex]
        wishListTitle.text = wishListToDisplay.name
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            wishListTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            wishListTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wishListTitle.heightAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            wishListTableView.topAnchor.constraint(equalTo: wishListTitle.bottomAnchor),
            wishListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wishListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    



}


extension PlacesListViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
}

extension PlacesListViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let wishListToDisplay = detailWishListViewModel.wishListStore.wishLists[wishListIndex]
        return wishListToDisplay.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wishListTableView.dequeueReusableCell(withIdentifier: "places cell", for: indexPath) as! PlaceOfInterestTableViewCell
        let wishListToDisplay = detailWishListViewModel.wishListStore.wishLists[wishListIndex]
        let placeOfInterest = wishListToDisplay.items[indexPath.row]
        cell.configureAnnotationPoint(mapPoint: placeOfInterest)
        return cell
    }
    
    
}
