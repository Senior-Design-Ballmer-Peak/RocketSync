//
//  BaseView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/26/24.
//

import SwiftUI

struct BaseView: View {
    @State private var titleAppears = false
    private let animation = Animation.bouncy(duration: 2)
    var showAnimation = false
    var selectedTab: Int = 0
    
    var body: some View {
        ZStack{}
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "location.north")
                        .foregroundColor(Color("TextColor"))
                        .id(titleAppears)
                        .transition(PushTransition(edge: .bottom))
                        .onAppear{ titleAppears.toggle() }
                        .animation(animation, value: titleAppears)
                    
                    Text("RocketSync")
                        .font(.title)
                        .fontWidth(.expanded)
                        .foregroundColor(Color("TextColor"))
                        .id(titleAppears)
                        .transition(PushTransition(edge: .top))
                        .animation(animation, value: titleAppears)
                    
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("TextColor"))
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                
                Spacer()
                
                NavigationLink(destination: PostsView()) {
                    Image(systemName: "aqi.medium")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selectedTab == 0 ? 1.0 : 0.4)
                }
                
                Spacer()
                
                NavigationLink(destination: DistanceMeasureView()) {
                    Image(systemName: "scope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selectedTab == 1 ? 1.0 : 0.4)
                }
                
                Spacer()
                
                NavigationLink(destination: DeviceConnectionView()) {
                    Image(systemName: "location.north.line.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selectedTab == 2 ? 1.0 : 0.4)
                }
                
                Spacer()
                
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selectedTab == 3 ? 1.0 : 0.4)
                }
                
                Spacer()
            }
        }
        .tint(Color("TextColor"))
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    BaseView()
}
