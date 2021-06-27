//
//  LoginCoordinator.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import OSLog
import UIKit

class LoginCoordinator: CoordinatorProtocol {

    // MARK: Properties

    var presentedCoordinator: CoordinatorProtocol?
    var presentedViewController: UIViewController?
    var navigationController: UINavigationController
    var session: Session

    // MARK: Lifecycle

    init(navigationController: UINavigationController, session: Session) {
        self.navigationController = navigationController
        self.session = session
    }

    // Public Methods

    func start() {

        let loginViewModel = LoginViewModel(coordinator: self, session: session)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        presentedViewController = loginViewController
        navigationController.pushViewController(loginViewController, animated: false)
    }

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {

        session.requestManager.requestCheckLoginAttempt(username: username, password: password) { [weak self] loginAttempt in

            guard let self = self else {

                os_log("Something went wrong! Somehow we've reached here without 'self' value.", type: .error)
                completion(false)
                return
            }

            if loginAttempt {

                let homeCoordinator = HomeCoordinator(navigationController: self.navigationController, session: self.session)

                UserDefaults.standard.set(username, forKey: "sessionUsername")

                completion(true)

                homeCoordinator.start()
            } else {

                completion(false)
            }
        }
    }
}
