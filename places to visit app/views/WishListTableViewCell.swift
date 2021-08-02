//
//  WishListTableViewCell.swift
//  places to visit app
//
//  Created by Harriette Berndes on 02/08/2021.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    private var nameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var itemNumberLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Constants.wishListCell)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        itemNumberLabel = UILabel()
        itemNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNumberLabel.textColor = .gray
        contentView.addSubview(itemNumberLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 250),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            itemNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            itemNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
    
    func configureForWishlist(for wishList: WishList) {
        nameLabel.text = wishList.name
        descriptionLabel.text = wishList.description
        itemNumberLabel.text = "\(wishList.items.count) items"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
