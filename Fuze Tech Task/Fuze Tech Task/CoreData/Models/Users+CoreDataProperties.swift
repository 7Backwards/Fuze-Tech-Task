//
//  User+CoreDataProperties.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 26/06/2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userId: String
    @NSManaged public var username: String
    @NSManaged public var password: String

}

extension User : Identifiable {

}
