//
//  BoardViewController.swift
//  WordleClone
//
//  Created by Caleb Ngai on 3/31/22.
//

import UIKit

protocol BoardViewControllerDatasoure: AnyObject {
    //will pass the characters/cells that the user clicked to the main VC
    //is a get, so will return ...
    var currentGuesses: [[Character?]] {get}
}

class BoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var datasource: BoardViewControllerDatasoure?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
        ])
        
        
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

extension BoardViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //returns number of sections or 0 when there arent any
        return datasource?.currentGuesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if there is anything in the section then return the count, else will be zero
        let guesses = datasource?.currentGuesses ?? []
        return guesses[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {fatalError()}
        
        //formatting cells
        cell.backgroundColor = nil
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        
        //grabbing the guesses array and pulling the letter that is in the corresponding...
        //location and placing it in the cell
        let guesses = datasource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row] {
            cell.configure(with: letter)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //setting the size of the individual cell
        //margin is the total space per row that isnt occupied by the cell
        let margin: CGFloat = 20
        //calculates the width of the cell
        let size: CGFloat = (collectionView.frame.size.width - margin)/5
        //cells are sqaures so width and height are the same
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //sets the insets
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }

}
