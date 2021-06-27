//
//  HomeCoordinator.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 26/06/2021.
//

import Foundation
import UIKit

class HomeCoordinator: CoordinatorProtocol {

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

    // MARK: Public Methods

    func start() {

        let homeViewModel = HomeViewModel(coordinator: self, session: session)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        presentedViewController = homeViewController
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func logout() {

        UserDefaults.standard.set(nil, forKey: "sessionUsername")

        LoginCoordinator(
            navigationController: navigationController,
            session: session
        ).start()
    }

    func newTweet() {

        let newTweetViewModel = NewTweetViewModel(coordinator: self, session: session)

        let newTweetViewController = NewTweetViewController(viewModel: newTweetViewModel)
    
        newTweetViewController.modalPresentationStyle = .overCurrentContext
        newTweetViewController.modalTransitionStyle = .crossDissolve

        presentedViewController?.present(newTweetViewController, animated: true)
    }

    func forceTweetCollectionViewRefresh() {

        guard let homeViewController = presentedViewController as? HomeViewController else {
            return
        }

        homeViewController.refreshInfo() {}
    }
}
