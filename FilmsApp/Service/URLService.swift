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
enum RequestOptions: String {
    case allMovie = "popular"
    case latest = "latest"
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
    func dataRequest(page: Int = 1, requestOptions: RequestOptions = .allMovie, completition: @escaping (Error?, MovieList?) -> ()) {
        
        var page = "&page=\(page)"
        
        requestOptions == .latest ? (page = "") : (page = "page=\(page)")
        
        guard let apiUrl: URL = URL(string: "\(adress)3/movie/\(requestOptions.rawValue)?\(apiKey)&language=en-US&\(page)") else { return }
        
        let task = session.dataTask(with: apiUrl) { data, response, error in
            
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                completition(error, nil)
                return
            }
            do {
                
                let json = try JSONDecoder().decode(MovieList.self, from: unwrData)
                
                completition(nil, json)
                
            } catch let error {
                
                print("task error \(error)")
            }
            
            
//            print("++ data - \(unwrData.count)")
//            let sha256 = SHA256.hash(data: unwrData)
//            print("++ hashValue - \(sha256)")
            
//            DispatchQueue.main.async {
//                //отправка данных в парсер с сохранением всего в базу данных и получение ответа при достижении результата
//                self.parser.parseJSON(parseData: unwrData, parseError: error, type: requestOptions.rawValue, completition: { bool in
//
//                    //если результат пришел то отправить сигнал
//                    if bool == true {
//                        completition(true)
//                    }
//                })
//            }
            
            
        }
        task.resume()
    }
    
    //метод получения скриншотов по id фильма
    func getScreenshots(_ filmId: Int, completition: @escaping (Error?, Data?) -> Void) {
        
        let assetAdress: String = "https://api.themoviedb.org/3/movie/"
        
        guard let assetApiUrl: URL = URL(string: "\(assetAdress)\(filmId)/images?\(apiKey)") else {return}
        
        let task = session.dataTask(with: assetApiUrl) {data, response, error in
            
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                completition(error, nil)
                return
            }
            completition(nil, unwrData)
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
    func getSetPoster(withUrl url: URL, comletition: @escaping (UIImage) -> Void) {
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



