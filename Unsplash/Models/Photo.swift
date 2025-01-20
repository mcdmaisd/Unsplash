//
//  Photo.swift
//  Unsplash
//
//  Created by ilim on 2025-01-18.
//

import Foundation

struct Search: Codable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}

struct Photo: Codable {
    let id: String
    let created_at: String
    let likes: Int
    let width: Double
    let height: Double
    let user: User
    let urls: Urls
}

struct User: Codable {
    let name: String
    let profile_image: ProfileImage
}

struct Urls: Codable {
    let raw: String
    let regular: String
}

struct ProfileImage: Codable {
    let small: String
}

struct Statistics: Codable {
    let id: String
    let slug: String
    let downloads: Downloads
    let views: Downloads
    let likes: Downloads
}

struct Downloads: Codable {
    let total: Int
    let historical: Historical
}

struct Historical: Codable {
    let change: Int
    let resolution: String
    let quantity: Int
    let values: [Value]
}

struct Value: Codable {
    let date: String
    let value: Double
}
