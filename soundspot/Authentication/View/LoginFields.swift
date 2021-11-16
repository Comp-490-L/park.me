//
//  selectedState.swift
//  soundspot
//
//  Created by MO BALUSHI on 10/29/21.
//


import SwiftUI

struct LoginFields: View {
    @StateObject var viewModel : AuthenticateUser
    
    var body: some View {
        
        VStack(alignment: .center){
            usernameField(username: $viewModel.loginModel.username,
                          usernameError: $viewModel.loginModel.usernameError,
                          userIdString: viewModel.userIdString)
            Divider()
            PasswordField(passwordString: viewModel.passwordString,
                          password: $viewModel.loginModel.password,
                          passwordError: $viewModel.loginModel.passwordError,
                          hidePassword: $viewModel.loginModel.hidePassword)
            
            
        }
        .padding(.bottom, 40)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        
        NavigationLink(
            destination: HomeView().navigationBarBackButtonHidden(false).navigationBarHidden(false),
            isActive: $viewModel.authenticated,
            label: {
                Text("Login")
                    .font(.headline)
                    .padding(.horizontal, 60.0)
                    .padding(.vertical, 10.0)
                    .foregroundColor(.white)
                    .background(Color(#colorLiteral(red: 0.9580881, green: 0.10593573, blue: 0.3403331637, alpha: 1)))
                    .cornerRadius(10)
                    .onTapGesture {
                        viewModel.authenticated.toggle() //TODO remove when logging work
                        viewModel.logInUser()
                    }
                
            })
        
    }

    
    struct usernameField : View{
        @Binding var username : String
        @Binding var usernameError: String // todo is @State needed
        var userIdString : String
        var body: some View {
            VStack{
                HStack(alignment: .lastTextBaseline, spacing: 15){
                    Image(systemName: "person")
                        .foregroundColor(.black)
                    TextField(userIdString, text: $username).onTapGesture{
                        usernameError = ""
                    }
                
                }
                ErrorField(error: $usernameError)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
            }.padding(.vertical, 20)
                .padding(.top, 10)
                .padding(.leading, 15)
                .padding(.trailing, 10)
            
        }
    }
    
    
    struct PasswordField: View{
        let passwordString: String
        @Binding var password: String
        @Binding var passwordError: String
        @Binding var hidePassword : Bool
        var body : some View {
            VStack{
            HStack(spacing: 15){
                Image(systemName: "lock")
                    .foregroundColor(.black)
                if(hidePassword){
                    SecureField(passwordString, text: $password)
                }
                else {
                    TextField(passwordString, text: $password)
                }
                
                Button(action: {
                    hidePassword.toggle()
                }) {
                    Image(systemName: "eye")
                        .foregroundColor(hidePassword ? .black : .green)
                }
            }
                ErrorField(error: $passwordError)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.vertical, 20)
                .padding(.top, 10)
                .padding(.leading, 15)
                .padding(.trailing, 10)
        }
    }
    

    struct ErrorField : View{
        @Binding var error : String
        var body: some View {
            Text(error).foregroundColor(.red)
        }
    }
    
}

struct LoginField_Previews: PreviewProvider {
    static var previews: some View {
        LoginFields(viewModel: AuthenticateUser()).previewLayout(.sizeThatFits)
    }
}

