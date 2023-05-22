//
//  CoreDataService.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 21/05/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    var films: [NSManagedObject] = {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Films")
        
        guard var result = try? managedContext.fetch(fetchRequest) else {return []}
        
        return result
        
    }()
    
    enum MainOrFavoriteFilms {
        case allFilms
        case favoriteFilms
    }
    
    func saveData(objects: MovieList, kind: MainOrFavoriteFilms) {
        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Films", in: managedContext) else {return}
            
            guard let jsonFilms = objects.results else {return}
            
            for i in jsonFilms {
                
                guard let id = i.id else {return}
                
                let film = NSManagedObject(entity: entity, insertInto: managedContext)
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Films")
                fetchRequest.predicate = NSPredicate(format: "id == %d", id)
                
                do {
                    
                    let result = try managedContext.fetch(fetchRequest)
                    
                    if let existingFilm = result.first {
                        
                        print("film always download")
                        
                    } else {
                        film.setValue(i.id, forKey: "id")
                        film.setValue(i.overview, forKey: "about")
                        film.setValue([i.backdrop_path], forKey: "backdrop_path")
                        film.setValue(i.poster_path, forKey: "filmPic")
                        film.setValue(i.vote_average, forKey: "filmRating")
                        film.setValue(i.original_title, forKey: "filmTitle")
                        
                        let intFilmYear = Int(i.release_date?.prefix(4) ?? "") ?? 0000
                        film.setValue(intFilmYear, forKey: "filmYear")
                        film.setValue(false, forKey: "isLiked")
                        
                        
                        do {
                            
                            try managedContext.save()
                            self.films.append(film)
                            
                        } catch let error as NSError {
                            
                            print("Could not fetch \(error), \(error.userInfo)")
                            
                        }
                    }
                    
                    
                } catch let error as NSError {
                    
                    print("Could not fetch \(error), \(error.userInfo)")
                }
                
                
                
            }
            
            
        }
        
        
    }
    
    func fetchData() -> [NSManagedObject] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Films")
        
        guard let result = try? managedContext.fetch(fetchRequest) else {return []}
        
        return result
    }
    
    func editFilms(id: Int) {
        
    }
    
}
