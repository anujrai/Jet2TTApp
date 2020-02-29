//
//  NetworkWrapperTests.swift
//  Jet2TTApp
//
//  Created by Anuj Rai on 24/02/20.
//  Copyright © 2020 Anuj Rai. All rights reserved.


import XCTest
@testable import Jet2TTApp

class NetworkWrapperTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEmployeeFetchLoadCorrectURL() {
        
        class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
            func resume() {}
            func cancel() {}
        }
        
        class URLSessionMock: URLSessionProtocol {
            var lastUrl: URL?
            
            func dataTask(with url: URL,
                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
                self.lastUrl = url
                completionHandler(nil, nil, nil)
                return URLSessionDataTaskMock()
            }
        }
        
        //Given
        let url = URL(string: "https://randomuser.me/api/?results=5")!
        let session = URLSessionMock()
        let expectation = XCTestExpectation(description: "Network Operation")
        
        //When
        NetworkWrapper.sharedInstance.makeNetworkRequest(url: url,
                                                         using: session,
                                                         modelResponse: MemberResponse.self) { (error, response) in
                                                            
                                                            //Then
                                                            XCTAssertEqual(session.lastUrl, URL(string: "https://randomuser.me/api/?results=5")!)
                                                            expectation.fulfill()
                                                            
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testEmployeeFetchCallsResume() {
        
        class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
            
            private(set) var wasResumeCalled = false
            let completion: (Data?, URLResponse?, Error?) -> Void
            
            init(with completion: @escaping (Data?, URLResponse?, Error?) -> Void ) {
                self.completion = completion
            }
            
            func resume() {
                wasResumeCalled = true
                completion(nil, nil, nil)
            }
            
            func cancel() {}
        }
        
        class URLSessionMock: URLSessionProtocol {
            
            var lastUrl: URL?
            var dataTask: URLSessionDataTaskMock?
            
            func dataTask(with url: URL,
                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
                self.lastUrl = url
                let newDataTask = URLSessionDataTaskMock(with: completionHandler)
                dataTask = newDataTask
                return newDataTask
            }
        }
        
        //Given
        let url = URL(string: "https://randomuser.me/api/?results=5")!
        let session = URLSessionMock()
        let expectation = XCTestExpectation(description: "Network Operation")
        
        //When
        NetworkWrapper.sharedInstance.makeNetworkRequest(url: url,
                                                         using: session,
                                                         modelResponse: MemberResponse.self) { (error, response) in
                                                            
                                                            //Then
                                                            XCTAssertTrue(session.dataTask?.wasResumeCalled ?? false)
                                                            expectation.fulfill()
        }
        
        wait(for:[expectation], timeout: 5)
    }
    
    func testNewStoriesAreFetched() {
        
        class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
            func resume() {}
            func cancel() {}
        }
        
        class URLSessionMock: URLSessionProtocol {
            
            var lastUrl: URL?
            var data: Data?
            
            func dataTask(with url: URL,
                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
                self.lastUrl = url
                let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
                completionHandler(self.data, urlResponse, nil)
                return URLSessionDataTaskMock()
            }
        }
        
        //Given
        let url = URL(string: "https://randomuser.me/api/?results=5")!
        let session = URLSessionMock()
        session.data = readDummyJSONResonse()
        let expectation = XCTestExpectation(description: "Network Operation")
        
        //When
        NetworkWrapper.sharedInstance.makeNetworkRequest(url: url,
                                                         using: session,
                                                         modelResponse: MemberResponse.self) { (error, response) in
                                                            
                                                            //Then
                                                            guard let member = response?.results?.first else {
                                                                XCTFail()
                                                                return
                                                            }
                                                            XCTAssertEqual(member.fullName, "Teresa Smith")
                                                            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
