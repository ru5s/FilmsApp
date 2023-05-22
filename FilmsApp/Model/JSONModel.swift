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


var testArray: [TestModel] = [
    TestModel(testPic: "1", testTitle: "Доктор сон", testYear: "2000", testRating: "7.8"),
    TestModel(testPic: "2", testTitle: "1408", testYear: "1999", testRating: "8.0"),
    TestModel(testPic: "3", testTitle: "Долорес Клейборн", testYear: "1991", testRating: "6.7"),
    TestModel(testPic: "4", testTitle: "Кладбище домашних животных", testYear: "2001", testRating: "8.2"),
    TestModel(testPic: "5", testTitle: "Дети кукурузы", testYear: "1996", testRating: "7.9"),
    TestModel(testPic: "6", testTitle: "Мизери", testYear: "1989", testRating: "7.3"),
    TestModel(testPic: "1", testTitle: "Доктор сон", testYear: "2000", testRating: "7.8"),
    TestModel(testPic: "2", testTitle: "1408", testYear: "1999", testRating: "8.0"),
    TestModel(testPic: "3", testTitle: "Долорес Клейборн", testYear: "1991", testRating: "6.7"),
    TestModel(testPic: "4", testTitle: "Кладбище домашних животных", testYear: "2001", testRating: "8.2"),
    TestModel(testPic: "5", testTitle: "Дети кукурузы", testYear: "1996", testRating: "7.9"),
    TestModel(testPic: "6", testTitle: "Мизери", testYear: "1989", testRating: "7.3"),
]

var bigTextTemp: String = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32."
 /**/
