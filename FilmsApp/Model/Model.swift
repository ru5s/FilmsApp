//
//  Model.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 22/05/23.
//

import Foundation
import CoreData
import UIKit

class Model {
    
    let urlService = URLService()
    let coreDataService = CoreDataService()
    
    var allFilms: [NSManagedObject] {
        return coreDataService.films
    }
    
    var sortAscending: Bool = false
    
    var arrayHelper: [NSManagedObject]?
    var arrayFavoritesFilms: [NSManagedObject]?
    
    func fetchDataFromApi(page: Int, requestOption: RequestOptions, completition: @escaping (Bool) -> ()) {
        
        urlService.dataRequest(page: page, requestOptions: requestOption) { error, movieList in
            
            guard let movieList = movieList else {return}
            
            print("++ json data count \(String(describing: movieList.results?.count))")
            
            if error == nil {
                self.coreDataService.saveData(objects: movieList, requestOtions: requestOption)
                completition(true)
            } else {
                print("coreDataService.saveData error \(String(describing: error))")
                completition(false)
            }
                
        }
        
    }
    
    func sortFilms() {
        coreDataService.sortFilms(sort: sortAscending) { films in
            self.arrayHelper = films
        }
    }
    
    func searchFilm(query: String) {
        arrayHelper = coreDataService.searchFilm(query)
    }
    
    func chooseFilm(id: Int) {
        coreDataService.likedFilms(id: id)
    }
    
    func checkLike(id: Int) -> Bool {
        return coreDataService.checkLikedFilm(id: id)
    }
    
    func favoritesFilms() {
        arrayFavoritesFilms = coreDataService.separateFavorites()
    }
    
    func deleteLikedArrayByIndex(index: Int) {
        arrayFavoritesFilms?.remove(at: index)
    }
    
    func getPoster(_ partOfUrl: String, completiton: @escaping (UIImage) -> Void) {
        urlService.getSetPoster(withUrl: partOfUrl) { image in
            completiton(image)
        }
    }
    
    func getScreenshots(id: Int, completition: @escaping () -> Void) {
        urlService.getScreenshots(id) { error, data in
            guard let unwrdata = data,
            error == nil else {return}
            
            self.coreDataService.saveScreenshotsLinks(allData: unwrdata, id: id) {
                completition()
            }
        }
    }
}
