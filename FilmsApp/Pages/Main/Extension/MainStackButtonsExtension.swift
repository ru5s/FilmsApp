//
//  MainStackButtonsExtension.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 29/05/23.
//

import UIKit

extension MainViewController {
    
    func setupExpandButton() {
        getTypeRequestBtn.translatesAutoresizingMaskIntoConstraints = false
        getTypeRequestBtn.setTitle("Popular", for: .normal)
        getTypeRequestBtn.setTitle(expandBtnTitle, for: .selected)
        
        getTypeRequestBtn.layer.cornerRadius = 12
        
        getTypeRequestBtn.backgroundColor = UIColor(named: "navigatorColor")
        getTypeRequestBtn.setTitleColor(.white, for: .normal)
        getTypeRequestBtn.setTitleColor(.white, for: .selected)
        
        getTypeRequestBtn.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        getTypeRequestBtn.layer.shadowColor = UIColor.black.cgColor
        getTypeRequestBtn.layer.shadowOpacity = 0.5
        getTypeRequestBtn.layer.shadowRadius = 10
        
        getTypeRequestBtn.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func expandButtonTapped() {
        openStackBool = !openStackBool
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7) {
                self.buttonStackView.isHidden = !self.openStackBool
                self.getTypeRequestBtn.isSelected = self.openStackBool
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setupButtonStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 5
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        var button1 = UIButton()
        button1 = setPropToStack(button: button1, title: "Popular")
        button1.addTarget(self, action: #selector(popularBtnTouched), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button1)
        
        var button2 = UIButton()
        button2 = setPropToStack(button: button2, title: "Now watching")
        button2.addTarget(self, action: #selector(nowWatchingBtnTouched), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button2)
        
        var button3 = UIButton()
        button3 = setPropToStack(button: button3, title: "Top rating")
        button3.addTarget(self, action: #selector(topRatingBtnTouched), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button3)
        
        var button4 = UIButton()
        button4 = setPropToStack(button: button4, title: "Upcoming")
        button4.addTarget(self, action: #selector(upcomingBtnTouched), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button4)
    }
    
    private func setPropToStack(button: UIButton, title: String) -> UIButton {
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "navigatorColor")
        button.layer.cornerRadius = 12
        
        return button
    }
    
    @objc private func popularBtnTouched() {
        DispatchQueue.main.async {
            self.expandBtnTitle = "Popular"
            self.navigationItem.title = self.expandBtnTitle
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .normal)
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .selected)
            self.buttonStackView.isHidden.toggle()
            self.getTypeRequestBtn.isSelected.toggle()
            self.openStackBool.toggle()
        }
        sortType = .allMovie
        model.fetchDataFromApi(page: 1, requestOption: .allMovie) { bool in
            DispatchQueue.main.async {
                if bool == false {
                    
                    let alert = UIAlertController()
                    
                    let alertAction = UIAlertAction(title: "Not connection", style: .cancel)
                    alert.addAction(alertAction)
                    self.present(alert, animated:  true)
                    
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
                }
                self.model.arrayHelper = self.model.allFilms
                
                self.model.separateByTypeRequest(request: .allMovie)
                
                self.model.sortFilms(self.sortType)
                
                self.collectionView.reloadData()
                
                self.collectionView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    @objc private func nowWatchingBtnTouched() {
        DispatchQueue.main.async {
            self.expandBtnTitle = "Now watching"
            self.navigationItem.title = self.expandBtnTitle
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .normal)
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .selected)
            self.buttonStackView.isHidden.toggle()
            self.getTypeRequestBtn.isSelected.toggle()
            self.openStackBool.toggle()
        }
        sortType = .nowPlaying
        model.fetchDataFromApi(page: pageWatching, requestOption: .nowPlaying) { bool in
            DispatchQueue.main.async {
                if bool == false {
                    let alert = UIAlertController()
                    
                    let alertAction = UIAlertAction(title: "Not connection", style: .cancel)
                    alert.addAction(alertAction)
                    self.present(alert, animated:  true)
                    
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
                }
                
                self.model.arrayHelper = self.model.allFilms
                
                self.model.separateByTypeRequest(request: .nowPlaying)
                
                self.model.sortFilms(self.sortType)
                
                self.collectionView.reloadData()
                
                self.collectionView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    @objc private func topRatingBtnTouched() {
        DispatchQueue.main.async {
            self.expandBtnTitle = "Top rating"
            self.navigationItem.title = self.expandBtnTitle
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .normal)
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .selected)
            self.buttonStackView.isHidden.toggle()
            self.getTypeRequestBtn.isSelected.toggle()
            self.openStackBool.toggle()
        }
        sortType = .topRated
        model.fetchDataFromApi(page: pageTopRated, requestOption: .topRated) { bool in
            DispatchQueue.main.async {
                if bool == false {
                    
                    let alert = UIAlertController()
                    
                    let alertAction = UIAlertAction(title: "Not connection", style: .cancel)
                    alert.addAction(alertAction)
                    self.present(alert, animated:  true)
                    
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
                }
                
                self.model.arrayHelper = self.model.allFilms
                
                self.model.separateByTypeRequest(request: .topRated)
                
                self.model.sortFilms(self.sortType)
                
                self.collectionView.reloadData()
                
                self.collectionView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    @objc private func upcomingBtnTouched() {
        DispatchQueue.main.async {
            self.expandBtnTitle = "Upcoming"
            self.navigationItem.title = self.expandBtnTitle
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .normal)
            self.getTypeRequestBtn.setTitle(self.expandBtnTitle, for: .selected)
            self.buttonStackView.isHidden.toggle()
            self.getTypeRequestBtn.isSelected.toggle()
            self.openStackBool.toggle()
        }
        sortType = .upcoming
        model.fetchDataFromApi(page: pageUpcoming, requestOption: .upcoming) { bool in
            DispatchQueue.main.async {
                if bool == false {
                    let alert = UIAlertController()
                    
                    let alertAction = UIAlertAction(title: "Not connection", style: .cancel)
                    alert.addAction(alertAction)
                    self.present(alert, animated:  true)
                    
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
                }
                
                self.model.arrayHelper = self.model.allFilms
                
                self.model.separateByTypeRequest(request: .upcoming)
                
                self.model.sortFilms(self.sortType)
                
                self.collectionView.reloadData()
                
                self.collectionView.setContentOffset(.zero, animated: true)
            }
        }
    }
}

