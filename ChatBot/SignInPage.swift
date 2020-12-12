//
//  SignInPage.swift
//  ChatBot
//
//  Created by MAC on 2020/12/10.
//

import SwiftUI

struct SignInPage: View {
    @State private var username = ""
    @State private var password = ""
    @State private var title = "SignIn"
    var body: some View {
        NavigationView {
            
            VStack {
                Text(title)
                TextField("username", text: $username)
                SecureField("password", text: $password)
                HStack {
                    Button("SignIn", action:{
                        UserController.sharedInstance.login(username: username, password: password) { (err) in
                            if err == nil {
                                title = "YES!"
                                print(title)
                            } else {
                                print(err ?? "err")
                            }
                        }
                    })
                    NavigationLink(destination: SignUpPage()) {
                        Text("SignUp")
                    }

                   
                }
            }.padding([.leading,.trailing], 10)
            
        }.navigationBarTitle("Disciplines")
        
        
    }
}

struct SignInPage_Previews: PreviewProvider {
    static var previews: some View {
        SignInPage()
    }
}
