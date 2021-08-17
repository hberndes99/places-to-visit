//
//  FilterViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 11/08/2021.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func applyFilters(filterList: [String], distance: Int?)
}


class FilterViewController: UIViewController {
    private var titleFilterLabel: UILabel!
    private var filterCollectionView: UICollectionView!
    private var distanceCollectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var distanceCVLayout: UICollectionViewFlowLayout!
    private var distanceHeaderLabel: UILabel!
    private var listHeaderLabel: UILabel!
    private var filterButton: UIButton!
    
    private var filterViewModel: FilterViewModel!
    private var wishListStore: WishListStore
    
    weak var filterViewControllerDelegate: FilterViewControllerDelegate?
    
    private let distanceArray = [1, 3, 5, 10, 20]
    
    init (wishListStore: WishListStore) {
        self.wishListStore = wishListStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        filterViewModel = FilterViewModel(wishListStore: wishListStore)
        filterViewModel.filterViewControllerDelegate = filterViewControllerDelegate
        filterViewModel.retrieveData()
        
        titleFilterLabel = UILabel()
        
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        //layout.minimumLineSpacing = 30
        layout.estimatedItemSize = .zero
        
        distanceCVLayout = UICollectionViewFlowLayout()
        distanceCVLayout.scrollDirection = .horizontal
        distanceCVLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        distanceCVLayout.estimatedItemSize = .zero
        
        listHeaderLabel = UILabel()
        listHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        listHeaderLabel.text = "Filter by list..."
        listHeaderLabel.font = .boldSystemFont(ofSize: 25)
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(FilterWishListCollectionViewCell.self, forCellWithReuseIdentifier: FilterWishListCollectionViewCell.identifier)
        filterCollectionView.backgroundColor = .white
        
        distanceHeaderLabel = UILabel()
        distanceHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceHeaderLabel.text = "Filter by distance..."
        distanceHeaderLabel.font = .boldSystemFont(ofSize: 25)
        
        distanceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: distanceCVLayout)
        distanceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        distanceCollectionView.dataSource = self
        distanceCollectionView.delegate = self
        distanceCollectionView.register(FilterWishListCollectionViewCell.self, forCellWithReuseIdentifier: FilterWishListCollectionViewCell.identifier)
        distanceCollectionView.backgroundColor = .white
        
        filterButton = UIButton(frame: .zero)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle("Apply filters", for: .normal)
        filterButton.setTitleColor(.systemGreen, for: .normal)
        filterButton.addTarget(self, action: #selector(applyFiltersTapped), for: .touchUpInside)
        
        view.addSubview(filterCollectionView)
        view.addSubview(listHeaderLabel)
        view.addSubview(distanceHeaderLabel)
        view.addSubview(distanceCollectionView)
        view.addSubview(filterButton)
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            distanceHeaderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            distanceHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            distanceHeaderLabel.heightAnchor.constraint(equalToConstant: 40),
            distanceHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        NSLayoutConstraint.activate([
            distanceCollectionView.topAnchor.constraint(equalTo: distanceHeaderLabel.bottomAnchor, constant: 20),
            distanceCollectionView.bottomAnchor.constraint(equalTo: listHeaderLabel.topAnchor, constant: -20),
            distanceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            distanceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            listHeaderLabel.bottomAnchor.constraint(equalTo: filterCollectionView.topAnchor, constant: -20),
            listHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            listHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            listHeaderLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            filterCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            filterCollectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -10),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            //filterButton.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 20),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 20),
            filterButton.widthAnchor.constraint(equalToConstant: 100),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func applyFiltersTapped() {
        filterViewModel.applyFilters()
        self.dismiss(animated: true)
    }
}


extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.filterCollectionView {
            print("number of items in section for filter wish list")
            return filterViewModel.wishListStore.wishLists.count
        }
        else {
            return distanceArray.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.filterCollectionView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterWishListCollectionViewCell.identifier, for: indexPath) as! FilterWishListCollectionViewCell
            let wishListForCell = filterViewModel.wishListStore.wishLists[indexPath.item]
            myCell.configureCVCell(for: wishListForCell)
            return myCell
        }
        else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterWishListCollectionViewCell.identifier, for: indexPath) as! FilterWishListCollectionViewCell
            // get distance for cell
            let distance = distanceArray[indexPath.item]
            myCell.configureDistanceCVCell(for: distance)
            return myCell
        }
    }
    
    
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewHeight = collectionView.bounds.height
        let collectionViewWidth = collectionView.bounds.width
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let lineSpacing = flowLayout.minimumLineSpacing
        let interItemSpacing = flowLayout.minimumInteritemSpacing
        let heightInstepTotal = flowLayout.sectionInset.bottom + flowLayout.sectionInset.top
        let edgeInstepTotal = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let headerHeight = flowLayout.headerReferenceSize.height
        
        let adjustedCVHeight = collectionViewHeight - lineSpacing - heightInstepTotal - headerHeight
        let adjustedCVWidth = collectionViewWidth - interItemSpacing - edgeInstepTotal
        
        if collectionView == self.filterCollectionView {
            print("size for filter collection view called")
            let cellHeight = adjustedCVHeight / 2
            let cellWidth = (adjustedCVWidth / 2) * 0.9
            return CGSize(width: cellWidth, height: cellHeight)
        }
        else {
            let cellHeight = adjustedCVHeight
            let cellWidth = (adjustedCVWidth / 4) * 0.9
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
    }
}

extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterWishListCollectionViewCell
            let selectedWishList = filterViewModel.wishListStore.wishLists[indexPath.item]
            cell.cellIsSelected = !cell.cellIsSelected
            if cell.cellIsSelected {
                cell.configureSelected()
                filterViewModel.addToFilterQueries(wishListName: selectedWishList.name)
            } else {
                cell.configureDeselected()
                filterViewModel.removeFromFilterQueries(wishListName: selectedWishList.name)
            }
        } else {
            let cell = distanceCollectionView.cellForItem(at: indexPath) as! FilterWishListCollectionViewCell
            let selectedDistance = distanceArray[indexPath.item]
            cell.cellIsSelected = !cell.cellIsSelected
            if cell.cellIsSelected {
                cell.configureDistanceCVCellSelected()
                filterViewModel.filterByDistance(of: selectedDistance)
            } else {
                cell.configureDistanceCVCellDeselected()
            }
        }
    }
}
