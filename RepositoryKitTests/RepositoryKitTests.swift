//
//  RepositoryKitTests.swift
//  RepositoryKitTests
//
//  Created by Jonathan Wong on 3/23/24.
//

import XCTest
@testable import RepositoryKit

final class RepositoryKitTests: XCTestCase {

    var repository: Repository<[String]>!
    
    override func setUp() {
        super.setUp()
        repository = Repository([String].self, filename: "employees_test", fileExtension: "json")
    }
    
    override func tearDown() {
        super.tearDown()
        repository = nil
    }
    
    func testCache() {
        // Get the expected cache URL
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let subfolder = "com.employees"
        let expectedURL = URL(fileURLWithPath: path).appendingPathComponent(subfolder)
        
        // Check if the cache URL is correct
        XCTAssertEqual(repository.cache, expectedURL)
    }

}
