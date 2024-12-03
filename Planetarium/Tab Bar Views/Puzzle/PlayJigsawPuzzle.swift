//
//  PlayJigsawPuzzle.swift
//  Planetarium
//
//  Created by Connor Sink on 12/2/24.
//

import SwiftUI

fileprivate var startTime = Date().timeIntervalSinceReferenceDate
fileprivate var timerHours: UInt8 = 0
fileprivate var timerMinutes: UInt8 = 0
fileprivate var timerSeconds: UInt8 = 0
fileprivate var shuffledPuzzlePieceImageNumbers = [Int]()

struct PlayJigsawPuzzle: View {
    
    @State private var gameStarted = false
    @State private var gameEnded = false
    @State private var gamePlayDuration = ""
    
    /*
     CGSize is a structure that is sometimes used to represent a distance vector,
     as used herein, rather than a physical size. As a vector, its values can be negative.
     The value .zero defines the size whose width and height are both zero.
     */
    @State private var currentPosition = Array(repeating: CGSize(width: 0.0, height: 0.0), count: numberOfPuzzlePieces)
    @State private var newPosition = Array(repeating: CGSize(width: 0.0, height: 0.0), count: numberOfPuzzlePieces)
    
    @State private var showAlertMessage = false
    
    var body: some View {
        ZStack {    // Background View
            
            if gameStarted {
                // Create a rectangle to show the game play area
                Rectangle()
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: completedPuzzleImageWidth, height: completedPuzzleImageHeight)
                    .offset(.zero)
            } else {
                // Show the original jigsaw puzzle image if game is not started
                Image(isiPhone() ? "JigsawPuzzlePhoto_iPhone" : "JigsawPuzzlePhoto_iPad")
                    .offset(.zero)
            }
            
            if gameStarted {
                /*
                 Display randomly shuffled puzzle piece images in the order generated
                 on top of each other at each image's initial current position as set to
                 .zero, which is the iPhone's or iPad's center point coordinate (0, 0)
                 */
                ForEach(shuffledPuzzlePieceImageNumbers, id: \.self) { imageNumber in
                    shuffledPuzzlePieceImage(imageNo: imageNumber)
                }
            }
            VStack {    // Foreground View showing the Play Game, Cancel, and Duration Timer on top of the screen
                HStack {
                    //-----------------
                    // Play Game Button
                    //-----------------
                    Button("Play Game") {
                        playGame()
                    }
                    .disabled(gameStarted)      // Button must be disabled upon game start
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .padding(.leading, 30)
                    
                    //--------------
                    // Cancel Button
                    //--------------
                    Button("Cancel") {
                        initializeGame()
                    }
                    .tint(.blue)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .padding(.horizontal, 10)
                    
                    Spacer()    // Move the two buttons to left side of the screen
                    
                    //-------------------------
                    // Game Play Duration Timer
                    //-------------------------
                    Text(gamePlayDuration)
                        .padding(20)
                    
                }   // End of HStack
                
                Spacer()    // Move the HStack to top side of the screen
                
            }   // End of VStack
            .onAppear() {
                // Create Audio Players
                createAudioPlayers()        // Given in Setup.swift
            }
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {
                    initializeGame()
                }
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of ZStack
    }       // End of body
    
    /*
     ==============================================
     |  MARK: Return Shuffled Puzzle Piece Image  |
     ==============================================
     */
    func shuffledPuzzlePieceImage(imageNo: Int) -> some View {
        
        return AnyView(puzzlePieceImage(imageNumber: imageNo))
    }
    
    /*
     ===========================
     |  MARK: Initialize Game  |
     ===========================
     */
    func initializeGame() {
        
        gameStarted = false
        gameEnded = false
        
        gamePlayDuration = ""
        startTime = Date().timeIntervalSinceReferenceDate
        timerHours = 0
        timerMinutes = 0
        timerSeconds = 0
        
        for index in 0..<numberOfPuzzlePieces {
            currentPosition[index] = .zero
            newPosition[index] = .zero
        }

    }
    
    /*
     =====================
     |  MARK: Play Game  |
     =====================
     */
    func playGame() {
        
        shuffledPuzzlePieceImageNumbers = puzzlePieceImageNumbers.shuffled()
        
        gameStarted = true
        
        // Time at which game starts
        startTime = Date().timeIntervalSinceReferenceDate
        durationTimer()
    }
    
