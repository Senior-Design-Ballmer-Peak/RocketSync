//
//  ProfileView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 1/25/24.
//

import SwiftUI

struct ProfileView: View {
    @State var selection : Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 150)
                    .padding(.all)
                
                VStack {
                    Text("First Last")
                        .fontWeight(.bold)
                    Text("username")
                        .fontWeight(.light)
                }
                
                Spacer()
            }
            
            TabView(selection: $selection) {
                Text("Posts").tabItem {  }.tag(0)
                Text("Questions").tabItem {  }.tag(1)
                Text("Launches").tabItem {  }.tag(2)
                Text("Designs").tabItem {  }.tag(3)
            }
            .overlay(
                Color.white
                    .edgesIgnoringSafeArea(.vertical)
                    .frame(height: 50)
                    .overlay(HStack {
                        Spacer()
                        Button(action: {
                            self.selection = 0
                        }, label: {
                            Image(systemName: "text.bubble")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 0 ? 1 : 0.4)
                        })
                        Spacer()
                        
                        Button(action: {
                            self.selection = 1
                        }, label: {
                            Image(systemName: "person.fill.questionmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 1 ? 1 : 0.4)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            self.selection = 2
                        }, label: {
                            Image(systemName: "location.north.line.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 2 ? 1 : 0.4)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            self.selection = 3
                        }, label: {
                            Image(systemName: "scale.3d")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 3 ? 1 : 0.4)
                        })
                        
                        Spacer()
                    })
                ,alignment: .top)
        }
        
        
    }
}

#Preview {
    ProfileView()
}
