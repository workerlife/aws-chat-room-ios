//
//  UserController.swift
//  ChatBot
//
//  Created by MAC on 2020/12/10.
//

import Foundation
import AWSCognitoIdentityProvider
class UserController {
    static let sharedInstance: UserController = UserController()
    private init() {
        let serviceConfiguration =
            AWSServiceConfiguration(region: userPoolRegion,
                                    credentialsProvider: nil)
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId:
                                                                            appClientID,
                                                                        clientSecret: appClientSecret,
                                                                        poolId: userPoolD)
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration,
                                            userPoolConfiguration: poolConfiguration,
                                            forKey:"AWSChat")
        userPool = AWSCognitoIdentityUserPool(forKey: "AWSChat")
        AWSDDLog.sharedInstance.logLevel = .verbose
        
    }
    let userPoolRegion: AWSRegionType = .APNortheast1 //.USEast1
    let userPoolD = "ap-northeast-1_UdeTqcc0F"
    let appClientID = "pkobo5qg4h0lm4nqhf03aj0mr"
    let appClientSecret = "150q4pg3co5kgr1vrvnmf77vetmsmaad0qkkd841haq13dskp1ng"
    
    private var userPool: AWSCognitoIdentityUserPool?
    var currentUser: AWSCognitoIdentityUser? {
        get {
            return userPool?.currentUser()
        }
    }
    
    func login(username: String,
               password:String,
               
               completion:@escaping (Error?)->Void) {
        let user = self.userPool?.getUser(username)
        let task = user?.getSession(username,
                                    password: password,
                                    validationData:nil)
        task?.continueWith(block: { (task) -> Any? in
            if let error = task.error {
                completion(error)
                return nil
            }
            completion(nil)
            return nil
        })
    }
    
    func signup(username: String,
                password:String,
                emailAddress:String,
                completion:@escaping (Error?, AWSCognitoIdentityUser?)->Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let emailAttribute = AWSCognitoIdentityUserAttributeType(name:"email",
                                                                 value: emailAddress)
        attributes.append(emailAttribute)
        let task = self.userPool?.signUp(username,
                                         password: password,
                                         userAttributes: attributes,
                                         validationData: nil)
        task?.continueWith(block: {(task) -> Any? in
            if let error = task.error {
                completion(error, nil)
                return nil
            }
            guard let result = task.result else {
                let error = NSError(domain:  "com.asmtechnology.awschat",
                                    code: 100,
                                    userInfo: ["__type":"Unknown  Error",  "message":"Cognito user pool error."])
                completion(error, nil)
                return nil
            }
            completion(nil, result.user)
            return nil
        })
    }
    
    func confirmSignup(user: AWSCognitoIdentityUser,
                       confirmationCode:String,
                       completion:@escaping (Error?)->Void) {
        let task = user.confirmSignUp(confirmationCode)
        task.continueWith { (task) -> Any? in
            if let error = task.error {
                completion(error)
                return nil
            }
            completion(nil)
            return nil
        }
    }
    func resendConfirmationCode(user: AWSCognitoIdentityUser, completion:@escaping (Error?)->Void) {
        let task = user.resendConfirmationCode()
        task.continueWith { (task) -> Any? in
            if let error = task.error {
                completion(error)
                return nil
            }
            completion(nil)
            return nil
        }
    }
    
    func getUserDetails(user: AWSCognitoIdentityUser,
                        completion:@escaping (Error?, AWSCognitoIdentityUserGetDetailsResponse?)->Void) {
        let task = user.getDetails()
        task.continueWith(block: { (task) -> Any? in
            if let error = task.error {
                completion(error, nil)
                return nil
            }
            guard let result = task.result else {
                let error = NSError(domain: "com.asmtechnology.awschat",
                                    code: 100,
                                    userInfo: ["__type":"Unknown Error","message":"Cognito user pool error."])
                completion(error, nil)
                return nil
            }
            completion(nil, result)
            return nil
        })
        
    }
    
}
