//
//  MainCoordinator.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import Foundation
import UIKit

class MainCoordinator: CoordinatorProtocol {

    var presentedCoordinator: CoordinatorProtocol?
    var presentedViewController: UIViewController?
    var navigationController: UINavigationController
    var session: Session

    init(navigationController: UINavigationController, session: Session) {
        self.navigationController = navigationController
        self.session = session
    }

    func start() {

        let homeViewModel = HomeViewModel(coordinator: self, session: session)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        presentedViewController = homeViewController
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
