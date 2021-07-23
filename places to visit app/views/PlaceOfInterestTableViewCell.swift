//
//  PlaceOfInterestTableViewCell.swift
//  map-lists
//
//  Created by Harriette Berndes on 13/07/2021.
//

import UIKit
import MapKit

class PlaceOfInterestTableViewCell: UITableViewCell {
    
    private var nameLabel: UILabel!
    private var addressLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textColor = .gray
        contentView.addSubview(addressLabel)
        
        setUpConstraints()
    }
    
    func configureMKMapItem(mapItem: MKMapItem) {
        nameLabel.text = mapItem.name
        if let number = mapItem.placemark.subThoroughfare, let street = mapItem.placemark.thoroughfare {
            addressLabel.text = "\(number), \(street)"
        } else {
            addressLabel.text = "not found"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
