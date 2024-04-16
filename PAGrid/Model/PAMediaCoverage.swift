//
//  PAMediaCoverage.swift
//  PAGrid
//
//  Created by Admin on 15/04/24.
//

import Foundation

struct MediaCoverage: Codable {
    let id: String
    let title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt: String
    let publishedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case language
        case thumbnail
        case mediaType
        case coverageURL
        case publishedAt
        case publishedBy
    }
}

struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case version
        case domain
        case basePath
        case key
        case qualities
    }

}
