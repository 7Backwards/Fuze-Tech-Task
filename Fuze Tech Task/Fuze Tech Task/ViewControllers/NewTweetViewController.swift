//
//  NewTweetViewController.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 27/06/2021.
//

import Foundation
import UIKit

class NewTweetViewModel {

    // MARK: Properties

    let coordinator: CoordinatorProtocol
    let session: Session
    let cornerRadius: CGFloat = 10
    let verticalStackViewSpacing: CGFloat = 20
    let containerViewCornerRadius: CGFloat = 20
    let outerConstraintConstant: CGFloat = 15
    let containerViewSize: CGFloat = 300
    let containerViewShadowOpacity: Float = 1
    let containerViewShadowRadius: CGFloat = 5
    let containerViewShadowOffset: CGSize = CGSize(width: 0, height: 2)

    // MARK: Lifecycle

    init(coordinator: CoordinatorProtocol, session: Session) {
        self.coordinator = coordinator
        self.session = session
    }

    @objc func submitTweet(content: String, completion: @escaping (Bool) -> Void) {
        session.requestManager.requestSubmitTweet(content: content) { result in
            completion(result)
        }
    }

    func forceTweetCollectionViewRefresh() {

        guard let coordinator = coordinator as? HomeCoordinator else {
            return
        }

        coordinator.forceTweetCollectionViewRefresh()

    }
}

class NewTweetViewController: UIViewController {

    // MARK: Properties

    let viewModel: NewTweetViewModel

    // MARK: UI

    lazy var containerView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = viewModel.containerViewShadowOffset
        view.layer.shadowRadius = viewModel.containerViewShadowRadius
        view.layer.shadowOpacity = viewModel.containerViewShadowOpacity
        view.layer.cornerRadius = viewModel.containerViewCornerRadius

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var verticalStackView: UIStackView = {

        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.spacing = viewModel.verticalStackViewSpacing
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var popUpTitle: UILabel = {
        let label = UILabel()
        label.text = "New Tweet"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var tweetTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.contentVerticalAlignment = .top
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .systemBlue
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = viewModel.cornerRadius
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(submitTweet), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var containerViewBottomConstraint: NSLayoutConstraint = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)

    lazy var containerViewCenterYConstraint: NSLayoutConstraint = containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
    
    // MARK: Lifecycle

    init(viewModel: NewTweetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Private methods

    private func setupUI() {

        definesPresentationContext = true
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.addSubview(containerView)

        containerView.addSubview(popUpTitle)
        containerView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(popUpTitle)
        verticalStackView.addArrangedSubview(tweetTextField)
        verticalStackView.addArrangedSubview(submitButton)

        NSLayoutConstraint.activate([
            containerViewCenterYConstraint,
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: viewModel.containerViewSize),
            containerView.heightAnchor.constraint(equalToConstant: viewModel.containerViewSize),
            popUpTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: viewModel.outerConstraintConstant),
            popUpTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: viewModel.outerConstraintConstant),
            popUpTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -viewModel.outerConstraintConstant),
            popUpTitle.heightAnchor.constraint(equalToConstant: 30),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: viewModel.outerConstraintConstant),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -viewModel.outerConstraintConstant),
            verticalStackView.topAnchor.constraint(equalTo: popUpTitle.bottomAnchor, constant: viewModel.outerConstraintConstant),
            
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -viewModel.outerConstraintConstant)
        ])
    }

    @objc private func submitTweet() {

        guard let content = tweetTextField.text else {
            return
        }
        viewModel.submitTweet(content: content) { [weak self] result in

            if !result {

                let alert = UIAlertController(title: "Submit Error", message: "Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert, animated: true, completion: nil)
            } else {
                self?.viewModel.forceTweetCollectionViewRefresh()
                self?.dismiss(animated: false, completion: nil)
            }
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerViewCenterYConstraint.isActive = false
            containerViewBottomConstraint.constant = -keyboardSize.height - viewModel.outerConstraintConstant
            containerViewBottomConstraint.isActive = true
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        containerViewBottomConstraint.isActive = true
        containerViewBottomConstraint.isActive = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first

        if touch?.view == containerView {
            return
        }

        for view in containerView.subviews {
            if touch?.view == view {
                return
            }
        }

        dismiss(animated: false, completion: nil)
    }
}
