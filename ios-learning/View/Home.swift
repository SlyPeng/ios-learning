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
    @State private var heroProgress: CGFloat = 0
    @State private var showHeroView: Bool = true

    
    var body: some View {
        
        NavigationStack{
            List(allProfiles){ profile in
                HStack(spacing: 12){
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:50,height:50)
                        .clipShape(.circle)
                        .opacity(selectedProfile?.id == profile.id ? 0 : 1)
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: {
                            anchor in
                            return [profile.id.uuidString: anchor]
                        })
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
                    
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete){
                        heroProgress = 1.0
                    } completion:{
                        Task{
                            try? await Task.sleep(for: .seconds(0.1))
                            showHeroView = false
                            
                        }
                    }
                }
            }
            .navigationTitle("progress Effect")
        }
        .overlay{
            DetailView(
               selectedProfile: $selectedProfile,
               showDetail: $showDetail,
               heroProgress: $heroProgress,
               showHeroView: $showHeroView
            )
        }
        /// Hero Animation Layer
        .overlayPreferenceValue(AnchorKey.self, {value in
            GeometryReader{ geomotry in
                /// Let's Check Whether We Have Both Source and Destination Frames
                if let selectedProfile,
                   let source = value[selectedProfile.id.uuidString],
                   let destination  = value["DESTINATION"]{
                    let sourceRect = geomotry[source]
                    let radius = sourceRect.height / 2
                    let destinationRect = geomotry[destination]
                    
                    let diffSize = CGSize(
                        width: destinationRect.width - sourceRect.width,
                        height: destinationRect.height - sourceRect.width
                    )
                    let diffOrigin = CGPoint(
                        x: destinationRect.minX - sourceRect.minX,
                        y: destinationRect.minY - sourceRect.minY
                    )
                    
                    /// YOUR HERO VIEW
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: sourceRect.width + (diffSize.width * heroProgress),
                            height: sourceRect.height + (diffSize.height * heroProgress)
                        )
                    
                        .clipShape(.rect(cornerRadius: radius))
                        .offset(
                            x: sourceRect.minX + (diffOrigin.x * heroProgress),
                            y: sourceRect.minY + (diffOrigin.y * heroProgress)
                        )
                        .opacity(showHeroView ? 1: 0)
                }
                   
                
            }
            
        })
    }
}


/// Detail View
struct DetailView: View{
    @Binding var selectedProfile: Profile?
    @Binding var showDetail: Bool
    @Binding var heroProgress: CGFloat
    @Binding var showHeroView: Bool
    /// Color Scheme Based Background Color
    @Environment(\.colorScheme) private var scheme
    @GestureState private var isDragging: Bool = false
    @State private var offset: CGFloat = .zero
    var body: some View{
        if let selectedProfile, showDetail {
            GeometryReader{
                let size = $0.size
                
                ScrollView(.vertical){
                    /// Detail Profile Image View
                    Rectangle()
                        .fill(.clear)
                        .overlay{
                            if !showHeroView{
                                Image(selectedProfile.profilePicture)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height:400)
                                    .clipShape(.rect(cornerRadius: 25))
                                    .clipped()
                                    .transition(.identity)
                            }
                                
                        }
                        .frame(height:400)
                        
                        .clipped()
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: {
                            anchor in
                            return ["DESTINATION": anchor]
                        })
                        .visualEffect {content, geometryProxy in
                            content
                                .offset(y: geometryProxy.frame(in: .scrollView) .minY > 0 ? -geometryProxy.frame(in: .scrollView).minY : 0)
                        }
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
                        showHeroView = true
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete){
                            heroProgress = 0.0
                        } completion:{
                            showDetail = false
                            self.selectedProfile = nil
                        }
                        
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .containerShape(.rect)
                            
                    })
                    .buttonStyle(.glass)
                    .padding()
                    .opacity(showHeroView ? 0 : 1)
                    .animation(.snappy(duration: 0.2, extraBounce: 0), value: showHeroView)
                    
                }
                .offset(x: size.width - (size.width * heroProgress))
                .overlay(alignment: .leading){
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 10)
                        .contentShape(.rect)
                        .gesture(DragGesture()
                            .updating($isDragging, body: {
                                _, out,_ in out = true
                            })
                            .onChanged({value in
                                var translation = value.translation.width
                                translation = isDragging ? translation : .zero
                                translation = translation > 0  ? translation : 0
                                /// Coverting Into Progress
                                let dragProgress = 1.0 - (translation / size.width)
                                /// Limiting Progress btw 0~1
                                let cappedProgress = min(max(0, dragProgress), 1)
                                heroProgress = cappedProgress
                                if !showHeroView{
                                    showHeroView = true
                                }
                            })
                                .onEnded({ value in
                                    /// Closing Based on End Target
                                    let velocity = value.velocity.width
                                    
                                    if((offset + velocity) > (size.width * 0.8)){
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete){
                                            heroProgress = .zero
                                        } completion:{
                                            offset = .zero
                                            showDetail = false
                                            showHeroView = true
                                            self.selectedProfile = nil
                                        }
                                    }else{
                                        /// 恢复展开状态：保持详情页可见，并在动画结束后重新展示大图
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete){
                                            heroProgress = 1.0
                                            offset = .zero
                                        } completion:{
                                            showHeroView = false
                                        }
                                    }
                                    
                                })
                        )
                }
                
            }
        }
        
    }
}

#Preview {
    ContentView()
}
