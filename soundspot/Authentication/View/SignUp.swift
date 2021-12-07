//
//  SignUp.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/29/21.
//

import SwiftUI

struct SignUp: View {
    @StateObject var viewModel : AuthenticateUser
    
    var body: some View {
        VStack {
            VStack{
                LoginFields.usernameField(
                    username: $viewModel.signupModel.username,
                    usernameError: $viewModel.signupModel.usernameError,
                    userIdString: viewModel.usernameString,
                    clearError: viewModel.clearSignUpUsernameError)
                Divider()
                emailField(viewModel: viewModel)
                Divider()
                LoginFields.PasswordField(passwordString: viewModel.passwordString,
                              password: $viewModel.signupModel.password,
                              passwordError: $viewModel.signupModel.passwordError,
                              hidePassword: $viewModel.signupModel.hidePassword,
                              clearError: viewModel.clearSignUpPasswordError)
                Divider()
                confirmPasswordField
            }
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            
            NavigationLink(
                destination: HomeView().navigationBarBackButtonHidden(true).navigationBarHidden(true),
                isActive: $viewModel.authenticated,
                label: {
                    Text("SignUp")
                        .font(.headline)
                        .padding(.horizontal, 60.0)
                        .padding(.vertical, 10.0)
                        .foregroundColor(.white)
                        .background(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
                        .cornerRadius(10)
                        .onTapGesture {
                            viewModel.authenticated.toggle() //TODO remove when logging work
                            viewModel.createUserAccount()
                        }
                }).navigationBarBackButtonHidden(true).navigationBarHidden(true)
            Spacer()
            
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(" "),Color(" "),Color(" ")]), startPoint: .leading, endPoint: .trailing)
                ).cornerRadius(10)
                .offset(y: -40)
                .shadow(radius: 20)
            
        }
        
    }
    
    struct emailField : View{
        @ObservedObject var viewModel : AuthenticateUser
        var body: some View{
            VStack{
                HStack(spacing: 15){
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                        .frame(width: 25, height: 25)
                    TextField(viewModel.emailString, text: $viewModel.signupModel.email).onTapGesture {
                        if(viewModel.signupModel.emailError != ""){
                            viewModel.clearSignUpEmailError()
                        }
                    }
                    
                }
                LoginFields.ErrorField(error: $viewModel.signupModel.emailError)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.vertical, 20)
                .padding(.top, 10)
                .padding(.leading, 15)
                .padding(.trailing, 10)
        }
        
    }
    
    
    
    
    
    var confirmPasswordField : some View {
        VStack{
            HStack(spacing: 15){
                Image(systemName: "lock")
                    .foregroundColor(.black)
                if(viewModel.signupModel.hideConfimPassword){
                    SecureField(viewModel.confirmPasswordString, text: $viewModel.signupModel.confirmPassword).onTapGesture {
                        if(viewModel.signupModel.confirmPasswordError != ""){
                            viewModel.clearSignUpConfirmPasswordError()
                        }
                    }
                } else {
                    TextField(viewModel.confirmPasswordString, text: $viewModel.signupModel.confirmPassword).onTapGesture {
                        if(viewModel.signupModel.confirmPasswordError != ""){
                            viewModel.clearSignUpConfirmPasswordError()
                        }
                    }
                }
                
                Button(action: {
                    viewModel.signupModel.hideConfimPassword.toggle()
                }) {
                    Image(systemName: "eye")
                        .foregroundColor(viewModel.signupModel.hideConfimPassword ? .black : .green)
                }
                
            }
            LoginFields.ErrorField(error: $viewModel.signupModel.confirmPasswordError)
        }.padding(.vertical, 20)
            .padding(.top, 10)
            .padding(.leading, 15)
            .padding(.trailing, 10)
    }
    
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(viewModel: AuthenticateUser()).previewLayout(.sizeThatFits)
    }
}


