//
//  ViewState.swift
//  PhotoSearchGallary
//
//  Created by  Daniel 18/04/22.
//

import Foundation

enum ViewState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(String)
}
