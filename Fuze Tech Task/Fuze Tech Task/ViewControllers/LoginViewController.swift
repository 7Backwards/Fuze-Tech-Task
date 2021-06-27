//
//  LoginViewController.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 26/06/2021.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties

    let viewModel: LoginViewModel

    // MARK : UI

    lazy var containerView: UIView = {
        
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var verticalStackView: UIStackView = {
        
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var usernameStackView: UIStackView = {
        
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var passwordStackView: UIStackView = {
        
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "loginTitle".localized()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var usernameLabel: UILabel = {

        let label = UILabel()
        label.text = "loginUsernameLabel".localized()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var passwordLabel: UILabel = {

        let label = UILabel()
        label.text = "loginPasswordLabel".localized()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var usernameTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    lazy var passwordTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    lazy var loginButton: UIButton = {

        let button = UIButton(type: .system)
        
        button.backgroundColor = .systemBlue
        button.setTitleColor(.black, for: .normal)
        button.setTitle("loginTitle".localized(), for: .normal)
        button.layer.cornerRadius = viewModel.cornerRadius
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var containerViewBottomConstraint: NSLayoutConstraint = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)

    lazy var containerViewCenterYConstraint: NSLayoutConstraint = containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)

    // MARK: Lifecycle

    init(viewModel: LoginViewModel) {

        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupUI()

        navigationItem.hidesBackButton = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        super.viewDidLoad()
    }

    // MARK: Private methods

    private func setupUI() {
  
        containerView.layer.cornerRadius = viewModel.cornerRadius

        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        containerView.backgroundColor = .white

        view.addSubview(containerView)
        containerView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(usernameStackView)
        verticalStackView.addArrangedSubview(passwordStackView)
        verticalStackView.addArrangedSubview(loginButton)
        usernameStackView.addArrangedSubview(usernameLabel)
        usernameStackView.addArrangedSubview(usernameTextField)
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)

        NSLayoutConstraint.activate ([
            containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            containerViewCenterYConstraint,
            containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: viewModel.widthMultiplier),
            containerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: viewModel.heightMultiplier),
            verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: viewModel.outerConstraintConstant),
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -viewModel.outerConstraintConstant),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: viewModel.outerConstraintConstant),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -viewModel.outerConstraintConstant)
        ])
    }

    @objc private func logInButtonPressed() {

        guard
            let usernameTextField = usernameTextField.text,
            let passwordTextField = passwordTextField.text
        else {
            return
        }

        viewModel.makeLogin(username: usernameTextField, password: passwordTextField) { [weak self] result in
            if !result {

                let alert = UIAlertController(title: "loginFailedTitle".localized(), message: "loginFailedMessage".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "loginFailedAction".localized(), style: .default))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerViewCenterYConstraint.isActive = false
            containerViewBottomConstraint.constant = -keyboardSize.height - viewModel.outerConstraintConstant
            containerViewBottomConstraint.isActive = true
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        containerViewBottomConstraint.isActive = true
        containerViewBottomConstraint.isActive = false
    }
}
