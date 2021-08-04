//
//  NewWishListViewController.swift
//  places to visit app
//
//  Created by Harriette Berndes on 30/07/2021.
//

import UIKit

protocol NewWishListVCDelegate: AnyObject {
    func saveNewWishList(name: String, description: String)
}

class NewWishListViewController: UIViewController {
    weak var delegate: NewWishListVCDelegate?
    var stackView: UIStackView!
    var nameTextFieldLabel: UILabel!
    var nameTextField: UITextField!
    var descriptionTextFieldLabel: UILabel!
    var descriptionTextField: UITextField!
    var saveWishListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        //let bottomLine = CALayer()
        //bottomLine.frame = CGRect(x: 0, y: 40, width: 300, height: 1.0)
        //bottomLine.backgroundColor = UIColor.black.cgColor
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter wish list name"
        nameTextField.borderStyle = .roundedRect
        let greyColour = CGColor.init(gray: 0.2, alpha: 0.2)
        //nameTextField.backgroundColor = UIColor(cgColor: greyColour)
        
        //nameTextField.layer.addSublayer(bottomLine)
        
        nameTextFieldLabel = UILabel()
        nameTextFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldLabel.text = "Name of list"
        
        
        descriptionTextField = UITextField()
        descriptionTextField.textAlignment = .left
        descriptionTextField.placeholder = "Enter description"
        descriptionTextField.borderStyle = .roundedRect
        //descriptionTextField.layer.addSublayer(bottomLine)
        
        descriptionTextFieldLabel = UILabel()
        descriptionTextFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextFieldLabel.text = "Description"
        
        saveWishListButton = UIButton()
        saveWishListButton.setTitle("Save wishlist", for: .normal)
        saveWishListButton.setTitleColor(.black, for: .normal)
        saveWishListButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveWishListButton.backgroundColor = UIColor(cgColor: greyColour)
        saveWishListButton.layer.cornerRadius = 5
        saveWishListButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        
        stackView = UIStackView(arrangedSubviews: [nameTextFieldLabel, nameTextField, descriptionTextFieldLabel, descriptionTextField, saveWishListButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(saveWishListButton)
        setUpConstraints()
    }
    

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        NSLayoutConstraint.activate([
            saveWishListButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            saveWishListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveWishListButton.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    @objc private func saveTapped() {
        if let name = nameTextField.text, name.count > 0,
           let description = descriptionTextField.text, description.count > 0 {
            delegate?.saveNewWishList(name: name, description: description)
            self.dismiss(animated: true)
        }
       
    }

}
