//
//  ImageSearchTests.swift
//  ImageSearchTests
//
//  Created by Admin on 19/04/2022.
//

import XCTest
@testable import ImageSearch


class ImageSearchTests: XCTestCase {

    var viewModel:PhotoSearchViewModel!
    var serviceManager:MockServiceManager!
    
    override func setUpWithError() throws {
        
        serviceManager = MockServiceManager()
        
        viewModel = PhotoSearchViewModel(serviceManager: serviceManager)
    }


    override func tearDownWithError() throws {
        viewModel = nil
    
    }

    func testSearchPhotos_success() {

        viewModel.search(searchedText: "SearchSuccessResponce")
        
        XCTAssertEqual(viewModel.photoDetailsCount, 0)

        XCTAssertEqual(viewModel.photoDetails.first?.title, "cat rider")

    }

    func testSearchPhotos_failure() {

        
        viewModel.search(searchedText: "dog")
        

        XCTAssertEqual(viewModel.photoDetailsCount, 0)

    }
    

}

