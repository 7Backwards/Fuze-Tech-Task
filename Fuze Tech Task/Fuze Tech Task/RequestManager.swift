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

    // MARK: Public Methods

    func requestUpdateTweets(completion: @escaping () -> Void) {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "MOCK_Tweets", ofType: "json") else {
            fatalError("Json file not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            print("Unable to convert json to string")
            return
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Unable to convert json string to data")
            return
        }

        let decoder = JSONDecoder()

        decoder.userInfo[.context] = coreDataManager.persistentContainer.viewContext

        do {
            _ = try decoder.decode([Tweet].self, from: jsonData)
        } catch(let error) {
            print(error)
            completion()
        }

        DispatchQueue.main.async { [weak self] in

            guard let self = self else {

                print("Something went wrong! Somehow we've reached here without 'self' value.")
                return
            }
            self.coreDataManager.saveContext()
            completion()
        }
    }

    func requestRetrieveTweetsFromDB(completion: @escaping ([Tweet]?) -> Void) {
        coreDataManager.fetchSavedTweets { tweets in
            guard let tweets = tweets else {
                completion(nil)
                return
            }

            for tweet in tweets {
                print(tweet)
            }

            completion(tweets)
        }
    }
}
