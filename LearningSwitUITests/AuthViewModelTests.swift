//
//  AuthViewModelTests.swift
//  LearningSwitUITests
//
//  Created by Vishal Kothari on 12/01/26.
//

import XCTest
import Firebase
@testable import LearningSwitUI
final class AuthViewModelTests: XCTestCase {
    var viewModel:AuthViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = AuthViewModel(authService: <#T##any AuthServiceProtocol#>)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


protocol Router{
    func loginSuccess()
}

class MockRouter:Router{
    var loginCalled = false
    func loginSuccess() {
        loginCalled = true
    }
    
}


protocol Session{
    func setUser(model:UserModel)
}

class MockSession:Session {
    var model:UserModel?
    func setUser(model:UserModel) {
        self.model = model//Track what was test
    }
}


