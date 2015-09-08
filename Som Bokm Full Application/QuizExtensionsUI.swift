//
//  QuizExtensionsUI.swift
//  SomBokmApplication
//
//  Created by Omar Alibrahim on 9/7/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import Foundation

/*
Animations and transitions
shaking right answer
showing tick or 'X'
*/
extension QuizVC{
    
    func enableButtons(enabled:Bool){
        for b in elementsImages {
            b.userInteractionEnabled = enabled
        }
        
    }
    
    func showMasteredView(){
        let blackView = UIView(frame: self.view.frame)
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.0
        blackView.userInteractionEnabled = true
        self.view.addSubview(blackView)
        
        
        
        let starView = UIImageView(frame: CGRectMake(self.view.center.x, self.view.center.y, 220.0, 220.0))
        starView.center = self.view.center
        starView.image = UIImage(named:"star")
        self.view.addSubview(starView)
        starView.alpha  = 0.0
        println("\n****Mastered****\n")
        
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            blackView.alpha = 0.4
            starView.alpha = 1.0
            
            }, completion: { (f : Bool) -> Void in
                
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    blackView.alpha = 0.0
                    starView.alpha = 0.0
                    
                })
                
        })
        
    }
    
    
    func shakeRightAnswer(button : UIButton){
        // right anwer shakes ANIMATION
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(button.center.x - 10, button.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(button.center.x + 10, button.center.y))
        button.layer.addAnimation(animation, forKey: "position")
    }
    
    // show  or X
    func showCorrectionImage(sender: UIButton,answered:Bool){
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.correctionImage.alpha = 1
            })
            
            self.correctionImage.frame.size = CGSizeMake(self.correctionImage.frame.size.width / 3.0, self.correctionImage.frame.size.height / 3.0)
            self.correctionImage.center = sender.center
            
            }, completion: { (finished : Bool) -> Void in
                
                
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.correctionImage.alpha = 0.0
                    
                    }, completion: { (finished : Bool) -> Void in
                        
                        if (answered  || self.gameType != .Free)
                        {
                            self.goToNextQuestion()
                        }
                        else{
                            self.enableButtons(true)
                        }
                })
        })
    }
    
}


/*

After The Game : ( Game finished )

*/

extension QuizVC{
    
    
    
    
    func gameIsOver() -> Bool
    {
        if gameType != .Free
        {
            return gameCount >= numberOfQuestions ?   true :  false
        }
        return false
    }
    
    
    
    func showResult(){
        
        // Hide all Questions
        self.view.bringSubviewToFront(blurView)
        self.view.bringSubviewToFront(resultView)
        self.view.bringSubviewToFront(backButton)
        
        
        // let resultViewOldFrame = self.resultView.frame
        //self.resultView.bounds.origin.y = self.view.frame.height
        
        self.blurView.hidden   = false
        self.resultView.hidden = false
        
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.blurView.alpha = 1.0
            self.resultView.alpha = 1.0
        })
        
        
        resultLabel.text   = String("\(rightAnsweredTimes) / \(numberOfQuestions)")
        
        
    }
}




/*
*
Static function :
Shuffle
go to next question
*/
extension QuizVC{
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C, size : Int) -> C {
        
        
        let count = size
        
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    
    
    func goToNextQuestion(){
        
        // Next Question
        
        
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            /*
            animating all images and buttons to go out and in to make transitions between two quesions
            */
            
            for i in self.elementsImages{
                i.alpha = 0.0
            }
            self.tahjee2VideoPlayer?.view.alpha = 0.0
            
            }, completion: { (f:Bool) -> Void in
                
                // After Hiding
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    // Showing Elemetns after hiding to another question
                    
                    for i in self.elementsImages{
                        i.alpha = 1.0
                    }
                    self.tahjee2VideoPlayer?.view.alpha = 1.0
                    
                    
                })
                
                
                if self.gameIsOver(){
                    println("Game Over!")
                    // Show result
                    self.showResult()
                    
                }
                else{
                    self.play()
                }
                
                
        })
        
    }

    
    // to prepare size of correction image
    
    func prepareCorrectionImage(){
        
        correctionImage.frame.size = CGSizeMake(400, 400)
        correctionImage.center = self.view.center
        correctionImage.hidden = true
        
    }
    
    
    
}


// CHECK MASTER 


extension QuizVC {
    
    func checkMaster()
    {
        
        if let _rightAnswerElement = self.rightAnswerElement{
            var copyOfRightAnswerElement =  _rightAnswerElement
//            var key = "answeredTimes"
            let name: String? = _rightAnswerElement.name!
            println("before answering : ")
            //                println((dictionaryOfAllElements[randomElementsForChoices.objectAtIndex(rightAnswerIndex) as! String]!.objectForKey(key))!)
            var count = copyOfRightAnswerElement.answeredTimes
            count++
            
            
            /* Comments :
            
            ** when the user get Mastered , the alert should be immediatly after he presses the button
            ** should save the dictuinary in UserDefaults ,
            
            ******  Change number of times the word should be answered here  ****
            
            */
            var masteredAlready = false
            
            if let wordsArray = def.objectForKey("MasteredWordsArray") as? [String]
            {
                println("there are some variables added to The Defaults")
                
                masteredWords = wordsArray
                for s in wordsArray
                {
                    println("OMSILALA")
                    println(s)
                    if name! == s
                    {
                        println("\(name) element is mastered already\n\n")
                        masteredAlready = true
                    }
                }
            }
            
            if masteredAlready
            {
                // just skip the else
                println("MASTERED HUHH")
            }
            else if count == masteredConstant
            {
                masteredWords.append(name!)
                def.setObject (masteredWords, forKey: ("MasteredWordsArray"))
                def.synchronize()
                
                self.showMasteredView()
            }
            
            copyOfRightAnswerElement.answeredTimes = count
            copyOfRightAnswerElement.isMastered = true
            println("copyOfRightAnswerElement : \(copyOfRightAnswerElement)\n count is : \(count)")
            //            self.dictionaryOfAllElements[self.rightAnswerKey] = copyOfRightAnswerElement
            //            base[key] = copyOfRightAnswerElement // Saving here
            
            println("after answering ")
            self.rightAnswerElement = copyOfRightAnswerElement
            println(self.dictionaryOfAllElements[self.rightAnswerKey])
            
        }
    }
    
    
    
    
    
}