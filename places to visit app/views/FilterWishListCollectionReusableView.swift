//
//  FilterWishListCollectionReusableView.swift
//  places to visit app
//
//  Created by Harriette Berndes on 12/08/2021.
//

import UIKit

class FilterWishListCollectionReusableView: UICollectionReusableView {
    private var headerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "header label"
        headerLabel.font = .boldSystemFont(ofSize: 25)
        
        addSubview(headerLabel)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
