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
        nameTextField.placeholder = "enter wish list name"
        
        nameTextField.borderStyle = UITextField.BorderStyle.none
        //nameTextField.layer.addSublayer(bottomLine)
        
        nameTextFieldLabel = UILabel()
        nameTextFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldLabel.text = "Name of list"
        
        
        descriptionTextField = UITextField()
        descriptionTextField.textAlignment = .left
        descriptionTextField.placeholder = "Enter description"
        //descriptionTextField.layer.addSublayer(bottomLine)
        
        descriptionTextFieldLabel = UILabel()
        descriptionTextFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextFieldLabel.text = "Description"
        
        saveWishListButton = UIButton()
        saveWishListButton.setTitle("Save wishlist", for: .normal)
        saveWishListButton.setTitleColor(.black, for: .normal)
        saveWishListButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
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
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
        NSLayoutConstraint.activate([
            saveWishListButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            saveWishListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
