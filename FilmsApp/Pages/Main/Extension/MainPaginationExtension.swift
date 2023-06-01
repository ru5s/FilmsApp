//
//  MainPaginationExtension.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 30/05/23.
//

import Foundation
import UIKit


extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let result = scrollOffset + scrollHeight >= contentHeight
        
        if result {
            switch sortType {
            case .allMovie:
                pagination(type: .allMovie, userDefaultsKey: "Popular")
            case .nowPlaying:
                pagination(type: .nowPlaying, userDefaultsKey: "NowPlaying")
            case .topRated:
                pagination(type: .topRated, userDefaultsKey: "TopRated")
            case .upcoming:
                pagination(type: .upcoming, userDefaultsKey: "Upcoming")
            }
        }
        
    }
    
    private func pagination(type: RequestOptions, userDefaultsKey: String) {
        let savePage = UserDefaults.standard.integer(forKey: userDefaultsKey)
        
        pagePopular = savePage + 1
        
        if savePage.words.isEmpty {
            pagePopular += 1
        }
        
        print("++ page is in \(userDefaultsKey) = \(pagePopular)")
        
        model.fetchDataFromApi(page: pagePopular, requestOption: type) { bool in
            
            DispatchQueue.main.async {
                
                if bool == true {
                    
                    self.collectionView.reloadData()
                    
                    self.model.arrayHelper = self.model.allFilms
                    
                    self.model.separateByTypeRequest(request: type)
                    
                    UserDefaults.standard.set(self.pagePopular, forKey: userDefaultsKey)
                    
                }else{
                    
                    let alert = UIAlertController()
                    
                    let alertAction = UIAlertAction(title: "Not connection", style: .cancel)
                    
                    alert.addAction(alertAction)
                    
                    self.present(alert, animated:  true)
                    
                    self.model.separateByTypeRequest(request: type)
                    
                    self.collectionView.reloadData()
                    
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
                }
            }
            
        }
        
    }
    
}


