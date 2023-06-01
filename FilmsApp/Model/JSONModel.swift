//
//  JSONModel.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import Foundation

//Модель json для получения фильмов
class MovieList: Codable {
    var page: Int?
    var results: [Result]?
    var totalPages: Int?
    var totalResults: Int?
    
    enum codingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

//Сами фильмы
class Result: Codable {
    var id: Int?
    var original_title: String?
    var poster_path: String?
    var release_date: String?
    var overview: String?
    var vote_average: Double?
    var backdrop_path: String?
}

//Получение скриншотов
class AllScreens: Codable {
    var backdrops: [ScreensLink]
}

//линк для конкретнй картинки
class ScreensLink: Codable {
    var aspect_ratio: Double?
    var height: Int
    var file_path: String?
    var width: Int
}

/**/

class JSONModel: Codable {
    var original_title: String?
    var poster_path: String?
    var release_date: String?
    var overview: String?
    var vote_average: Double?
    var backdrop_path: String?
}

class TestModel {
    var testPic: String?
    var testTitle: String?
    var testYear: String?
    var testRating: String?
    
    init(testPic: String? = nil, testTitle: String? = nil, testYear: String? = nil, testRating: String? = nil) {
        self.testPic = testPic
        self.testTitle = testTitle
        self.testYear = testYear
        self.testRating = testRating
    }
}
