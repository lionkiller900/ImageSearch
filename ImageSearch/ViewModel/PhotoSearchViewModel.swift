//
//  PhotoSearchViewModel.swift
//  PhotoSearchGallary
//
//  Created by  Daniel 18/04/22.
//

import Foundation
import Combine


protocol PhotoSearchViewModelType {
    var stateBinding: Published<ViewState>.Publisher { get }
    var photoDetailsCount:Int { get }
    var photoDetails:[PhotoDetail] { get }
    var photoRecords:[PhotoRecord] { get }

    func search(searchedText: String)
}

final class PhotoSearchViewModel: PhotoSearchViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }
    
    private let serviceManager:Servicable
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var state: ViewState = .none
    
    var photoDetails:[PhotoDetail] = []
    var photoRecords:[PhotoRecord] = []

    var photoDetailsCount: Int {
        return photoDetails.count
    }
    
    init(serviceManager:Servicable) {
        self.serviceManager = serviceManager
    }
    
    func search(searchedText: String) {
        
        state = ViewState.loading
        
        let request = Request(baseUrl: APIEndPoints.baseUrl, path:"", params: ["method":APIEndPoints.photoMethod, "text":searchedText, "api_key": APIEndPoints.apiKey, "format" : "json", "nojsoncallback" : "1"])
        
        
        let publisher = serviceManager.doApiCall(apiRequest: request)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.photoDetails = []
                self?.state = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] images in
            self?.photoDetails = images
            self?.photoRecords =  images.map {
                PhotoRecord(name: $0.title, url: $0.url)
            }
            self?.state = ViewState.finishedLoading
        }
        self.cancellables.insert(cancalable)
    }
    
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
