//
//  AddFavorite.swift
//  Planetarium
//
//  Created by Tejas Navada on 12/10/24.
//  Copyright © 2024 Tejas Navada. All rights reserved.
//

import SwiftUI
import SwiftData
import Speech
import AVFoundation

fileprivate var audioSession = AVAudioSession()
fileprivate var audioRecorder: AVAudioRecorder!
fileprivate let audioEngine = AVAudioEngine()
fileprivate let request = SFSpeechAudioBufferRecognitionRequest()
fileprivate var temporaryVoiceRecordingFilename = ""


fileprivate let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!

// Global Variable
fileprivate var recognitionTask = SFSpeechRecognitionTask()

struct AddFavorite: View {

    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    //----------------
    // Trip Attributes
    //----------------
    @State private var favoriteTitleTextFieldValue = ""
    @State private var favoriteCenterTextFieldValue = ""
    @State private var speechConvertedToText = ""
    @State private var textEntered = false
    @State private var selectedIndex = 0
    var mediaType = ["Photo", "Video", "Audio"]
    
    
    @State private var recordingVoice = false
    @State private var recordingSpeech = false

    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    @State private var showVideoPicker = false
    @State private var videoUrl: URL?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    
    var body: some View {
        /*
         Create Binding between 'useCamera' and 'usePhotoLibrary' boolean @State variables so that only one of them can be true.
         get
            A closure that retrieves the binding value. The closure has no parameters.
         set
            A closure that sets the binding value. The closure has the following parameter:
            newValue stored in $0: The new value of 'useCamera' or 'usePhotoLibrary' boolean variable as true or false.
         
         Custom get and set closures are run when a newValue is obtained from the Toggle when it is turned on or off.
         */
        let camera = Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                if $0 == true {
                    usePhotoLibrary = false
                }
            }
        )
        let photoLibrary = Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                if $0 == true {
                    useCamera = false
                }
            }
        )
        
        Form {
            Picker("Media type", selection: $selectedIndex) {
                ForEach(0 ..< mediaType.count, id: \.self) { index in
                    Text(mediaType[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            Section(header: Text(mediaType[selectedIndex] + " Title")) {
                HStack {
                    TextField("Enter " + mediaType[selectedIndex] + " Title", text: $favoriteTitleTextFieldValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                    
                    Button(action: {    // Button to clear the text field
                        favoriteTitleTextFieldValue = ""
                    }) {
                        Image(systemName: "multiply.square")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }   // End of HStack
            }
            Section(header: Text(mediaType[selectedIndex] + " Center")) {
                HStack {
                    TextField("Enter " + mediaType[selectedIndex] + " Center", text: $favoriteCenterTextFieldValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                    
                    Button(action: {    // Button to clear the text field
                        favoriteCenterTextFieldValue = ""
                    }) {
                        Image(systemName: "multiply.square")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }   // End of HStack
            }
            if selectedIndex != 2 {
                Section(header: Text("Take or Pick " + mediaType[selectedIndex])) {
                    VStack {
                        Toggle("Use Camera", isOn: camera)
                        Toggle("Use Photo Library", isOn: photoLibrary)
                        
                        Button("Get " + mediaType[selectedIndex]) {
                            if selectedIndex == 0 {
                                showImagePicker = true
                            }
                            else{
                                showVideoPicker = true
                            }
                            
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            }
            
            if pickedImage != nil {
                Section(header: Text("Taken or Picked Photo")) {
                    pickedImage?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                }
            }
            if videoUrl != nil {
                Section(header: Text("Video Thumbnail")) {
                    Image(uiImage: videoUIImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                }
            }
            if selectedIndex == 2{
                Section(header: Text("Voice Recording")) {
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                await voiceRecordingMicrophoneTapped()
                            }
                        }) {
                            voiceRecordingMicrophoneLabel
                        }
                        Spacer()
                    }
                }
            }
            Section(header: Text(mediaType[selectedIndex] + " Description")) {
                HStack {
                    Spacer()
                    Button(action: {
                        microphoneTapped()
                    }) {
                        microphoneLabel
                    }
                    Spacer()
                }
            }
            if !speechConvertedToText.isEmpty {
                Section(header: Text("Speech Converted to Text")) {
                    Text(speechConvertedToText)
                        .multilineTextAlignment(.center)
                        // This enables the text to wrap around on multiple lines
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }
            }
            
           
            
        }   // End of Form
        .font(.system(size: 14))
        .navigationTitle("Add New Favorite Media")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if inputDataValidated() {
                        saveNewMultimediaToDatabase()
                        
                        showAlertMessage = true
                        alertTitle = "Favorite media Added!"
                        alertMessage = "New favorite media is successfully added to database."
                    } else {
                        showAlertMessage = true
                        alertTitle = "Missing Input Data!"
                        alertMessage = "All entries are required"
                    }
                }) {
                    Text("Save")
                }
            }
        }
        .onChange(of: pickedUIImage) {
            guard let uiImagePicked = pickedUIImage else { return }
            
            // Convert UIImage to SwiftUI Image
            pickedImage = Image(uiImage: uiImagePicked)
        }
        .sheet(isPresented: $showImagePicker) {
            /*
             For storage and performance efficiency reasons, we scale down the photo image selected from the
             photo library or taken by the camera to a smaller size with imageWidth and imageHeight in points.
             
             For retina displays, 1 point = 3 pixels
             
             // Example: For HD aspect ratio of 16:9
             width  = 500.00 points --> 1500.00 pixels
             height = 281.25 points -->  843.75 pixels
             
             500/281.25 = 16/9 = 1500.00/843.75 = HD aspect ratio
             
             imageWidth =  500.0 points and imageHeight = 281.25 points will produce an image with
             imageWidth = 1500.0 pixels and imageHeight = 843.75 pixels which is about 600 KB in JPG format.
             */
            
            ImagePicker(
                uiImage: $pickedUIImage,
                sourceType: useCamera ? .camera : .photoLibrary,
                imageWidth: 500.0,
                imageHeight: 281.25
            )
        }
        .onChange(of: videoUrl) {
            guard let url = videoUrl else { return }
            videoUrl = url
        }
        .sheet(isPresented: $showVideoPicker) {
            VideoPicker(videoUrl: $videoUrl, sourceType: useCamera ? .camera : .photoLibrary)
        }
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
              Button("OK") {
                  if alertTitle == "Favorite Added!" {
                      // Dismiss this view and go back to the previous view
                      dismiss()
                  }
              }
            }, message: {
              Text(alertMessage)
            })
        
    }   // End of body var
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered multimedia title
        let Title = favoriteTitleTextFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let Center = favoriteTitleTextFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let Description = speechConvertedToText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        /*
         input fields must be filled
         */
        if (Title.isEmpty || Center.isEmpty || Description.isEmpty ){
            return false
        }
        
        if (selectedIndex == 0 && pickedImage == nil){
            return false
        }
        if (selectedIndex == 1 && videoUrl == nil){
            return false
        }
        if (selectedIndex == 2 && temporaryVoiceRecordingFilename.isEmpty){
            return false
        }
        return true
    }
    
    /*
     ---------------------
     MARK: Supporting View
     ---------------------
     */
    var microphoneLabel: some View {
        VStack {
            Image(systemName: recordingSpeech ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
            Text(recordingSpeech ? "Recording your voice... Tap to Stop!" : "Convert Speech to Text!")
                .padding()
                .multilineTextAlignment(.center)
        }
    }
    
    /*
     -----------------------
     MARK: Microphone Tapped
     -----------------------
     */
    func microphoneTapped() {
        if recordingSpeech {
            cancelRecording()
            recordingSpeech = false
        } else {
            recordingSpeech = true
            recordAndRecognizeSpeech()
        }
    }
    
    /*
     ----------------------
     MARK: Cancel Recording
     ----------------------
     */
    func cancelRecording() {
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask.finish()
    }
    
    /*
     --------------------------------------------
     MARK: Record Audio and Transcribe it to Text
     --------------------------------------------
     */
    func recordAndRecognizeSpeech() {
        
        // Create a shared audio session instance
        audioSession = AVAudioSession.sharedInstance()
        
        //---------------------------
        // Enable Built-In Microphone
        //---------------------------
        
        // Find the built-in microphone.
        guard let availableInputs = audioSession.availableInputs,
              let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
        else {
            print("The device must have a built-in microphone.")
            return
        }
        
        do {
            try audioSession.setPreferredInput(builtInMicrophone)
        } catch {
            fatalError("Unable to Find the Built-In Microphone!")
        }
        
        //--------------------------------------------------
        // Set Audio Session Category and Request Permission
        //--------------------------------------------------
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            
            // Activate the audio session
            try audioSession.setActive(true)
        } catch {
            print("Setting category or getting permission failed!")
        }
        
        //--------------------
        // Set up Audio Buffer
        //--------------------
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        //---------------------
        // Prepare Audio Engine
        //---------------------
        audioEngine.prepare()
        
        //-------------------
        // Start Audio Engine
        //-------------------
        do {
            try audioEngine.start()
        } catch {
            print("Unable to start Audio Engine!")
            return
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                
                if authStatus == .authorized {
                    //-------------------------------
                    // Convert recorded voice to text
                    //-------------------------------
                    recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
                        
                        if result != nil {  // check to see if result is empty (i.e. no speech found)
                            if let resultObtained = result {
                                let bestString = resultObtained.bestTranscription.formattedString
                                speechConvertedToText = bestString
                                
                            } else if let error = error {
                                print("Transcription failed, but will continue listening and try to transcribe. See \(error)")
                            }
                        }
                    })
                } else {
                    /*
                     The user earlier denied speech recognition. Present a message
                     indicating that the user can change speech recognition permission
                     in the Privacy & Security section of the Settings app.
                     */
                    showAlertMessage = true
                    alertTitle = "Speech Recognition Unallowed"
                    alertMessage = "Allow speech recognition in Privacy & Security section of the Settings app."
                }
            }
        }
    }
    
    
    /*
     --------------------------------------
     MARK: Voice Recording Microphone Label
     --------------------------------------
     */
    var voiceRecordingMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
                .padding()
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    
    /*
     ---------------------------------------
     MARK: Voice Recording Microphone Tapped
     ---------------------------------------
     */
    func voiceRecordingMicrophoneTapped() async {
        if audioRecorder == nil {
            recordingVoice = true
            Task {
                await startRecording()
            }
        } else {
            recordingVoice = false
            finishRecording()
        }
    }
    
    /*
     ---------------------------
     MARK: Start Voice Recording
     ---------------------------
     */
    func startRecording() async {

        // Create a shared audio session instance
        audioSession = AVAudioSession.sharedInstance()
        
        //---------------------------
        // Enable Built-In Microphone
        //---------------------------
        
        // Find the built-in microphone.
        guard let availableInputs = audioSession.availableInputs,
              let builtInMicrophone = availableInputs.first(where: { $0.portType == .builtInMic })
        else {
            print("The device must have a built-in microphone.")
            return
        }
        
        do {
            try audioSession.setPreferredInput(builtInMicrophone)
        } catch {
            fatalError("Unable to Find the Built-In Microphone!")
        }
        
        //--------------------------------------------------
        // Set Audio Session Category and Request Permission
        //--------------------------------------------------
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            
            // Activate the audio session
            try audioSession.setActive(true)
        } catch {
            print("Setting category or getting permission failed!")
        }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        temporaryVoiceRecordingFilename = "voiceRecording.m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(temporaryVoiceRecordingFilename)
        
        Task {
            // Request permission to record user's voice
            if await AVAudioApplication.requestRecordPermission() {
                // The user grants access. Present recording interface.
                do {
                    audioRecorder = try AVAudioRecorder(url: audioFilenameUrl, settings: settings)
                    audioRecorder.record()
                } catch {
                    finishRecording()
                }
            } else {
                /*
                 The user earlier denied use of microphone. Present a message
                 indicating that the user can change the microphone use permission
                 in the Privacy & Security section of the Settings app.
                 */
                showAlertMessage = true
                alertTitle = "Voice Recording Unallowed"
                alertMessage = "Allow recording of your voice in Privacy & Security section of the Settings app."
            }
        }
    }
    
    /*
     ----------------------------
     MARK: Finish Voice Recording
     ----------------------------
     */
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        recordingVoice = false
    }
    
    /*
    --------------------------------
    MARK: Save New Multimedia to Database
    --------------------------------
    */
    func saveNewMultimediaToDatabase() {
        
        //-----------------------------
        // Obtain Current Date and Time
        //-----------------------------
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        // Format current date and time as above and convert it to String
        let currentDateTime = formatter.string(from: date)
        
        

        
        
        
        
        //-----------------------------------------------
        // Instantiate a new Photo/Video/Audio object and dress it up
        //-----------------------------------------------
        if (selectedIndex == 0){
            //--------------------------------------------------
            // Store Taken or Picked Photo to Document Directory
            //--------------------------------------------------
            let photoFullFilename = UUID().uuidString + ".jpg"
            
            if let photoData = pickedUIImage {
                if let jpegData = photoData.jpegData(compressionQuality: 1.0) {
                    let fileUrl = documentDirectory.appendingPathComponent(photoFullFilename)
                    try? jpegData.write(to: fileUrl)
                }
            } else {
                fatalError("Picked or taken photo is not available!")
            }
            let newPhoto = Photo(center: favoriteCenterTextFieldValue, title: favoriteTitleTextFieldValue, date_created: currentDateTime, photo_description: speechConvertedToText, image_url: photoFullFilename, userAdded: true)
            modelContext.insert(newPhoto)
        }
        if (selectedIndex == 1){
            let videoFullFilename = UUID().uuidString + ".mp4"
            
            // videoData is a global variable obtained in VideoPicker
            if let data = videoData {
                let fileUrl = documentDirectory.appendingPathComponent(videoFullFilename)
                try? data.write(to: fileUrl)
            } else {
                fatalError("Unable to write video file to document directory!")
            }
            let newVideo = Video(center: favoriteCenterTextFieldValue, title: favoriteTitleTextFieldValue, date_created: currentDateTime, video_description: speechConvertedToText, video_url: videoFullFilename, thumbnail_url: "", captions_url: "", userAdded: true)
            modelContext.insert(newVideo)
        }
        if (selectedIndex == 2){
            //----------------------------------------------------------------
            // Rename the temporary voice recording file in document directory
            //----------------------------------------------------------------
            
            let newAudioFullFilename = UUID().uuidString + ".m4a"
            
            let temporaryFile = documentDirectory.appendingPathComponent(temporaryVoiceRecordingFilename)
            let finalFile = documentDirectory.appendingPathComponent(newAudioFullFilename)
            
            do {
                try FileManager.default.moveItem(at: temporaryFile, to: finalFile)
            } catch {
                fatalError("Unable to rename the temporary voice recording file in document directory")
            }
            let newAudio = Audio(center: favoriteCenterTextFieldValue, title: favoriteTitleTextFieldValue, date_created: currentDateTime, audio_description: speechConvertedToText, audio_url: newAudioFullFilename, userAdded: true)
            modelContext.insert(newAudio)
        }
        
        
        
        
        
        // Initialize @State variables
        showImagePicker = false
        pickedUIImage = nil
        videoUrl = nil
        favoriteCenterTextFieldValue = ""
        favoriteTitleTextFieldValue = ""
        speechConvertedToText = ""
        
        
    }   // End of function
    
}   // End of struct


#Preview {
    AddFavorite()
}
