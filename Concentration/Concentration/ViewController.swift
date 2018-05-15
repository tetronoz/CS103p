//
//  ViewController.swift
//  Concentration
//
//  Created by Sergey Tolmachev on 11/05/2018.
//  Copyright © 2018 Sergey Tolmachev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    lazy var game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)

    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var gameScoreLabel: UILabel!

    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
        setupTheme()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        //game.flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        gameScoreLabel.text = "Score: \(game.scoreCount)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else if card.isMatched {
                button.isEnabled = false
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
            
        }
    }
    
    var emojiChoices = [String]()
    
    func setupTheme() {
        let emojiThemes = ["Halloween": ["🎃", "👻", "🍎", "🍭", "🍬", "😱", "🙀", "😈", "🦇"],
                            "Faces": ["😀", "😇", "😎", "😡", "🤠", "🤮", "🤢", "🤔", "🤬"],
                            "Animals": ["🐶", "🐯", "🐧", "🐥", "🦄", "🦋", "🐷", "🦊", "🐼"],
                            "Sport": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓"],
                            "Cars": ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒"]]
        let themeKeys = Array(emojiThemes.keys)
        let themeName = themeKeys[Int(arc4random_uniform(UInt32(themeKeys.count)))]
        print("\(themeName)")
        
        emojiChoices = emojiThemes[themeName]!
    }
    
    //var emoji = Dictionary<Int, String>()
    var emoji = [Int:String]()
    
    override func viewDidLoad() {
        setupTheme()
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

