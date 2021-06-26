//
//  User+CoreDataClass.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 26/06/2021.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
    }

    required convenience public init(from decoder: Decoder) throws {

        guard
            let context = decoder.userInfo[.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        else {
          fatalError("fatal error")
        }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.password = try container.decodeIfPresent(String.self, forKey: .password)
    }
}
