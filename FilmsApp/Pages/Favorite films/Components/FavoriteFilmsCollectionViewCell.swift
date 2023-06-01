//
//  FavoriteFilmsCollectionViewCell.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 23/05/23.
//

import UIKit
import CoreData

class FavoriteFilmsCollectionViewCell: UICollectionViewCell {
    
    let posterPreviewImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemGray2
        image.layer.cornerRadius = 5
        
        return image
    }()
    
    let filmTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название фильма"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    let releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Год выпуска"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textColor = .systemGray
        
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Рейтинг"
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    let viewBelowRatinLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let model = Model()
    
    let heartImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "heart.fill")
        image.tintColor = .red
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    var data: NSManagedObject? {
        didSet {
            guard let unwrData = data else {return}
            
            if let film = unwrData as? Films {
                
                ratingLabel.text = String(film.filmRating)
                filmTitleLabel.text = film.filmTitle
                releaseYearLabel.text = String(film.filmYear)
                
                guard let filmUrl = film.filmPic else {return}
                model.getPoster(filmUrl) { image in
                    self.posterPreviewImageView.image = image
                }
                
            } else {return}
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(posterPreviewImageView)
        
        contentView.addSubview(heartImage)
        
        contentView.addSubview(filmTitleLabel)
        contentView.addSubview(releaseYearLabel)
        contentView.addSubview(viewBelowRatinLabel)
        viewBelowRatinLabel.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            posterPreviewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterPreviewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterPreviewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterPreviewImageView.heightAnchor.constraint(equalToConstant: 260),
            heartImage.topAnchor.constraint(equalTo: posterPreviewImageView.topAnchor, constant: 5),
            heartImage.trailingAnchor.constraint(equalTo: posterPreviewImageView.trailingAnchor, constant: -5),
            heartImage.widthAnchor.constraint(equalToConstant: 30),
            heartImage.heightAnchor.constraint(equalToConstant: 30),
            filmTitleLabel.topAnchor.constraint(equalTo: posterPreviewImageView.bottomAnchor, constant: 5),
            filmTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            filmTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            filmTitleLabel.bottomAnchor.constraint(equalTo: viewBelowRatinLabel.topAnchor, constant: -10),
            releaseYearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            releaseYearLabel.centerYAnchor.constraint(equalTo: viewBelowRatinLabel.centerYAnchor),
            viewBelowRatinLabel.widthAnchor.constraint(equalToConstant: 52),
            viewBelowRatinLabel.heightAnchor.constraint(equalToConstant: 40),
            viewBelowRatinLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//            viewBelowRatinLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            ratingLabel.centerXAnchor.constraint(equalTo: viewBelowRatinLabel.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: viewBelowRatinLabel.centerYAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
