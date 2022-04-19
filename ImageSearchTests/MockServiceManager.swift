//
//  MockServiceManager.swift
//  PhotoSearchGallaryTests
//
//  Created by  Daniel 18/04/22.
//

import Foundation
@testable import ImageSearch
import Combine

class MockServiceManager: Servicable {
    func doApiCall(apiRequest: Requestable) -> Future<[PhotoDetail], ServiceError> {

        return Future { promise in
            
            let bundle = Bundle(for:MockServiceManager.self)
            
            guard let url = bundle.url(forResource:apiRequest.params["text"], withExtension:"json"),
                  let data = try? Data(contentsOf: url)

            else {
                promise(.failure(ServiceError.dataNotFound))
          
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(PhotoSearchResonce.self, from: data) else {
                return promise(.failure(ServiceError.parsingError))
            }
            
           let phototsDetails = decodedResponse.photos.photo.map {
               PhotoDetail( title: $0.title, url: "\(APIEndPoints.imagesBaseUrl)/\($0.server)/\($0.id)_\($0.secret)_w.jpg")
            }
        
            return promise(.success(phototsDetails))
        }
    }
}
