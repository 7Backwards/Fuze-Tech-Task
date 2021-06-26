//
//  LoginCoordinator.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import Foundation
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
        navigationController.pushViewController(loginViewController, animated: true)
    }

    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {

        session.requestManager.requestCheckLoginAttempt(username: username, password: password) { [weak self] loginAttempt in

            guard let self = self else {

                print("self not found")
                completion(false)
                return
            }

            if loginAttempt {

                let homeCoordinator = HomeCoordinator(navigationController: self.navigationController, session: self.session)

                completion(true)

                homeCoordinator.start()
            } else {

                completion(false)
            }
        }
    }
}