    /*
     ===============================
     |  MARK: Game Duration Timer  |
     ===============================
     */
    func durationTimer() {
        
        // Schedule a timer that repeats every 0.01 second
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            
            if gameStarted {
                
                // Calculate total time in seconds since timer started
                var timeElapsed = Date().timeIntervalSinceReferenceDate - startTime
                
                // Calculate hours
                timerHours = UInt8(timeElapsed / 3600)
                timeElapsed = timeElapsed - (TimeInterval(timerHours) * 3600)
                
                // Calculate minutes
                timerMinutes = UInt8(timeElapsed / 60.0)
                timeElapsed = timeElapsed - (TimeInterval(timerMinutes) * 60)
                
                // Calculate seconds
                timerSeconds = UInt8(timeElapsed)
                timeElapsed = timeElapsed - TimeInterval(timerSeconds)
                
                // Calculate milliseconds
                let timerMilliseconds = UInt8(timeElapsed * 100)
                
                // Create the time string and update the label
                let timeString = String(format: "%02d:%02d:%02d.%02d", timerHours, timerMinutes, timerSeconds, timerMilliseconds)
                
                gamePlayDuration = timeString
                
            } else {
                timer.invalidate()      // Stop the timer
            }
        }
    }
    
    /*
     ===============================
     |  MARK: Check If Game Ended  |
     ===============================
     */
    func checkIfGameEnded() {
        
        for imageNumber in 0..<numberOfPuzzlePieces {
            if currentPosition[imageNumber].width  != correctPosition[imageNumber].width ||
               currentPosition[imageNumber].height != correctPosition[imageNumber].height
            {
                return
            }
        }

        /*
         ******************
         *   Game Ended   *
         ******************
         */
        
        gameEnded = true
        gameStarted = false
        durationTimer()
        
        // Calculate game play duration in seconds
        let gameDurationInSeconds = 3600 * Int(timerHours) + 60 * Int(timerMinutes) + Int(timerSeconds)
        
        var gamePerformance = ""
        
        switch gameDurationInSeconds {
        case 1..<45:
            gamePerformance = "Outstanding"
        case 45..<60:
            gamePerformance = "Excellent"
        case 60..<75:
            gamePerformance = "Good"
        case 75..<90:
            gamePerformance = "Satisfactory"
        default:
            gamePerformance = "Slow"
        }
        
        showAlertMessage = true
        alertTitle = "Game Over!"
        alertMessage = "You solved the jigsaw puzzle in \(gameDurationInSeconds) seconds!\n\nYour game play performance is \(gamePerformance)!"
        
        applaudSoundAudioPlayer!.play()

    }   // End of function
    
    
    /*
     =====================================
     |  MARK: Return Puzzle Piece Image  |
     =====================================
     */
    func puzzlePieceImage(imageNumber: Int) -> some View {
        
        // Image numbers go from 0 to numberOfPuzzlePieces – 1
        
        let pieceImage = Image(isiPhone() ? "PuzzlePieceImage\(imageNumber + 1)_iPhone" : "PuzzlePieceImage\(imageNumber + 1)_iPad")
            /*
             Since currentPosition[imageNumber] width and height are both zero initially,
             each PuzzlePieceImage is placed at the center point (0, 0) of the screen.
             */
            .offset(x: currentPosition[imageNumber].width, y: currentPosition[imageNumber].height)
        
            .gesture(DragGesture()
                .onChanged { value in
                    currentPosition[imageNumber] = CGSize(width: value.translation.width + newPosition[imageNumber].width, height: value.translation.height + newPosition[imageNumber].height)
                }
                .onEnded { value in
                    currentPosition[imageNumber] = CGSize(width: value.translation.width + newPosition[imageNumber].width, height: value.translation.height + newPosition[imageNumber].height)
                    newPosition[imageNumber] = currentPosition[imageNumber]
                    
                    if currentPosition[imageNumber].width  > (correctPosition[imageNumber].width - delta) &&
                        currentPosition[imageNumber].width  < (correctPosition[imageNumber].width + delta) &&
                        currentPosition[imageNumber].height > (correctPosition[imageNumber].height - delta) &&
                        currentPosition[imageNumber].height < (correctPosition[imageNumber].height + delta)
                    {
                        currentPosition[imageNumber].width  = correctPosition[imageNumber].width
                        currentPosition[imageNumber].height = correctPosition[imageNumber].height
                        
                        clickSoundAudioPlayer!.play()
                        checkIfGameEnded()
                    }
                }
            )   // End of gesture
        
        return pieceImage
    }
}

#Preview {
    PlayJigsawPuzzle()
}
