//
//  MainSearchExtension.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 29/05/23.
//

import UIKit

extension MainViewController: UISearchBarDelegate{
    
    //работа со строкой поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        canUpdateInBottomCollection = false
        
        model.arrayHelper = model.allFilms
        
        model.searchFilm(query: searchText)
        
        if searchText.isEmpty {
            canUpdateInBottomCollection = true
            model.arrayHelper = model.allFilms
            model.sortFilms(sortType)
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //метод нажатия кнопки отмены
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.arrayHelper = model.allFilms
        
        model.sortFilms(sortType)
        
        canUpdateInBottomCollection = true
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
