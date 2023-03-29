//
//  ApiServiceResponse.swift
//  Appstore
//
//  Created by 윤성환 on 2023/03/19.
//

import Foundation

struct _SearchResult: Codable {
    let resultCount: Int
    var results: [ResultData]?
    
    struct ResultData: Codable {
        let trackName : String
        let artworkUrl60, artworkUrl100 : String
        let averageUserRating : Double
        let userRatingCount : Int
        let screenshotUrls: [String]
        let trackContentRating : String
        let description : String
        let releaseNotes : String?
    }
    
}


