//
//  Session.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import Foundation

class Session {

    // MARK: Properties

    let constants: Constants
    let requestManager: RequestManager

    // MARK: Lifecycle

    init(
        constants: Constants,
        requestManager: RequestManager
    ) {
        self.constants = constants
        self.requestManager = requestManager
    }
}
