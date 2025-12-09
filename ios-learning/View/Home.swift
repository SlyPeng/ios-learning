//
//  Home.swift
//  ios-learning
//
//  Created by 彭少林 on 2025/12/9.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var allProfiles:[Profile] = profiles
    /// Detail Properties
    @State private var selectedProfile: Profile?
    @State private var showDetail: Bool = false
    
    var body: some View {
        
        NavigationStack{
            List(allProfiles){ profile in
                HStack(spacing: 12){
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:50,height:50)
                        .clipShape(.circle)
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text(profile.userNmae)
                            .fontWeight(.semibold)
                        Text(profile.lastMsg)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    })
                }
                .contentShape(.rect)
                .onTapGesture {
                    selectedProfile = profile
                    showDetail = true
                }
            }
            .navigationTitle("progress Effect")
        }
        .overlay{
            DetailView(selectedProfile: $selectedProfile, showDetail: $showDetail)
        }
    }
}


/// Detail View
struct DetailView: View{
    @Binding var selectedProfile: Profile?
    @Binding var showDetail: Bool
    
    /// Color Scheme Based Background Color
    @Environment(\.colorScheme) private var scheme
    
    var body: some View{
        if let selectedProfile, showDetail {
            GeometryReader{
                let size = $0.size
                
                ScrollView(.vertical){
                    /// Detail Profile Image View
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height:400)
                        .clipped()
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea()
                .frame(width: size.width, height: size.height)
                .background{
                    Rectangle()
                        .fill(.white)
                        .ignoresSafeArea()
                }
                /// close Button
                .overlay(alignment: .topLeading){
                    Button(action: {
                        showDetail = false
                        self.selectedProfile = nil
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .containerShape(.rect)
                            
                    })
                    .buttonStyle(.glass)
                    .padding()
                    
                    
                }
                
            }
        }
        
    }
}

#Preview {
    ContentView()
}
