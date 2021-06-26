//
//  LoginViewModel.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 26/06/2021.
//

import UIKit

class LoginViewModel {

    // MARK: Properties

    let coordinator: CoordinatorProtocol
    let session: Session

    // MARK: UI Properties

    let cornerRadius: CGFloat = 10
    let outerConstraintConstant: CGFloat = 15
    let widthMultiplier: CGFloat = 0.7
    let heightMultiplier: CGFloat = 0.4

    // MARK: Lifecycle

    init(coordinator: CoordinatorProtocol, session: Session) {
        self.coordinator = coordinator
        self.session = session
    }

    // MARK: Public Methods

    func makeLogin(username: String, password: String, completion: @escaping (Bool) -> Void) {

        guard let coordinator = coordinator as? LoginCoordinator else {
            completion(false)
            return
        }

        coordinator.login(username: username, password: password) {
            completion($0)
        }
    }
}
