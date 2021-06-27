//
//  CoreDataManager.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import CoreData
import Foundation

class CoreDataManager {

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Fuze_Tech_Task")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: Tweet Model

    func removeDuplicateTweets() {

        let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        let context = persistentContainer.viewContext

        do {
            var tweets = try context.fetch(fetchRequest)

            for tweet in tweets {
                let countDuplicateTweets = tweets.filter { filteringTweet -> Bool in
                    filteringTweet.tweetId == tweet.tweetId
                }.count

                if countDuplicateTweets > 1 {
                    context.delete(tweet)
                    if let index = tweets.firstIndex(where: {$0 == tweet}) {
                      tweets.remove(at: index)
                    }
                }
            }
        } catch(let error) {
            print(error)
        }
    }

    func fetchSavedTweets(completion: @escaping ([Tweet]?) -> Void) {

        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let tweets = try persistentContainer.viewContext.fetch(request)
            completion(tweets)

        } catch {
            print("Fetching tweets failed")
            completion(nil)
        }
    }

    func getIdForNewTweet(completion: @escaping (Int?) -> Void) {

        fetchSavedTweets { tweets in

            guard let tweets = tweets else {
                return
            }

            tweets.map(\.tweetId).map { tweetIdString -> Int? in
                return Int(tweetIdString)
            }
            .compactMap { $0 }
            .max()
            .flatMap { maxId -> Void in
                completion(maxId + 1)
            }

            completion(nil)
        }
    }

    func saveTweet(sender: String, date: String, content: String, completion: @escaping (Bool) -> Void) {

        let newTweet = Tweet(context: persistentContainer.viewContext)

        newTweet.content = content
        newTweet.sender = sender
        newTweet.date = date
        getIdForNewTweet { [weak self] id in

            guard let id = id else {
                completion(false)
                return
            }
            newTweet.tweetId = String(id)

            self?.saveContext()
            completion(true)
        }

        
    }

    // MARK: User Model

    func removeDuplicateUsers() {

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let context = persistentContainer.viewContext

        do {
            var users = try context.fetch(fetchRequest)

            for user in users {

                let countDuplicateUsers = users.filter { filteringUser -> Bool in
                    filteringUser.userId == user.userId
                }.count

                if countDuplicateUsers > 1 {
                    context.delete(user)
                    if let index = users.firstIndex(where: {$0 == user}) {
                        users.remove(at: index)
                    }
                }
            }
        } catch(let error) {
            print(error)
        }
    }

    func fetchSavedUsers(completion: @escaping ([User]?) -> Void) {

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let users = try persistentContainer.viewContext.fetch(request)
            completion(users)

        } catch {
            print("Fetching users failed")
            completion(nil)
        }
    }
}
