//
//  RootTabViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 29/07/2021.
//

import UIKit

class RootTabViewController: UITabBarController {
    private var wishListStore: WishListStore
    private var mapViewController: MapViewController!
    private var placesListViewViewController: PlacesListViewViewController!
    
    init(wishListStore: WishListStore) {
        self.wishListStore = wishListStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapTabBarItem = UITabBarItem()
        mapTabBarItem.title = "view on map"
        
        let listTabBarItem = UITabBarItem()
        listTabBarItem.title = "view as a list"
        
        if #available(iOS 13, *) {
            listTabBarItem.image = UIImage(systemName: "list.bullet")
            mapTabBarItem.image = UIImage(systemName: "map")
        }
        
        mapViewController = MapViewController(wishListStore: wishListStore)
        placesListViewViewController = PlacesListViewViewController(wishListStore: wishListStore)
     
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        mapNavigationController.tabBarItem = mapTabBarItem
        let listNavigationController = UINavigationController(rootViewController: placesListViewViewController)
        listNavigationController.tabBarItem = listTabBarItem
        self.viewControllers = [mapNavigationController, listNavigationController]
 
    }
    

}
