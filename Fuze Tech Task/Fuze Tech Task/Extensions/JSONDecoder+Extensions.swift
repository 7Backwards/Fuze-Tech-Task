//
//  JSONDecoder+Extensions.swift
//  Forecasty
//
//  Created by Gonçalo Neves on 18/06/2021.
//

import CoreData
import Foundation

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}
