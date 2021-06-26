//
//  HomeViewModel.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import Foundation

class HomeViewModel {

    // MARK: Properties

    let coordinator: CoordinatorProtocol
    let session: Session

    // MARK: Lifecycle

    init(coordinator: CoordinatorProtocol, session: Session) {
        self.coordinator = coordinator
        self.session = session
    }
}
