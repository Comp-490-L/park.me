//
//  StartUp.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/17/21.
//

import SwiftUI


private var HPadding = 20.0
struct StartUp: View {
    
    @StateObject var viewModel: AuthenticateUser

    var body: some View {
        
        NavigationView {
            VStack(spacing: 0){
                
                selectState(viewModel: viewModel).padding(.vertical, 350.0)
            }
            .background(Image("wavy")
                            .resizable(resizingMode: .tile)
                            .ignoresSafeArea(.all)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }.navigationBarBackButtonHidden(true).navigationBarHidden(true)
        
    }
    
    
    struct selectState: View {
        @StateObject var viewModel: AuthenticateUser
        var body: some View {
            VStack{
                
                SlidingButton(viewModel: viewModel)
                if viewModel.formType == AuthenticationModel.FormType.login {
                    LoginFields(viewModel: viewModel)
                }else{
                    SignUp(viewModel: viewModel)
                }
                
                forgotBtn
                
                HStack{
                    Color.white.opacity(0.7)
                        .frame(width: 20, height: 1)
                    
                    Text("Or")
                        .foregroundColor(.white)
                    
                    Color.white.opacity(0.7)
                        .frame(width: 20, height: 1)
                }.padding(.top, 10)
                
                HStack{
                    googleSignInBtn
                }.padding(.top, 50)
            }
        }
        
        var forgotBtn : some View{
            Button(action: {
                }) {
                Text("Forgot Password?")
                    .foregroundColor(.white)
            }
        }
        
        var googleSignInBtn: some View{
            Button(action: {
                
            }) {
                Image("googleLogo")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
                    
        
        
        struct SlidingButton: View{
            @StateObject var viewModel: AuthenticateUser
            var body: some View{
                HStack{
                    soundspotterBtn
                    newBtn
                    
                }
                .frame(width: (UIScreen.main.bounds.width - HPadding))
                .background(Color.gray.opacity(0.1))
                .clipShape(Capsule())
            }
            
            
            var soundspotterBtn: some View{
                Button(
                    action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3))
                        {
                            viewModel.updateFormType(type: AuthenticationModel.FormType.login)
                        }}) {
                            Text("SoundSpotter")
                                .foregroundColor(viewModel.formType == AuthenticationModel.FormType.login ? .black : .white)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .frame(width: (UIScreen.main.bounds.width - HPadding) / 2)
                            
                        }.background(viewModel.formType == AuthenticationModel.FormType.login ? Color.white : Color.clear)
                    .clipShape(Capsule())
                //.frame(width: (UIScreen.main.bounds.width - HPadding) / 2) // End button 1
                
            }
            
            
            var newBtn: some View {
                Button(action: {
                
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)){
                        viewModel.updateFormType(type: AuthenticationModel.FormType.signup)
                    }
                }) {
                    Text("New")
                        .foregroundColor(viewModel.formType == AuthenticationModel.FormType.signup ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - HPadding) / 2)
                    
                }.background(viewModel.formType == AuthenticationModel.FormType.signup ? Color.white : Color.clear)
                    .clipShape(Capsule())
                //.frame(minWidth: 0, maxWidth: .infinity) // End Button 2
            }
            
            
        }
    }
    
    
}








struct StartUp_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AuthenticateUser()
        StartUp(viewModel: viewModel)
                .previewDevice("iPhone 13")
    }
}




