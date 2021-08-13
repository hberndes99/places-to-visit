//
//  FilterWishListCollectionViewCell.swift
//  places to visit app
//
//  Created by Harriette Berndes on 12/08/2021.
//

import UIKit

class FilterWishListCollectionViewCell: UICollectionViewCell {
    static let identifier = "filterCell"
    private var backgroundCellView: UIView!
    private var titleLabel: UILabel!
    var cellIsSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
        backgroundCellView = UIView(frame: .zero)
        backgroundCellView.backgroundColor = .systemGreen
        backgroundCellView.layer.cornerRadius = 15
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        contentView.addSubview(backgroundCellView)
        contentView.addSubview(titleLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundCellView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            backgroundCellView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            backgroundCellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundCellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureCVCell(for wishList: WishList) {
        titleLabel.text = wishList.name
    }
    
    func configureSelected() {
        backgroundCellView.backgroundColor = .purple
    }
    
    func configureDeselected() {
        backgroundCellView.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
