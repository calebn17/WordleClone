//
//  ViewController.swift
//  WordleClone
//
//  Created by Caleb Ngai on 3/31/22.
//

import UIKit

class ViewController: UIViewController {
    
    let answer = "after"
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count:6)
    
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        
        addChildren()
    }
    
    private func addChildren() {
        
        //adding keyboard and board view controllers as childeren to the home view controller
        //all these steps are needed to embed one VC to the parent VC
        
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        //tells code to not set automatic constraints
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.datasource = self
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            

            
        ])
    }


}

extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        
        var stop = false
        
        for i in 0 ..< guesses.count {
            for j in 0 ..< guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {break}
        }
    
        
        boardVC.reloadData()
    }
}

extension ViewController: BoardViewControllerDatasoure {
    var currentGuesses: [[Character?]] {
        return guesses
    }
}

