//
//  RequestManager.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import Foundation

class RequestManager {

    // MARK: Properties

    let constants: Constants
    let coreDataManager: CoreDataManager

    // MARK: Lifecycle

    init(
        constants: Constants,
        coreDataManager: CoreDataManager
    ) {
        self.constants = constants
        self.coreDataManager = coreDataManager
    }
}
