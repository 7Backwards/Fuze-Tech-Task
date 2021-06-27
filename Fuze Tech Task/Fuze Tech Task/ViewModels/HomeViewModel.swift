//
//  HomeViewModel.swift
//  Fuze Tech Task
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import UIKit
import OSLog

class HomeViewModel {

    // MARK: Properties

    let coordinator: CoordinatorProtocol
    let session: Session
    var tweetsData = [Tweet]()
    let cellHeight: CGFloat = 200
    let horizontalConstraintConstant: CGFloat = 15
    let verticalConstraintConstant: CGFloat = 15
    let collectionViewLayoutMinimumInteritemSpacing: CGFloat = 5

    // MARK: Lifecycle

    init(coordinator: CoordinatorProtocol, session: Session) {
        self.coordinator = coordinator
        self.session = session
    }

    // MARK: Public Methods

    func updateCellsInfo(completion: @escaping () -> Void) {

        session.requestManager.requestUpdateTweets { [weak self] in

            self?.session.requestManager.requestRetrieveTweetsFromDB { [weak self] tweets in

                guard
                    let tweets = tweets,
                    let strongSelf = self
                else {
                    os_log("No tweets retrieved from DB", type: .info)
                    completion()
                    return
                }

                strongSelf.tweetsData = tweets
                strongSelf.tweetsData.sort(by: { $0.tweetId > $1.tweetId } )
                completion()
            }
        }
    }

    func fetchCellsInfo(completion: @escaping (Bool) -> Void) {

        session.requestManager.requestRetrieveTweetsFromDB() { [weak self] tweets in

            guard let strongSelf = self else {
                os_log("Something went wrong! Somehow we've reached here without 'self' value.", type: .error)
                completion(false)
                return
            }

            guard let tweets = tweets else {
                os_log("Error unwrapping tweets retrieved from database", type: .error)
                completion(false)
                return
            }

            if tweets.count < 1 {
               completion(false)
            } else {
                strongSelf.tweetsData = tweets
                strongSelf.tweetsData.sort(by: { $0.tweetId > $1.tweetId } )
                completion(true)
            }
        }
    }

    func newTweet() {

        guard let coordinator = coordinator as? HomeCoordinator else {
            return
        }

        coordinator.newTweet()
    }

    func logout() {

        guard let coordinator = coordinator as? HomeCoordinator else {
            return
        }
        coordinator.logout()
    }
}
