//
//  ViewController.swift
//  retro-calculator
//
//  Created by David Pavel on 11/27/15.
//  Copyright © 2015 8R. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = ""
    }
    
    var buttonSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValString = ""
    var rightValString = ""
    var operatorSelected = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        do{
            try buttonSound = AVAudioPlayer(contentsOfURL: soundURL)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberPressed(button: UIButton!) {
        playSound()
        runningNumber += "\(button.tag)"
        outputLabel.text = runningNumber
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            // Do some math
            
            // A user selected an operator but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValString = runningNumber
                runningNumber = ""
                
                switch (currentOperation) {
                case (Operation.Multiply):
                    result = "\(Double(leftValString)! * Double(rightValString)!)";
                    break;
                case (Operation.Divide):
                    result = "\(Double(leftValString)! / Double(rightValString)!)";
                    break;
                case (Operation.Add):
                    result = "\(Double(leftValString)! + Double(rightValString)!)";
                    break;
                case (Operation.Subtract):
                    result = "\(Double(leftValString)! - Double(rightValString)!)";
                    break;
                default:
                    break;
                }
                
                leftValString = result
                outputLabel.text = result
            }
            
            currentOperation = op
            
            
        } else {
            // This is the first time an operator has been pressed
            
            leftValString = runningNumber
            runningNumber = ""
            currentOperation = op
        }
        
    }
    
    func playSound() {
        if (buttonSound.playing) {
            buttonSound.stop()
        }
        buttonSound.play()
    }

    @IBAction func onClearPress(sender: AnyObject) {
        runningNumber = ""
        leftValString = ""
        rightValString = ""
        operatorSelected = ""
        currentOperation = Operation.Empty
        result = ""
        outputLabel.text = "0"
        
    }
    @IBAction func onEqualPress(sender: AnyObject) {
        processOperation(currentOperation)
    }
    @IBAction func onAddPress(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    @IBAction func onSubtractPress(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    @IBAction func onMultiplyPress(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    @IBAction func onDividePress(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
}

