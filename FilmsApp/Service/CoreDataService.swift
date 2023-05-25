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
    
    func saveData(objects: MovieList, requestOtions: RequestOptions) {
        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Films", in: managedContext) else {return}
            
            guard let jsonFilms = objects.results else {return}
            
            for i in jsonFilms {
                
                guard let id = i.id else {return}
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Films")
                fetchRequest.predicate = NSPredicate(format: "id == %d", id)
                
                do {
                    
                    let result = try managedContext.fetch(fetchRequest) as [NSManagedObject]
                    
                    if result.count != 0 {
                        
                        guard let film = result.first else {return}
//                        print("film have been downloaded id - \(String(describing: i.id))")
                        
                        switch requestOtions {
                            
                        case .allMovie:
                            film.setValue(true, forKey: "popularType")
                        case .nowPlaying:
                            film.setValue(true, forKey: "nowPlayingType")
                        case .topRated:
                            film.setValue(true, forKey: "topRatedType")
                        case .upcoming:
                            film.setValue(true, forKey: "upcomingType")
                        }
                        
                        do {
                            
                            try managedContext.save()
                            
                        } catch let error as NSError {
                            
                            print("Could not fetch \(error), \(error.userInfo)")
                            
                        }
                        
                    } else {
                        let film = NSManagedObject(entity: entity, insertInto: managedContext)
                        
//                        print("first save film id \(String(describing: i.id))")
                        
                        film.setValue(i.id, forKey: "id")
                        film.setValue(i.overview, forKey: "about")
                        film.setValue([i.backdrop_path], forKey: "backdrop_path")
                        film.setValue(i.poster_path, forKey: "filmPic")
                        film.setValue(i.vote_average, forKey: "filmRating")
                        film.setValue(i.original_title, forKey: "filmTitle")
                        
                        let intFilmYear = Int(i.release_date?.prefix(4) ?? "") ?? 0000
                        film.setValue(intFilmYear, forKey: "filmYear")
                        film.setValue(false, forKey: "isLiked")
                        
                        switch requestOtions {
                        case .allMovie:
                            film.setValue(true, forKey: "popularType")
                        case .nowPlaying:
                            film.setValue(true, forKey: "nowPlayingType")
                        case .topRated:
                            film.setValue(true, forKey: "topRatedType")
                        case .upcoming:
                            film.setValue(true, forKey: "upcomingType")
                        }
                        
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
    
    func likedFilms(id: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Films> = Films.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        let result = try! managedContext.fetch(fetchRequest) as [Films]
        
        if let result = result.first{

            result.isLiked.toggle()

            do {
                
                try managedContext.save()
                
            } catch let error as NSError {
                
                print("Could not fetch \(error), \(error.userInfo)")
                
            }
        }
        
    }
    
    func checkLikedFilm(id: Int) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Films> = Films.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        let result = try! managedContext.fetch(fetchRequest) as [Films]
        
        if let result = result.first{
            if result.isLiked == true {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func sortFilms(sort: Bool = false, completition: @escaping ([NSManagedObject]?) -> ()){
        
        let arrayHelper: [NSManagedObject]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Films> = Films.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "filmRating", ascending: sort)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            
            arrayHelper = try managedContext.fetch(fetchRequest)
            
            completition(arrayHelper)
        } catch let error as NSError {
            print("sortFilms() error \(error)")
            completition(nil)
        }
        
    }
    
    func searchFilm(_ string: String) -> [NSManagedObject] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Films> = Films.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "filmTitle CONTAINS[c] %@", string)
        
        do {
            
            let searchResult = try managedContext.fetch(fetchRequest)
            return searchResult
            
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
        
    }
    
    func separateFavorites() -> [NSManagedObject]? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Films> = Films.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isLiked == %@", NSNumber(value: true))
        
        do {
            
            let searchResult = try managedContext.fetch(fetchRequest)

            return searchResult
            
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func saveScreenshotsLinks(allData: AllScreens, id: Int, completition: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Films> = Films.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            let result = try! managedContext.fetch(fetchRequest) as [Films]
            
            if let result = result.first{
                
                if result.backdrop_path?.count ?? 0 < 2 {
                    
                    for screen in allData.backdrops {
                        guard let path = screen.file_path else {return}
                        result.backdrop_path?.append(path)
                    }
                    
                    do {
                        
                        try managedContext.save()
                        completition()
                        
                    } catch let error as NSError {
                        
                        print("Could not fetch \(error), \(error.userInfo)")
                        
                    }
                }
                
                
            }
            
        }
        
        
    }
}
