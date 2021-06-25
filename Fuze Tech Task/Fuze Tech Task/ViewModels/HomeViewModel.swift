//
//  HomeViewModel.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import Foundation

class HomeViewModel {

    // MARK: Properties

    let coordinator: MainCoordinator
    let session: Session

    // MARK: Lifecycle

    init(coordinator: MainCoordinator, session: Session) {
        self.coordinator = coordinator
        self.session = session
    }

}
