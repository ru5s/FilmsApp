//
//  FilmPicsViewController.swift
//  FilmsApp
//
//  Created by Ruslan Ismailov on 06/02/23.
//

//import UIKit
//
//class FilmPicsViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        navigationItem.title = "Film pictures"
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openFullPic))
//    }
//
//    @objc private func openFullPic(){
//        let fullPicVC = FullPicViewController()
//
//        navigationController?.pushViewController(fullPicVC, animated: true)
//    }
//
//}

import UIKit

class FilmPicsViewController: UIViewController {
    let buttonStackView = UIStackView()
    let expandButton = UIButton()
    var expanded = false
    
    var expandBtnTitle: String = "Popular"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        buttonStackView.isHidden = true
        
        setupButtonStackView()
        setupExpandButton()
    }
    
    private func setupButtonStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 5
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.isHidden = expanded
        
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add your buttons to the stack view
        let button1 = UIButton()
        button1.setTitle("Popular", for: .normal)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitleColor(UIColor(named: "BlackWhiteColor"), for: .normal)
        button1.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button1.backgroundColor = UIColor(named: "navigatorColor")
        button1.layer.cornerRadius = 12
        button1.addTarget(self, action: #selector(btn1Touched), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button1)
        
        let button2 = UIButton()
        button2.setTitle("Now watching", for: .normal)
        button2.setTitleColor(UIColor(named: "BlackWhiteColor"), for: .normal)
        button2.setTitleColor(UIColor(named: "BlackWhiteColor"), for: .normal)
        button2.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button2.backgroundColor = UIColor(named: "navigatorColor")
        button2.layer.cornerRadius = 12
        button2.addTarget(self, action: #selector(btn2Touched), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button2)
        
        let button3 = UIButton()
        button3.setTitle("Top rating", for: .normal)
        button3.setTitleColor(UIColor(named: "BlackWhiteColor"), for: .normal)
        button3.setTitleColor(UIColor(named: "BlackWhiteColor"), for: .normal)
        button3.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button3.backgroundColor = UIColor(named: "navigatorColor")
        button3.layer.cornerRadius = 12
        button3.addTarget(self, action: #selector(btn3Touched), for: .touchUpInside)
        buttonStackView.addArrangedSubview(button3)
    }
    
    @objc private func btn1Touched() {
        DispatchQueue.main.async {
            self.expandBtnTitle = "Popular"
            self.expandButton.setTitle(self.expandBtnTitle, for: .normal)
            self.expandButton.setTitle(self.expandBtnTitle, for: .selected)
            self.buttonStackView.isHidden.toggle()
            self.expandButton.isSelected.toggle()
            self.expanded.toggle()
        }
    }
    
    @objc private func btn2Touched() {
        DispatchQueue.main.async {
            self.expandBtnTitle = "Now watching"
            self.expandButton.setTitle(self.expandBtnTitle, for: .normal)
            self.expandButton.setTitle(self.expandBtnTitle, for: .selected)
            self.buttonStackView.isHidden.toggle()
            self.expandButton.isSelected.toggle()
            self.expanded.toggle()
        }
    }
    
    @objc private func btn3Touched() {
        DispatchQueue.main.async {
            self.expandBtnTitle = "Top rating"
            self.expandButton.setTitle(self.expandBtnTitle, for: .normal)
            self.expandButton.setTitle(self.expandBtnTitle, for: .selected)
            self.buttonStackView.isHidden.toggle()
            self.expandButton.isSelected.toggle()
            self.expanded.toggle()
        }
    }
    
    private func setupExpandButton() {
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.setTitle("Popular", for: .normal)
        expandButton.setTitle(expandBtnTitle, for: .selected)
        
        expandButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        expandButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        expandButton.layer.cornerRadius = 12
        
        expandButton.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        expandButton.backgroundColor = UIColor(named: "navigatorColor")
        expandButton.setTitleColor(.black, for: .normal)
        expandButton.setTitleColor(.white, for: .selected)
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
        view.addSubview(expandButton)
        
        NSLayoutConstraint.activate([
            expandButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            expandButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            expandButton.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16)
        ])
    }
    
    @objc private func expandButtonTapped() {
        expanded = !expanded
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7) {
                self.buttonStackView.isHidden = !self.expanded
                self.expandButton.isSelected = self.expanded
                self.view.layoutIfNeeded()
            }
        }
    }

}
