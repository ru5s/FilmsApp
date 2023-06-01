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
    
    func haveDataInDataBase(type: RequestOptions) -> Bool {
        var boolState: Bool = false
        
        coreDataService.avialabilityObjectInDBbyType(type: type) { bool in
            if bool == true {
                boolState = true
            } else {
                boolState = false
            }
        }
        return boolState
    }
    
    func fetchDataFromApi(page: Int, requestOption: RequestOptions, completition: @escaping (Bool) -> ()) {
        
        urlService.dataRequest(page: page, requestOptions: requestOption) { error, movieList in
            
            if error != nil {
                print("second nil")
                print("coreDataService.saveData error \(String(describing: error))")
                completition(false)
            }
            
            guard let movieList = movieList else {return}
            
            if error == nil {
                print("second not nil")
                self.coreDataService.saveData(objects: movieList, requestOtions: requestOption)
                completition(true)
            }
            
                
        }
        
    }
    
    func sortFilms(_ typeRequest: RequestOptions) {
        coreDataService.sortFilms(sort: sortAscending, type: typeRequest) { films in
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
    
    func separateByTypeRequest(request: RequestOptions) {
        arrayHelper = coreDataService.separateByType(type: request)
    }
}
