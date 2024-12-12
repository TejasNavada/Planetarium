//
//  Home.swift
//  Planetarium
//
//  Created by Tejas Navada 11/24/2024
//

import SwiftUI
import SwiftData

struct Home: View {
    
    
    
    @State private var picture = APODStruct(title: "", date_created: "", photo_description: "", image_url: "")
    
    var body: some View {
        return AnyView(
            ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("Welcome")
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                /*
                 ------------------------------------------------------------------------------
                 Show an image slider of the photos in the database
                 ------------------------------------------------------------------------------
                 */
                
                // image obtained from its URL
                getImageFromUrl(url: picture.image_url, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
                    .padding(10)
                
                
                // caption
                Text(picture.title)
                    .font(.headline)
                    // Allow lines to wrap around
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                Text(picture.photo_description)
                // Allow lines to wrap around
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                
                Text("Powered By")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .italic()
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                // Show The Google Books API provider's website in default web browser
                Link(destination: URL(string: "https://apod.nasa.gov/apod/astropix.html")!) {
                    HStack{
                        Image("NasaLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                        Text("Nasa Astronomy Picture of the Day")
                            .foregroundStyle(.blue)
                        
                    }
                    
                }
                .padding()
                
                Link(destination: URL(string: "https://eonet.gsfc.nasa.gov")!) {
                    HStack{
                        Image("NasaLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                        Text("EONET")
                            .foregroundStyle(.blue)
                        
                    }
                    
                }
                .padding()
                
                // Show The Unsplash API provider's website in default web browser
                Link(destination: URL(string: "https://images.nasa.gov/#/")!) {
                    HStack{
                        Image("NasaLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                        Text("Nasa Image and Video Library")
                            .foregroundStyle(.blue)
                    }
                    
                }
                .padding(.bottom, 50)
                
            }   // End of VStack
        }   // End of ScrollView
        .onAppear() {
            startTimer()
        }
        

        }   // End of ZStack
        )
        
    }   // End of var
    
    func startTimer() {
        picture = getAPODFromApi()!
    }
    
    
}

#Preview {
    Home()
}
