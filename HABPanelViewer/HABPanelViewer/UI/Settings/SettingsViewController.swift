//
//  SettingsViewController.swift
//  HABPanelViewer
//
//  Created by Boris Krivonog on 03/05/2020.
//  Copyright © 2020 Boris Krivonog. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsUserInterface, UITextFieldDelegate {
    
    private lazy var presenter: SettingsPresenter = {
        let presenter = SettingsPresenterImpl()
        presenter.userInterface = self
        return presenter
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SETTINGS"
        label.font = .systemFont(ofSize: 32)
        return label
    }()
    
    private lazy var openhabUrlTextField: UITextField = createTextField("OPENHAB URL", .URL)

    private lazy var defaultDashboardTextField: UITextField = createTextField("Default dashboard")

    private lazy var usernameTextField: UITextField = createTextField("Username", .emailAddress)
    
    private lazy var passwordTextField: UITextField = {
        let textField = createTextField("Password")
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var ctrlContentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            openhabUrlTextField,
            defaultDashboardTextField,
            usernameTextField,
            passwordTextField
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            ctrlContentView,
            saveButton,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 40
        return stackView
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.setTitle("SAVE", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        return button
    }()

    var viewState: SettingsViewState = SettingsViewState() {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(contentView)
        contentView.fillUsingAutoLayout(insets: UIEdgeInsets(top: 32, left: 24, bottom: 32, right: 24))

        presenter.initialize()
    }
    
    private func updateView() {
        openhabUrlTextField.text = viewState.settings?.openhabUrlString
        defaultDashboardTextField.text = viewState.settings?.defaultDashboard
        usernameTextField.text = viewState.settings?.username
        passwordTextField.text = viewState.settings?.password
    }
    
    @objc private func onSave() {
        let settings = Settings(
            openhabUrlString: openhabUrlTextField.text,
            defaultDashboard: defaultDashboardTextField.text,
            username: usernameTextField.text,
            password: passwordTextField.text
        )
        presenter.save(settings: settings)
        dismiss(animated: true, completion: nil)
    }
    
    private func createTextField(_ placeholder: String, _ keyboardType: UIKeyboardType? = nil) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        keyboardType.flatMap { textField.keyboardType = $0 }
        textField.returnKeyType = .done
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return textField
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
