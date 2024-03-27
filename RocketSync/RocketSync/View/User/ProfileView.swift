//
//  ProfileView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State var selection : Int = 0
    
    var body: some View {
        BaseView(selectedTab: 3)
        
        VStack {
            if selection == 0 {
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 150)
                        .padding(.all)
                        .foregroundColor(Color("TextColor"))
                    
                    VStack {
                        Text(Auth.auth().currentUser?.displayName ?? "Name")
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextColor"))
                        Text(Auth.auth().currentUser?.email ?? "email")
                            .fontWeight(.light)
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    self.selection = 0
                }, label: {
                    Image(systemName: "figure.stand")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 30, alignment: .center)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selection == 0 ? 1 : 0.4)
                })
                
                Spacer()
                
                Button(action: {
                    self.selection = 1
                }, label: {
                    Image(systemName: "text.bubble")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 30, alignment: .center)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selection == 1 ? 1 : 0.4)
                })
                
                Spacer()
                
                Button(action: {
                    self.selection = 2
                }, label: {
                    Image(systemName: "person.fill.questionmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selection == 2 ? 1 : 0.4)
                })
                
                Spacer()
                
                Button(action: {
                    self.selection = 3
                }, label: {
                    Image(systemName: "location.north.line.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selection == 3 ? 1 : 0.4)
                })
                
                Spacer()
                
                Button(action: {
                    self.selection = 4
                }, label: {
                    Image(systemName: "scale.3d")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(Color("TextColor"))
                        .opacity(selection == 4 ? 1 : 0.4)
                })
                
                Spacer()
                
            }.padding(.all)
            
            switch selection {
            case 0:
                Spacer()
                Text("Info")
                Spacer()
            case 1:
                Spacer()
                Text("Posts")
                Spacer()
            case 2:
                Spacer()
                Text("Questions")
                Spacer()
            case 3:
                Spacer()
                Text("Launches")
                Spacer()
            case 4:
                Spacer()
                Text("Designs")
                Spacer()
            default:
                Spacer()
            }
        }
        
        NavigationLink(destination: CreatePostView(), label: {
            Text("Create Post")
                .padding(.all)
                .foregroundStyle(.tint)
                .background(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(.tint, lineWidth: 2))
                .foregroundColor(Color("TextColor"))

            
        })
    }
}

#Preview {
    ProfileView()
}
