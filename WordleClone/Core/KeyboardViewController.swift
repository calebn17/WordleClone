//
//  KeyboardViewController.swift
//  WordleClone
//
//  Created by Caleb Ngai on 3/31/22.
//

import UIKit

protocol KeyboardViewControllerDelegate: AnyObject {
    //stubs the function that will pass the letter from the keyboard vc to the main vc
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character)
}

class KeyboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: KeyboardViewControllerDelegate?
    
    let letters = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    private var keys: [[Character]] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //spacing between each item
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //registering the Key cells to the collectionView
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //always need this when using collection/table views etc!!
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        //parses out the letters array and arranges it into a 2x2 array format resembling a keyboard
        for row in letters {
            //seperates each string into an array
            let chars = Array(row)
            //adds that array to the keys 2D array
            keys.append(chars)
        }
    }
}

extension KeyboardViewController {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //creates a reusable cell that is casted as a KeyCell that we created
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {fatalError()}
        
        //places the letter from the corresponding keys array into the cell and formats it as defined by KeyCell
        let letter = keys[indexPath.section][indexPath.row]
        cell.configure(with: letter)
        
        return cell
    }
    
    //sets the size for each cell/item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width - margin)/10
        
        return CGSize(width: size, height: size * 1.5)
    }
    
    //manages the inset of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var left: CGFloat = 1
        var right:CGFloat = 1
        
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width - margin)/10
        
        let count = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let inset: CGFloat = (collectionView.frame.size.width - (size * count) - (2 * count))/2
        
        left = inset
        right = inset
        
        return UIEdgeInsets(top: 2, left: left, bottom: 2, right: right)
    }
    
    //what happens when the user clicks on a cell in the keyboard
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //grabs the letter in the cell that the user clicked
        let letter = keys[indexPath.section][indexPath.row]
        //passes that letter over to the VC
        delegate?.keyboardViewController(self, didTapKey: letter)
    }
}
