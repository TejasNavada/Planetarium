//
//  SetUpJigsawPuzzle.swift
//  Planetarium
//
//  Created by Connor Sink on 12/2/24.
//

import UIKit
import AVFoundation
import SwiftUI

/*
 ==========================================
 |  MARK: Global Constants and Variables  |
 ==========================================
 */

// Obtain the screen size of the device the app is running on
let screenWidth  = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let numberOfPuzzlePieces = 12

/*
 Swift programming language Ternary Conditional Operator works on three targets:
    condition ? trueValue : falseValue
 Ternary means "consisting of three parts".
 */

// Set the completed puzzle image size for iPhone or iPad the app is running on
let completedPuzzleImageWidth:  CGFloat = isiPhone() ? 300 : 604
let completedPuzzleImageHeight: CGFloat = isiPhone() ? 228 : 456

// Create a fixed size array of integers with numberOfPuzzlePieces elements
var puzzlePieceImageNumbers = Array(repeating: 0, count: numberOfPuzzlePieces)

var correctPosition = Array(repeating: CGSize(width: 0.0, height: 0.0), count: numberOfPuzzlePieces)

/*
 Distance tolerance to snap the puzzle piece image to its correct position:
    IF currentPosition width  is within the correctPosition width  +/- delta AND
       currentPosition height is within the correctPosition height +/- delta
    THEN
       The puzzle piece image will be snapped to its correct position AND
       Click sound will be played to inform the user for the snap action
 */
let delta = isiPhone() ? CGFloat(10.0) : CGFloat(20.0)

// Global AVAudioPlayer object references
var clickSoundAudioPlayer: AVAudioPlayer?
var applaudSoundAudioPlayer: AVAudioPlayer?


/*
 ================================
 |  MARK: Set Up Jigsaw Puzzle  |
 ================================
 */
public func setUpJigsawPuzzle() {
    
    // puzzlePieceImageNumbers[] will contain numbers from zero to numberOfPuzzlePieces – 1
    for index in 0..<numberOfPuzzlePieces {
        puzzlePieceImageNumbers[index] = index
    }
    
    //-----------------------------------------------------
    // Set the correct positions of the solved puzzle piece
    // images for iPhone and iPad the app is running on
    //-----------------------------------------------------
    correctPosition[0]  = isiPhone() ? CGSize(width: -112.5,  height: -76.0)  : CGSize(width: -226.5, height: -152.0)
    correctPosition[1]  = isiPhone() ? CGSize(width: -37.5,   height: -76.0)  : CGSize(width: -75.5,  height: -152.0)
    correctPosition[2]  = isiPhone() ? CGSize(width: 37.5,   height: -76.0) : CGSize(width: 75.5,   height: -152.0)
    correctPosition[3]  = isiPhone() ? CGSize(width: 112.5,  height: -76.0)  : CGSize(width: 226.5,  height: -152.0)
    correctPosition[4]  = isiPhone() ? CGSize(width: -112.5,  height: 0.0)   : CGSize(width: -226.5, height: 0.0)
    correctPosition[5]  = isiPhone() ? CGSize(width: -37.5,  height: 0.0)   : CGSize(width: -75.5,  height: 0.0)
    correctPosition[6]  = isiPhone() ? CGSize(width: 37.5,   height: 0.0)    : CGSize(width: 75.5,   height: 0.0)
    correctPosition[7]  = isiPhone() ? CGSize(width: 112.5,   height: 0.0)   : CGSize(width: 226.5,  height: 0.0)
    correctPosition[8]  = isiPhone() ? CGSize(width: -112.5, height: 76.0)  : CGSize(width: -226.5, height: 152.0)
    correctPosition[9]  = isiPhone() ? CGSize(width: -37.5,  height: 76.0)   : CGSize(width: -75.5,  height: 152.0)
    correctPosition[10] = isiPhone() ? CGSize(width: 37.5,    height: 76.0)   : CGSize(width: 75.5,   height: 152.0)
    correctPosition[11] = isiPhone() ? CGSize(width: 112.5,  height: 76.0)   : CGSize(width: 226.5,  height: 152.0)
}


/*
 ================================
 |  MARK: Check iPhone or iPad  |
 ================================
 */
public func isiPhone() -> Bool {
    if UIDevice.current.localizedModel == "iPhone" {
         return true    // The app is running on iPhone
    } else {
        return false    // The app is running on iPad
    }
}


/*
 ================================
 |  MARK: Create Audio Players  |
 ================================
 */
public func createAudioPlayers() {
    
    if let clickSoundAudioFileUrl = Bundle.main.url(forResource: "ClickSound", withExtension: "wav") {
        do {
            clickSoundAudioPlayer = try AVAudioPlayer(contentsOf: clickSoundAudioFileUrl)
            clickSoundAudioPlayer!.prepareToPlay()
        } catch {
            print("Unable to create clickSoundAudioPlayer!")
        }
    } else {
        print("Unable to find ClickSound in the main bundle!")
    }
    
    if let applaudSoundAudioFileUrl = Bundle.main.url(forResource: "ApplaudSound", withExtension: "wav") {
        do {
            applaudSoundAudioPlayer = try AVAudioPlayer(contentsOf: applaudSoundAudioFileUrl)
            applaudSoundAudioPlayer!.prepareToPlay()
        } catch {
            print("Unable to create applaudSoundAudioPlayer!")
        }
    } else {
        print("Unable to find ApplaudSound in the main bundle!")
    }
    
}

