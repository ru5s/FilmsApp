//
//  URLService.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 21/05/23.
//

import Foundation
import UIKit
import CryptoKit

//все возможные варинаты запроса в апи (в приложении используется только 3)
enum RequestOptions: String, CaseIterable {
    case allMovie = "popular"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    
}

//менеджер работы с апи
class URLService {
    
    let adress: String = "https://api.themoviedb.org/"
    
    let apiKey: String = "api_key=f4da188878dec2aea2a0e9db582199b5"
    
    let session = URLSession.shared
    
    var imageCache = NSCache <NSString, UIImage>()
    
    //запрос к апи на получения списка фильмов со сбегающим булевым замыканием на окончание процесса
    func dataRequest(page: Int, requestOptions: RequestOptions, completition: @escaping (Error?, MovieList?) -> ()) {
        
        let page = "&page=\(page)"
        
        guard let apiUrl: URL = URL(string: "\(adress)3/movie/\(requestOptions.rawValue)?\(apiKey)&language=en-US&\(page)") else { return }
        
        let task = session.dataTask(with: apiUrl) { data, response, error in
            
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                print("nil")
                completition(error, nil)
                return
            }
            
            do {
                
                let json = try JSONDecoder().decode(MovieList.self, from: unwrData)
                
                completition(nil, json)
                
            } catch let error {
                
                print("task error \(error)")
            }
            
        }
        task.resume()
    }
    
    //метод получения скриншотов по id фильма
    func getScreenshots(_ filmId: Int, completition: @escaping (Error?, AllScreens?) -> Void) {
        //общая часть url запроса
        let assetAdress: String = "https://api.themoviedb.org/3/movie/"
        //полный url с проверкой состояния
        guard let assetApiUrl: URL = URL(string: "\(assetAdress)\(filmId)/images?\(apiKey)") else {return}
        //создание задачи
        let task = session.dataTask(with: assetApiUrl) {data, response, error in
            //проверка данных с проверкой статус кода
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                completition(error, nil)
                return
            }
            
            let json = try! JSONDecoder().decode(AllScreens.self, from: unwrData)
            
            completition(nil, json)
            //отправка данных в парсер для сохранения линков в конкретный фильм в базе данных
//            self.parser.parseLinkToScreenshots(parseData: unwrData, parseError: error, id: filmId, completition: { error in
//                if let error = error {
//                    completition(error)
//                } else {
//                    completition(nil)
//                }
//            })
            
        }
        task.resume()
    }
    
    //метод скачивания и кэширования картинок
    func getSetPoster(withUrl partOfUrl: String, comletition: @escaping (UIImage) -> Void) {
        let imageAdress = "https://image.tmdb.org/t/p/w500/"
        
        let url = URL(string: imageAdress + partOfUrl)
        guard let url = url else {return}
        //проверка есть ли картинка в кэшах по средствам отправки в него ключа в виде полного url картинки
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            //если есть то отправить в сбегающее замыкание картинку
            comletition(cachedImage)
        } else {
            //иначе создать запрос с сохранением картинки в кэш
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
            //задача на скачивание данных
            let downloadingTask = session.dataTask(with: request) {[weak self] data, response, error in
                //проверка на ошибку, данных, проверки статус кода, и самого себя
                guard error == nil,
                let unwrData = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let self = self else {
                    return
                }
                
                //проверка на то что пришла картинка
                guard let image = UIImage(data: unwrData) else {
                    return
                }
                //сохраниение картинки в кэш
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    //отправка картинки через сбегающее замыкание
                    comletition(image)
                }
                
            }
            
            downloadingTask.resume()
        }
        
    }
    
}



