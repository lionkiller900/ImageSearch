//
//  PhotoSearchResonce.swift
//  PhotoSearchGallary
//
//  Created by Daniel 18/04/22.
//

import Foundation

// MARK: - PhotoSearchResonce.swift
struct PhotoSearchResonce: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
