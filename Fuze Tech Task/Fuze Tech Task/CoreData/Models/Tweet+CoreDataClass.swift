//
//  Tweet+CoreDataClass.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//
//

import Foundation
import CoreData

@objc(Tweet)
public class Tweet: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case date = "date"
        case sender = "sender"
    }

    required convenience public init(from decoder: Decoder) throws {

        guard
            let context = decoder.userInfo[.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Tweet", in: context)
        else {
          fatalError("fatal error")
        }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.sender = try container.decodeIfPresent(String.self, forKey: .sender)
    }
}
