//
//  ViewController.swift
//  ChatBot
//
//  Created by MAC on 2020/12/10.
//

import UIKit
import SwiftUI

class ViewController: UIHostingController<SignInPage> {

    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SignInPage() )
    }
    
}


struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        SignInPage()
    }
}
