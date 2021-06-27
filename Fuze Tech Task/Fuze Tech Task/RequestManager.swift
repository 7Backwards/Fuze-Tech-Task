//
//  RequestManager.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import Foundation
import OSLog

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

    // MARK: Tweets Model Methods

    func requestSubmitTweet(content: String, completion: @escaping (Bool) -> Void) {

        let dateFormattedString = Date().getFormattedDate(format: constants.dateFormat)
        guard let username = UserDefaults.standard.value(forKey: "sessionUsername") as? String else {
            os_log("Failed getting username from UserDefaults", type: .error)
            return
        }

        coreDataManager.saveTweet(sender: username, date: dateFormattedString, content: content) { result in
            completion(result)
        }
    }

    func requestUpdateTweets(completion: @escaping () -> Void) {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "MOCK_Tweets", ofType: "json") else {
            os_log("Json file not found", type: .error)
            return
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            os_log("Unable to convert json to string", type: .error)
            return
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            os_log("Unable to convert json string to data", type: .error)
            return
        }

        let decoder = JSONDecoder()

        decoder.userInfo[.context] = coreDataManager.persistentContainer.viewContext
        
        do {
            
            _ = try decoder.decode([Tweet].self, from: jsonData)

            coreDataManager.removeDuplicateTweets()

        } catch(let error) {
            os_log("Error: %@", type: .error, String(describing: error))
            completion()
        }

        DispatchQueue.main.async { [weak self] in

            guard let self = self else {

                os_log("Something went wrong! Somehow we've reached here without 'self' value.", type: .error)
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
                os_log("Fetched from DB: %@", type: .info, String(describing: tweet))
            }

            completion(tweets)
        }
    }

    // MARK: User Model Methods

    func requestUpdateUsers(completion: @escaping () -> Void) {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "MOCK_Users", ofType: "json") else {
            os_log("Json file not found", type: .error)
            return
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            os_log("Unable to convert json to string", type: .error)
            return
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            os_log("Unable to convert json string to data", type: .error)
            return
        }

        let decoder = JSONDecoder()

        decoder.userInfo[.context] = coreDataManager.persistentContainer.viewContext

        do {
            _ = try decoder.decode([User].self, from: jsonData)

            coreDataManager.removeDuplicateUsers()

        } catch(let error) {
            os_log("Error: %@", type: .error, String(describing: error))
            completion()
        }

        DispatchQueue.main.async { [weak self] in

            guard let self = self else {

                os_log("Something went wrong! Somehow we've reached here without 'self' value.", type: .error)
                return
            }
            self.coreDataManager.saveContext()
            completion()
        }
    }

    func requestRetrieveUsersFromDB(completion: @escaping ([User]?) -> Void) {
        coreDataManager.fetchSavedUsers { users in
            guard let users = users else {
                completion(nil)
                return
            }

            completion(users)
        }
    }

    func requestCheckLoginAttempt(username: String, password: String, completion: @escaping (Bool) -> Void) {

        requestUpdateUsers { [weak self] in
            self?.requestRetrieveUsersFromDB { users in
                if let users = users {
                    for user in users {
                        if user.username == username && user.password == password {
                            os_log("Login for user: %@ successful", type: .info, username)
                            completion(true)
                            return
                        }
                    }
                }
                os_log("Login for user: %@ failed", type: .info, username)
                completion(false)
            }
        }
    }
}
