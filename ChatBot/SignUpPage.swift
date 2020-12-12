//
//  SignUp.swift
//  ChatBot
//
//  Created by MAC on 2020/12/10.
//

import SwiftUI
import AWSCognitoIdentityProvider

struct SignUpPage: View {
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var code = ""
    @State var user: AWSCognitoIdentityUser?
    var ccode: String?
    
    var body: some View {
        VStack {
            Text("Sign Up")
            TextField("username", text: $username)
            SecureField("password", text: $password)
            TextField("eamil", text: $email)
            TextField("code", text: $code)
            Button("SignUp", action:{
                UserController.sharedInstance.signup(username: username, password: password, emailAddress: email) { (err, iu) in
                    print(err ?? "no err", iu ?? "no user")
                    user = iu
                }
            })
            Button("V Code", action: {
                UserController.sharedInstance.confirmSignup(user: user!, confirmationCode: code) { (err) in
                    print(err ?? "no err")
                }
            })
        }.padding([.leading,.trailing], 10)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
