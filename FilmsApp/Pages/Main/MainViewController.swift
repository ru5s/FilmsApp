//
//  MainViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

import UIKit

class MainViewController: UIViewController {
    
    
    lazy var mainSearchBar: UISearchBar = {
        /* add search bar*/
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width - 20, height: 50))
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.backgroundColor = .systemBackground
        searchBar.placeholder = " Search film..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.layer.cornerRadius = 5
        
        searchBar.delegate = self
//        navigationItem.titleView = searchBar
        /* end*/

        return searchBar
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let countOfCell = 2
        let sizeToCell = (Int(UIScreen.main.bounds.width - 30) - (countOfCell * 10)) / countOfCell
        
        layout.itemSize = CGSize(width: sizeToCell, height: 350)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        cv.showsVerticalScrollIndicator = false
        cv.autoresizingMask = .flexibleHeight
        
        return cv
    }()
    
    let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        model.fetchDataFromApi(page: 2, requestOption: .upcoming) { bool in
            DispatchQueue.main.async {
                if bool == true {
                    self.collectionView.reloadData()
                    
                    self.model.arrayHelper = self.model.allFilms
                    
                    self.model.sortFilms()
                }
            }
        }
        
        view.addSubview(mainSearchBar)
        mainSearchBar.delegate = self
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.title = "Films app"
        
        let favoriteBarButtonItem = UIBarButtonItem(title: "Liked", style: .plain, target: self, action: #selector(openLikeFilms))
        favoriteBarButtonItem.image = UIImage(systemName: "heart.fill")
        let sortedButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up"), style: .plain, target: self, action: #selector(sortedFilms(sender:)))
        
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
        navigationItem.leftBarButtonItem = sortedButton
        
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.layoutMarginsGuide
        mainSearchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        mainSearchBar.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        mainSearchBar.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainSearchBar.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc private func sortedFilms(sender: UIBarButtonItem) {
        model.sortAscending.toggle()
        
        model.sortAscending ? (sender.image = UIImage(systemName: "arrow.down")) : (sender.image = UIImage(systemName: "arrow.up"))
        
        model.sortFilms()
        collectionView.reloadData()
    }
    
    @objc private func openDetailFilm(){
        let detailFilmVC = DetailFilmViewController()
        
        navigationController?.pushViewController(detailFilmVC, animated: true)
    }
    
    @objc private func openLikeFilms(){
        let favoriteFilms = FavoriteFilmsViewController()
        
        navigationController?.pushViewController(favoriteFilms, animated: true)
        
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.arrayHelper?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? FilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        DispatchQueue.main.async {
            
            cell.data = self.model.arrayHelper?[indexPath.item]
            self.model.checkLike(id: Int(self.model.arrayHelper?[indexPath.row].value(forKey: "id") as? Int32 ?? 0)) ? (cell.heartImage.tintColor = .red) : (cell.heartImage.tintColor = .gray)
        }
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tappedHeart(_ :)))
        cell.heartImage.isUserInteractionEnabled = true
        cell.heartImage.tag = Int(model.arrayHelper?[indexPath.row].value(forKey: "id") as? Int32 ?? 0)
        cell.heartImage.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func tappedHeart(_ sender: UITapGestureRecognizer) {
        
        let id = sender.view?.tag
        guard let id = id else {return}
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.2) {
                sender.view?.tintColor == .red ? (sender.view?.tintColor = .gray) : (sender.view?.tintColor = .red)
            }
            
            self.model.chooseFilm(id: id)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailedVC = DetailFilmViewController()
        
        detailedVC.data = model.arrayHelper?[indexPath.item]
        
        self.navigationController?.modalTransitionStyle = .partialCurl

        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
}

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
            model.sortFilms()
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //метод нажатия кнопки отмены
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.arrayHelper = model.allFilms
        
        model.sortFilms()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
