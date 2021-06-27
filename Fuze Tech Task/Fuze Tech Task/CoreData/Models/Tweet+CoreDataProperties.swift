//
//  Tweet+CoreDataProperties.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet")
    }

    @NSManaged public var tweetId: String
    @NSManaged public var content: String
    @NSManaged public var date: String
    @NSManaged public var sender: String

}

extension Tweet : Identifiable {

}
