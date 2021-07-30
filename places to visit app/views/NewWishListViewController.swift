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
    var nameTextField: UITextField!
    var descriptionTextField: UITextField!
    var saveWishListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        nameTextField = UITextField()
        nameTextField.placeholder = "enter wish list name"
        
        descriptionTextField = UITextField()
        descriptionTextField.placeholder = "description"
        
        saveWishListButton = UIButton()
        saveWishListButton.setTitle("Save wishlist", for: .normal)
        saveWishListButton.setTitleColor(.black, for: .normal)
        saveWishListButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        stackView = UIStackView(arrangedSubviews: [nameTextField, descriptionTextField, saveWishListButton])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        setUpConstraints()
    }
    

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func saveTapped() {
        print("saved")
        if let name = nameTextField.text, let description = descriptionTextField.text {
            delegate?.saveNewWishList(name: name, description: description)
            self.dismiss(animated: true)
        }
       
    }

}
