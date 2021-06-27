//
//  Fuze_Tech_TaskTests.swift
//  Fuze Tech TaskTests
//
//  Created by Gonçalo Neves on 25/06/2021.
//

import XCTest
@testable import Fuze_Tech_Task

class Fuze_Tech_TaskTests: XCTestCase {

    lazy var usersJson: String = {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "MOCK_Users", ofType: "json") else {
            fatalError("Json file not found")
        }

        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }

        return json
    }()

    lazy var usersJsonData: Data = {

        return usersJson.data(using: .utf8)!
    }()

    lazy var tweetsJson: String = {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "MOCK_Tweets", ofType: "json") else {
            fatalError("Json file not found")
        }

        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }

        return json
    }()

    lazy var tweetsJsonData: Data = {

        return tweetsJson.data(using: .utf8)!
    }()

    let coreDataManager = CoreDataManager()

    func testJSONUsersDecoder() throws {

        let decoder = JSONDecoder()
        decoder.userInfo[.context] = coreDataManager.persistentContainer.viewContext
        let users = try decoder.decode([User].self, from: usersJsonData)

        XCTAssertEqual("1", users.first?.userId)
        XCTAssertEqual("test", users.first?.username)
        XCTAssertEqual("123123", users.first?.password)

        XCTAssertEqual("5", users.last?.userId)
        XCTAssertEqual("rpingstone4", users.last?.username)
        XCTAssertEqual("7EkiFPk", users.last?.password)
    }

    func testJSONTweetsDecoder() throws {

        let decoder = JSONDecoder()
        decoder.userInfo[.context] = coreDataManager.persistentContainer.viewContext
        let tweets = try decoder.decode([Tweet].self, from: tweetsJsonData)

        XCTAssertEqual("1", tweets.first?.tweetId)
        XCTAssertEqual("4/1/2021", tweets.first?.date)
        XCTAssertEqual("In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.", tweets.first?.content)
        XCTAssertEqual("fsimco0", tweets.first?.sender)

        XCTAssertEqual("5", tweets.last?.tweetId)
        XCTAssertEqual("13/12/2020", tweets.last?.date)
        XCTAssertEqual("Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.", tweets.last?.content)
        XCTAssertEqual("wclery4", tweets.last?.sender)
    }

    func testLoginWithCorrectCredentials() throws {

        let expectation = XCTestExpectation(description: "login")

        let requestManager = RequestManager(constants: Constants(), coreDataManager: coreDataManager)

        requestManager.requestCheckLoginAttempt(username: "test", password: "123123") { loginAttempt in

            XCTAssertTrue(loginAttempt)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }

    func testLoginWithIncorrectCredentials() throws {

        let expectation = XCTestExpectation(description: "login")

        let requestManager = RequestManager(constants: Constants(), coreDataManager: coreDataManager)

        requestManager.requestCheckLoginAttempt(username: "test1", password: "1231231") { loginAttempt in

            XCTAssertFalse(loginAttempt)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }

    func testCreateNewTweetAndRetrieveItFromDB() throws {

        let expectation = XCTestExpectation(description: "login")

        let requestManager = RequestManager(constants: Constants(), coreDataManager: coreDataManager)

        UserDefaults.standard.set("testUsername", forKey: "sessionUsername")

        requestManager.requestSubmitTweet(content: "This is a test tweet") { _ in
            requestManager.requestRetrieveTweetsFromDB() { tweets in

                guard let tweets = tweets else {
                    XCTAssert(false)
                    expectation.fulfill()
                    return
                }
                for tweet in tweets {
                    if tweet.content == "This is a test tweet" && tweet.sender == "testUsername" {
                        XCTAssert(true)
                        expectation.fulfill()
                    }
                }
            }
        }

        wait(for: [expectation], timeout: 3)
    }
}
