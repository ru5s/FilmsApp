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
        
        //приравнивание вспомогательного массива к массиву всех фильмов что есть в базе
        model.arrayHelper = model.allFilms
        
        //запус метода поиска по введенному тексту
        model.searchFilm(query: searchText)
        
        //если поисковая строка пустая то производить обратное приравнивание и сортировку
        if searchText.isEmpty {
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
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
