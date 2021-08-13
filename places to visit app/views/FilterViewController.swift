//
//  FilterViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 11/08/2021.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func applyFilters(filterList: [String])
}


class FilterViewController: UIViewController {
    private var titleFilterLabel: UILabel!
    private var filterCollectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var distanceHeaderLabel: UILabel!
    private var listHeaderLabel: UILabel!
    private var filterButton: UIButton!
    
    private var filterViewModel: FilterViewModel!
    private var wishListStore: WishListStore
    private var listOfFilterStrings: [String] = [String]()
    
    weak var filterViewControllerDelegate: FilterViewControllerDelegate?
    
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
        filterViewModel.retrieveData()
        
        titleFilterLabel = UILabel()
        
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        //layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: 20, height: 20)
        layout.estimatedItemSize = .zero
        //layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        //layout.sectionHeadersPinToVisibleBounds = true
        
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(FilterWishListCollectionViewCell.self, forCellWithReuseIdentifier: FilterWishListCollectionViewCell.identifier)
        filterCollectionView.register(FilterWishListCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.filterWishListHeader)
        filterCollectionView.backgroundColor = .white
        
        distanceHeaderLabel = UILabel()
        distanceHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceHeaderLabel.text = "Filter by distance..."
        distanceHeaderLabel.font = .boldSystemFont(ofSize: 25)
        
        listHeaderLabel = UILabel()
        listHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        listHeaderLabel.text = "Filter by list..."
        listHeaderLabel.font = .boldSystemFont(ofSize: 25)
        
        filterButton = UIButton(frame: .zero)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle("Apply filters", for: .normal)
        filterButton.setTitleColor(.systemGreen, for: .normal)
        filterButton.addTarget(self, action: #selector(applyFiltersTapped), for: .touchUpInside)
        
        view.addSubview(filterCollectionView)
        view.addSubview(listHeaderLabel)
        view.addSubview(distanceHeaderLabel)
        view.addSubview(filterButton)
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            filterCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            filterCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            listHeaderLabel.bottomAnchor.constraint(equalTo: filterCollectionView.topAnchor, constant: -20),
            listHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            listHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            listHeaderLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            distanceHeaderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            distanceHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            distanceHeaderLabel.heightAnchor.constraint(equalToConstant: 40),
            distanceHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25)
        ])
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 20),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 20),
            filterButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func applyFiltersTapped() {
        filterViewControllerDelegate?.applyFilters(filterList: listOfFilterStrings)
    }

}


extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterViewModel.wishListStore.wishLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterWishListCollectionViewCell.identifier, for: indexPath) as! FilterWishListCollectionViewCell
        let wishListForCell = filterViewModel.wishListStore.wishLists[indexPath.item]
        myCell.configureCVCell(for: wishListForCell)
        return myCell
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
        
        let cellHeight = adjustedCVHeight / 2
        let cellWidth = (adjustedCVWidth / 2) * 0.9
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("called")
        let header = filterCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.filterWishListHeader, for: indexPath) as! FilterWishListCollectionReusableView
       
        return header
    }
 */
}

extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // darken background colour
        let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterWishListCollectionViewCell
        let selectedWishList = filterViewModel.wishListStore.wishLists[indexPath.item]
        cell.cellIsSelected = !cell.cellIsSelected
        if cell.cellIsSelected {
            cell.configureSelected()
            listOfFilterStrings.append(selectedWishList.name)
        } else {
            cell.configureDeselected()
            if let index = listOfFilterStrings.firstIndex(of: selectedWishList.name) {
                listOfFilterStrings.remove(at: index)
            }
        }
        
    }
}
