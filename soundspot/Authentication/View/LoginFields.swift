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
            usernameField(username: $viewModel.loginModel.userId,
                          usernameError: $viewModel.loginModel.usernameError,
                          userIdString: viewModel.userIdString,
                          clearError: viewModel.clearLoginUsernameError)
            Divider()
            PasswordField(passwordString: viewModel.passwordString,
                          password: $viewModel.loginModel.password,
                          passwordError: $viewModel.loginModel.passwordError,
                          hidePassword: $viewModel.loginModel.hidePassword,
                          clearError: viewModel.clearLoginPasswordError)
            
            
        }
        .padding(.bottom, 40)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        
        NavigationLink(
            destination: HomeView().navigationBarBackButtonHidden(true).navigationBarHidden(true),
            isActive: $viewModel.authenticated,
            label: {
                Text("Login")
                    .font(.headline)
                    .padding(.horizontal, 60.0)
                    .padding(.vertical, 10.0)
                    .foregroundColor(.white)
                    .background(Color.pink)
                    .cornerRadius(10)
                    .onTapGesture {
                        viewModel.authenticated.toggle()
                        //viewModel.logInUser()
                    }
                
            }).navigationBarBackButtonHidden(true).navigationBarHidden(true)
        
    }

    
    struct usernameField : View{
        @Binding var username : String
        @Binding var usernameError: String
        var userIdString : String
        var clearError: () -> Void
        var body: some View {
            VStack{
                HStack(alignment: .lastTextBaseline, spacing: 15){
                    Image(systemName: "person")
                        .foregroundColor(.black)
                    TextField(userIdString, text: $username).onTapGesture{
                        clearError()
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
        var clearError: () -> Void
        var body : some View {
            VStack{
            HStack(spacing: 15){
                Image(systemName: "lock")
                    .foregroundColor(.black)
                if(hidePassword){
                    SecureField(passwordString, text: $password).onTapGesture {
                        clearError()
                    }
                }
                else {
                    TextField(passwordString, text: $password).onTapGesture {
                        clearError()
                    }
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


