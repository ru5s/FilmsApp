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
        
//        cv.isPagingEnabled = true
        
        return cv
    }()
    
    var sortType: RequestOptions = .allMovie
    var pagePopular: Int = UserDefaults.standard.integer(forKey: "Pop")
    var pageTopRated: Int = 1
    var pageWatching: Int = 1
    var pageUpcoming: Int = 1
    
    let buttonStackView = UIStackView()
    let getTypeRequestBtn = UIButton()
    var openStackBool = false
    var expandBtnTitle: String = "Popular"
    
    var canUpdateInBottomCollection: Bool = true
    
    let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        checkDB()
        
        model.fetchDataFromApi(page: pagePopular, requestOption: .allMovie) { bool in
            DispatchQueue.main.async {
                if bool == true {
                    self.collectionView.reloadData()
                    
                    self.model.arrayHelper = self.model.allFilms
                    
                    self.model.separateByTypeRequest(request: .allMovie)
                }else{
                    
                    let alert = UIAlertController()
                    
                    let alertAction = UIAlertAction(title: "Not connection", style: .cancel)
                    
                    alert.addAction(alertAction)
                    self.present(alert, animated:  true)
                    
                    self.model.separateByTypeRequest(request: .allMovie)
                    self.collectionView.reloadData()
                }
                
            }
        }
        
        view.addSubview(mainSearchBar)
        mainSearchBar.delegate = self
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupButtonStackView()
        setupExpandButton()
        
        buttonStackView.isHidden = true
        view.addSubview(getTypeRequestBtn)
        view.addSubview(buttonStackView)
        navigationItem.title = "Popular"
        
        let favoriteBarButtonItem = UIBarButtonItem(title: "Liked", style: .plain, target: self, action: #selector(openLikeFilms))
        favoriteBarButtonItem.image = UIImage(systemName: "heart.fill")
        let sortedButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up"), style: .plain, target: self, action: #selector(sortedFilms(sender:)))
        
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
        navigationItem.leftBarButtonItem = sortedButton
        
        collectionView.reloadData()
    }
    
    private func checkDB() {
        
        for case let typeIterable in RequestOptions.allCases {
            
            switch typeIterable {
                
            case .allMovie:
                if model.haveDataInDataBase(type: .allMovie) == false {
                    UserDefaults.standard.set(1, forKey: "Popular")
                }
            case .nowPlaying:
                if model.haveDataInDataBase(type: .nowPlaying) == false {
                    UserDefaults.standard.set(1, forKey: "NowPlaying")
                }
            case .topRated:
                if model.haveDataInDataBase(type: .topRated) == false {
                    UserDefaults.standard.set(1, forKey: "TopRated")
                }
            case .upcoming:
                if model.haveDataInDataBase(type: .upcoming) == false {
                    UserDefaults.standard.set(1, forKey: "Upcoming")
                }
            }
        }
        
        
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
            getTypeRequestBtn.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50),
            getTypeRequestBtn.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            getTypeRequestBtn.heightAnchor.constraint(equalToConstant: 35),
            getTypeRequestBtn.widthAnchor.constraint(equalToConstant: view.bounds.width / 3),
            buttonStackView.bottomAnchor.constraint(equalTo: getTypeRequestBtn.topAnchor, constant: -10),
            buttonStackView.widthAnchor.constraint(equalToConstant: view.bounds.width / 3),
            buttonStackView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @objc private func sortedFilms(sender: UIBarButtonItem) {
        model.sortAscending.toggle()
        
        model.sortAscending ? (sender.image = UIImage(systemName: "arrow.down")) : (sender.image = UIImage(systemName: "arrow.up"))
        
        model.sortFilms(sortType)
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
