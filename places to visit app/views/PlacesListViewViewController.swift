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
        
        let optionsButton = UIButton()
        optionsButton.setTitle("Options", for: .normal)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        optionsButton.setTitleColor(.systemBlue, for: .normal)
        optionsButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: optionsButton)
        
        view.addSubview(wishListTitle)
        view.addSubview(wishListTableView)
        setTitleText()
        setUpConstraints()
    }
    
    private func setTitleText() {
        let wishListToDisplay = detailWishListViewModel.wishListStore.wishLists[wishListIndex]
        wishListTitle.text = wishListToDisplay.name
    }
    
    @objc func menuTapped() {
        let optionMenu = UIAlertController(title: nil, message: .none, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete \(detailWishListViewModel.wishListStore.wishLists[wishListIndex].name)", style: .default) { [weak self] action in
            self?.detailWishListViewModel.deleteWishList(at: self!.wishListIndex)
            self?.navigationController?.popViewController(animated: true)
        }
        let saveAction = UIAlertAction(title: "Share wish list", style: .default) { [weak self] action in
            let itemToShare = self?.detailWishListViewModel.wishListStore.wishLists[self!.wishListIndex].name
            let shareController = UIActivityViewController(activityItems: [itemToShare], applicationActivities: nil)
            self?.present(shareController, animated: true)
        }
   
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
 
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func setUpConstraints() {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            detailWishListViewModel.deletePlaceOfInterest(at: indexPath.row, from: wishListIndex)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
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
