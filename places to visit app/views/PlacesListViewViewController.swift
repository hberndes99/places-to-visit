//
//  PlacesListViewViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//

import UIKit

class PlacesListViewViewController: UIViewController {
    private var mapAnnotationsStore: MapAnnotationsStore
    private var placesListViewModel: PlacesListViewModel!
    private var placesOfInterestTable: UITableView!
    
    init(mapAnnotationsStore: MapAnnotationsStore) {
        self.mapAnnotationsStore = mapAnnotationsStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Saved places"
        
        placesListViewModel = PlacesListViewModel(mapAnnotationsStore: mapAnnotationsStore)
        mapAnnotationsStore = placesListViewModel.retrieveData()
        for point in mapAnnotationsStore.mapAnnotationPoints {
            print(point.title)
        }
        
        placesOfInterestTable = UITableView()
        placesOfInterestTable.translatesAutoresizingMaskIntoConstraints = false
        placesOfInterestTable.dataSource = self
        placesOfInterestTable.delegate = self
        placesOfInterestTable.register(PlaceOfInterestTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(placesOfInterestTable)
        addConstraints()
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
}

extension PlacesListViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapAnnotationsStore.mapAnnotationPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = placesOfInterestTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceOfInterestTableViewCell
        let placeOfInterest = mapAnnotationsStore.mapAnnotationPoints[indexPath.row]
        cell.configureAnnotationPoint(mapPoint: placeOfInterest)
        return cell
    }
    
    
}
