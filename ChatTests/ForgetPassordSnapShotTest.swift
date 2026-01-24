//
//  ForgetPassordSnapShotTest.swift
//  LearningSwitUITests
//
//  Created by Vishal Kothari on 16/01/26.
//

import XCTest
import SnapshotTesting
@testable import LearningSwitUI
import SwiftUI

final class ForgetPassordSnapShotTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        isRecording = true
        
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

    func test_my_Viewsnpshot(){
        let myview = ForgetPwd()
            .frame(width: 375,height:812)
        assertSnapshot(of: myview, as: .image)
    }
}
