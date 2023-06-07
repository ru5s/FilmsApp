//
//  FilmPicsViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//


import UIKit

class FilmPicsViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "galleryImage")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .systemBackground
        cv.collectionViewLayout = layout
        
        cv.isPagingEnabled = true
        
        return cv
    }()
    
    let currentNumberImage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = .white
        label.numberOfLines = 1
        
        return label
    }()
    
    let rightBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    let leftBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    let model = Model()
    
    var curentFilm: Films?
    
    var indexFilm: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollToImage()
        
        view.backgroundColor = .black
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .black
        
        view.addSubview(collectionView)
        view.addSubview(currentNumberImage)
        view.addSubview(rightBtn)
        view.addSubview(leftBtn)
        
        rightBtn.addTarget(self, action: #selector(rightBtnTapped), for: .touchUpInside)
        
        leftBtn.addTarget(self, action: #selector(leftBtnTapped), for: .touchUpInside)
        
        currentNumberImage.text = indexFilm == 0 ? "0 / \(curentFilm?.backdrop_path?.count ?? 0)" : "\((indexFilm ?? 0) + 1) / \(curentFilm?.backdrop_path?.count ?? 0)"
        
        collectionView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        let safeZone = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.topAnchor.constraint(equalTo: safeZone.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeZone.bottomAnchor),
            currentNumberImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentNumberImage.bottomAnchor.constraint(equalTo: safeZone.bottomAnchor, constant: -20),
            rightBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            rightBtn.topAnchor.constraint(equalTo: collectionView.topAnchor),
            rightBtn.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            rightBtn.widthAnchor.constraint(equalToConstant: view.bounds.width / 6),
            leftBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            leftBtn.topAnchor.constraint(equalTo: collectionView.topAnchor),
            leftBtn.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            leftBtn.widthAnchor.constraint(equalToConstant: view.bounds.width / 6),
        ])
    }
    
    private func scrollToImage() {
        guard let indexFilm = indexFilm else {return}
        
        if indexFilm != 0 {
            let indexPath = IndexPath(item: indexFilm, section: 0)
            
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc private func rightBtnTapped() {
        if indexFilm != (curentFilm?.backdrop_path?.count ?? 0) - 1 {
            indexFilm = (indexFilm ?? 0) + 1
            let indexPath = IndexPath(item: indexFilm ?? 0, section: 0)
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc private func leftBtnTapped() {
        if indexFilm != 0 {
            indexFilm = (indexFilm ?? 0) - 1
            let indexPath = IndexPath(item: indexFilm ?? 0, section: 0)
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.collectionView.reloadData()
            }
        }
    }
}

extension FilmPicsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curentFilm?.backdrop_path?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryImage", for: indexPath)
        
        cell.backgroundColor = .black
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
        
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
        cell.addSubview(image)
        
        image.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        
        model.getPoster(curentFilm?.backdrop_path?[indexPath.row] ?? "", completiton: { testimage in
            image.image = testimage
        })
        
        return cell
    }
    
    
}

extension FilmPicsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let centerIndexPath = centeredIndexPath(in: collectionView)
        
        if let indexPath = centerIndexPath {
            
            let centeredItemIndex = indexPath.item
            
            currentNumberImage.text = "\(centeredItemIndex + 1) / \(curentFilm?.backdrop_path?.count ?? 0)"
            indexFilm = centeredItemIndex
        }
    }
    
    func centeredIndexPath(in collectionView: UICollectionView) -> IndexPath? {
        let centerPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2, y: collectionView.contentOffset.y + collectionView.bounds.height/2)
        
        return collectionView.indexPathForItem(at: centerPoint)
    }
}

extension FilmPicsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
}
