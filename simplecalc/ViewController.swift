//
//  ViewController.swift
//  simplecalc
//
//  Created by enExl Technologies on 03/11/16.
//  Copyright © 2016 enExl Technologies. All rights reserved.



// Read Me
// This calculator is my first app .
// This is just a simple calculator. Not all exhaustive functionalities have been covered. No animations either.
// I modeled its functionalities based on my phones calculator
// Some redundancies might have been overlooked
// Further things that can be done: 
//  1. limit input values to 10 digits- but why, the double will take care of any input that may exceed int limits
//  2. auto-adjusting dynamic display to accomodate all digits pressed. - partial solution implemented
//  3. a delete button which dynamically affects display and calculated value



import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    // Storage Variables
    
    var labelString:String = ""      // Used to extract numbers from input for calculation
    var lastOperatorPressed  = 17    // Used to implement operation; set to 17 because tag values range from 0...16
    var operandStack = [Double]()    // operandStack keeps stack of results, worth keeping if you wanna debug I think
    var savedNum = 0.0               // store value
    var finalNum = 0.0               // display value
    
    
    // Flag variables
    var modeButtonWasTapped:Bool = false  // monitors whether an operation button was pressed at all - allows for continuous calculation
    var numberFlag = false                // disables operator usage if a number was not already entered
    var decimalFlag = false               // limits decimal usage to once per number
    var prevValue = 0                     // monitors previous button pressed
    var currValue = 0                     // monitors current button pressed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // All the actions are bound to this function
    @IBAction func buttonTapped(_ sender: AnyObject)
    {
        //Storing button credentials
        let button = sender as! UIButton
        let Index: Int = button.tag
        let Title : String = button.currentTitle!
        
        // Used to eliminate the consecutive operator presses while retaining the last operator pressed
        // Can be used for things - though nothing comes to mind as of now
        
        prevValue = currValue
        currValue = Index
        
        //Passing button credentials
        getValue(buttonTag: Index, buttonTitle: Title)
       
    }
    
    
    
    // Implementing multiple conditional statements/blocks
    func getValue(buttonTag :Int , buttonTitle : String)
    {
        
        switch buttonTag
        {
        case 0...9:   labelString = labelString + buttonTitle; performModeOperation();  displayValue(displayText : buttonTitle)
        case 10:      clearAll(); return
        case 11...14: if (prevValue >= 11 && prevValue <= 14) && (currValue >= 11 && currValue <= 14)
                      {
                      clearFlag();lastOperatorPressed = buttonTag; deleteLastItem (); displayValue(displayText : buttonTitle) }
                      else{
                      if !numberFlag {break}; checkMode(); lastOperatorPressed = buttonTag; displayValue(displayText : buttonTitle)
                      }
        case 15:      if modeButtonWasTapped && !(resultLabel.text?.isEmpty)!{displayLabel.text = resultLabel.text;
                      resultLabel.text = "" ; labelString = displayLabel.text! ; modeButtonWasTapped = false
                      }
        case 16:      if !decimalFlag {labelString = labelString + buttonTitle; displayValue(displayText : buttonTitle); decimalFlag = true}
        default: break
            
        }
        
    }
    // Performs operations along with dispalying result data
    func performModeOperation()
    {
        numberFlag = true
        
        if modeButtonWasTapped
        {
            let savedNum2 = Double(labelString)!
            
            finalNum = 0.0
            
            // Add functions you want over here
            
            switch lastOperatorPressed
            {
            
            case 11: finalNum = savedNum / savedNum2;
            case 13: finalNum = savedNum - savedNum2;
            case 12: finalNum = savedNum * savedNum2;
            case 14: finalNum = savedNum + savedNum2;
            
            default: break
            
            }
            
            // Displays value based on whether output has decimal or not or if the value is just too big/small
            
            
            let finalNumFloor = floor(finalNum)
            
            if finalNum > finalNumFloor || finalNum >= Double(Int.max) || finalNum <= Double(Int.min)
            {
           // Has a precision of up to 4 decimal places
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 4
                
                resultLabel.text! = formatter.string(for: finalNum)!
            }
            else
            {
                let formatter = NumberFormatter()
                formatter.numberStyle = .none
                //formatter.maximumFractionDigits = 0

                resultLabel.text! = formatter.string(for: finalNum)!
            }
        }
        
    }

    // Contrary to popular belief it clears set flags
    func clearFlag ()
    {
        numberFlag = false
        decimalFlag = false
        lastOperatorPressed = 17
    }
    
    //Displays input string or text
    func displayValue(displayText : String)
    {
        displayLabel.text!.append(displayText)
        
        let displayLength = 16 // No. of digits accomadated
        
      // Need to adjust display dynamically based on label field space and character pressed. Partial implementation
        
        if (displayLabel.text?.characters.count)! >= displayLength
            {
                var tempLabel: String = displayLabel.text!
                
                if tempLabel.characters.count > 0
                {
                    tempLabel.remove(at: tempLabel.startIndex)
                    displayLabel.text = tempLabel
                }
        }
        
        
    }
    
    // implements CLR
    func clearAll ()
    {
       labelString = ""
       displayLabel.text = ""
       resultLabel.text = ""
        
       operandStack.removeAll()
       savedNum = 0
       modeButtonWasTapped = false
       clearFlag()
    }
    
    //deletes the last item on dipslay. If I assign the function to a button, then the integration needs to be dynamic
    
    func deleteLastItem ()
    {
        var tempLabel: String = displayLabel.text!
        if tempLabel.characters.count > 0
        {
        tempLabel.remove(at: tempLabel.index(before: tempLabel.endIndex))
        displayLabel.text = tempLabel
        }
        
    }
    
    func checkMode()
    {
        clearFlag();
        
        savedNum = Double(labelString)!
        if modeButtonWasTapped
        {
           savedNum = finalNum
        }
        operandStack.append(savedNum)   // saves result of all
        
        labelString = ""
        
        modeButtonWasTapped = true
        
    }

}


