//
//  DraggableViewBackground.swift
//  TinderSimpleSwipeCards-Swift
//
//  Created by iosdev on 15/9/16.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import UIKit

let MaxBufferSize: Int = 2          // max number of cards loaded at any given time, must be greater than 1
let CardHeight: CGFloat = 386       // height of the draggable card
let CardWidth: CGFloat = 290        // width of the draggable card

class SwipeCardContainer: UIView, SwipeCardViewDelegate {
    
    var exapleCardLabels: [String]
    var allCards: [SwipeCardView]

    private var __cardsLoadedIndex: Int         // the index of the card you have loaded into the loadedCards array last
    private var __loadedCards: [SwipeCardView]
    
    private var __menuButton: UIButton
    private var __messageButton: UIButton
    private var __checkButton: UIButton
    private var __xButton: UIButton
    
    override init(frame: CGRect) {
        
        __menuButton = UIButton(frame: CGRect(x: 17, y: 34, width: 22, height: 15))
        __messageButton = UIButton(frame: CGRect(x: 284, y: 34, width: 18, height: 18))
        __checkButton = UIButton(frame: CGRect(x: 200, y: 485, width: 59, height: 59))
        __xButton = UIButton(frame: CGRect(x: 60, y: 485, width: 59, height: 59))
        
        __cardsLoadedIndex = 0
        __loadedCards = [SwipeCardView]()
        
        exapleCardLabels = [ "first", "second", "third", "fourth", "last" ]
        allCards = [SwipeCardView]()
        
        super.init(frame: frame)
        
        __setupView()
        
        __loadCards()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Methods
    
    /*
     * action called when the card goes to the left.
     * This should be customized with your own action
     */
    func cardSwipeLeft(card: UIView) {
        
        __loadedCards.removeAtIndex(0)          // card was swiped, so it's no longer a "loaded card"
        
        if __cardsLoadedIndex < allCards.count {        // if we haven't reached the end of all cards, put another into the loaded cards
            __loadedCards.append(allCards[__cardsLoadedIndex])
            __cardsLoadedIndex++
            self.insertSubview(__loadedCards[MaxBufferSize - 1], belowSubview: __loadedCards[MaxBufferSize - 2])
        }
    }
    
    /*
     * action called when the card goes to the right.
     * This should be customized with your own action
     */
    func cardSwipeRight(card: UIView) {
        
        __loadedCards.removeAtIndex(0)          // card was swiped, so it's no longer a "loaded card"
        
        if __cardsLoadedIndex < allCards.count {        // if we haven't reached the end of all cards, put another into the loaded cards
            __loadedCards.append(allCards[__cardsLoadedIndex])
            __cardsLoadedIndex++                // loaded a card, so have to increment count
            self.insertSubview(__loadedCards[MaxBufferSize - 1], belowSubview: __loadedCards[MaxBufferSize - 2])
        }
    }
    
    //MAKR: Private Methods
    private func __setupView() {
        
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1.0)
        
        __menuButton.setImage(UIImage(named: "menuButton"), forState: .Normal)
        __messageButton.setImage(UIImage(named: "messageButton"), forState: .Normal)
        
        __checkButton.setImage(UIImage(named: "checkButton"), forState: .Normal)
        __checkButton.addTarget(self, action: "__swipeRight", forControlEvents: .TouchUpInside)
        
        __xButton.setImage(UIImage(named: "xButton"), forState: .Normal)
        __xButton.addTarget(self, action: "__swipeLeft", forControlEvents: .TouchUpInside)
        
        addSubview(__menuButton)
        addSubview(__messageButton)
        addSubview(__xButton)
        addSubview(__checkButton)
    }
    
    private func __loadCards() {
        
        if exapleCardLabels.count > 0 {
            let numLoadedCardsCap: Int = exapleCardLabels.count > MaxBufferSize ? MaxBufferSize : exapleCardLabels.count
            
            // if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
            // loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
            for i in 0..<exapleCardLabels.count {
                let newCard: SwipeCardView = __createCardViewWithDataAtIndex(i)
                allCards.append(newCard)
                
                if i < numLoadedCardsCap {
                    __loadedCards.append(newCard)       // adds a small number of cards to be loaded
                }
            }
            
            // displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
            // are showing at once and clogging a ton of data
            for i in 0..<__loadedCards.count {
                if i > 0 {
                    self.insertSubview(__loadedCards[i], belowSubview: __loadedCards[i - 1])
                } else {
                    self.addSubview(__loadedCards[i])
                }
                
                __cardsLoadedIndex++        // we loaded a card into loaded cards, so we have to increment
            }
        }
    }
    
    /*
     * creates a card and returns it.  This should be customized to fit your needs.
     * use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
     * to get rid of it (eg: if you are building cards from data from the internet)
     */
    private func __createCardViewWithDataAtIndex(index: Int) -> SwipeCardView {
        
        let cardView: SwipeCardView = SwipeCardView(frame: CGRect(x: (self.frame.size.width - CardWidth) / 2,
            y: (self.frame.size.height - CardHeight) / 2,
            width: CardWidth,
            height: CardHeight))
        
        cardView.information.text = exapleCardLabels[index]        // placeholder for card-specific information
        cardView.delegate = self
        
        return cardView
    }
    
    /*
     * when you hit the right button, this is called and substitutes the swipe
     */
    func __swipeRight() {
        let dragView: SwipeCardView = __loadedCards.first!
        dragView.overlayView.mode = .Right
        UIView.animateWithDuration(0.2) { () -> Void in
            dragView.overlayView.alpha = 1.0
        }
        
        dragView.rightClickAction()
    }
    
    /*
     * when you hit the left button, this is called and substitutes the swipe
     */
    func __swipeLeft() {
        let dragView: SwipeCardView = __loadedCards.first!
        dragView.overlayView.mode = .Left
        UIView.animateWithDuration(0.2) { () -> Void in
            dragView.overlayView.alpha = 1.0
        }
        
        dragView.leftClickAction()
    }
}
