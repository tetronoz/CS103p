//
//  ViewController.swift
//  Concentration
//
//  Created by Sergey Tolmachev on 11/05/2018.
//  Copyright © 2018 Sergey Tolmachev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var gameScoreLabel: UILabel!

    
    @IBAction private func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
        setupTheme()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        //flipCountLabel.text = "Flips: \(game.flipCount)"
        flipCountLabel.attributedText = attributedString
        gameScoreLabel.text = "Score: \(game.scoreCount)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
            
        }
    }
    
    private var emojiChoices = ""
    
    private func setupTheme() {
        let emojiThemes = ["Halloween": "🎃👻🍎🍭🍬😱🙀😈🦇",
                            "Faces": "😀😇😎😡🤠🤮🤢🤔🤬",
                            "Animals": "🐶🐯🐧🐥🦄🦋🐷🦊🐼",
                            "Sport": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓",
                            "Cars": "🚗🚕🚙🚌🚎🏎🚓🚑🚒"]
        let themeKeys = Array(emojiThemes.keys)
        let themeName = themeKeys[Int(arc4random_uniform(UInt32(themeKeys.count)))]
        print("\(themeName)")
        
        emojiChoices = emojiThemes[themeName]!
    }
    
    //var emoji = Dictionary<Int, String>()
    private var emoji = [Card:String]()
    
    override func viewDidLoad() {
        updateViewFromModel()
        setupTheme()
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
