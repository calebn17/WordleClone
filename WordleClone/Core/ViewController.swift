//
//  ViewController.swift
//  WordleClone
//
//  Created by Caleb Ngai on 3/31/22.
//

import UIKit

class ViewController: UIViewController {
    
    let answers = ["there", "ultra", "bloke", "later"]
    var answer = ""
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count:6)
    
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        answer = answers.randomElement() ?? "after"
        
        addChildren()
    }
    
    private func addChildren() {
        
        //adding keyboard and board view controllers as childeren to the home view controller
        //all these steps are needed to embed one VC to the parent VC
        
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        //tells code to not set automatic constraints so I can format it 
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
        
        //grabs the letter and places it in the next empty cell on the board starting from left to right and then moving to the next row
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
        //returns the 2x2 guesses array to the Board VC
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        
        let rowIndex = indexPath.section
        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {return nil}
        
        guard let letter = guesses[indexPath.section][indexPath.row] else {return nil}
        
        let indexedAnswer = Array(answer)
        let typedIndexedAnswer = indexedAnswer[indexPath.row]
        
        if typedIndexedAnswer == letter {
            return .systemGreen
        } else if indexedAnswer.contains(letter){
            return .systemOrange
        } else {
            return .systemRed
        }
    }
}

