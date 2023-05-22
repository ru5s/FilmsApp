//
//  Model.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 22/05/23.
//

import Foundation
import CoreData

class Model {
    
    let urlService = URLService()
    let coreDataService = CoreDataService()
    
    var allFilms: [NSManagedObject] {
        return coreDataService.films
    }
    
    var arrayHelper: [NSManagedObject]?
    
    func fetchDataFromApi() {
        
        urlService.dataRequest(page: 1, requestOptions: .allMovie) { error, movieList in
            
            guard let movieList = movieList else {return}
            
            print("++ json data count \(String(describing: movieList.results?.count))")
            
            self.coreDataService.saveData(objects: movieList, kind: .allFilms)
            
        }
        
    }
}
