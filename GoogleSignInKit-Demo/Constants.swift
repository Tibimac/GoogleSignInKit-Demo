//
//  Constants.swift
//  GoogleSignInKit-Demo
//
//  Created by Thibault Le Cornec on 26/05/2021.
//

import Foundation
import GoogleSignInKit

enum Constants {

    /*
     Don't forget to setup a new URL type for your target with your own callback URL scheme.
     It could also be added directly into the Info.plist.
     The way you choose for adding it is up to you.
     */

    /* This constant MUST be customized with the one you'll get from the Google console for your app. */
    private static let googleAppID: String = "159879496596-enloepoik7riggikp6vkcvtugbg7od3f"

    static let googleSignInScheme: String = "com.googleusercontent.apps.\(googleAppID)"
    static let googleSignInManagerConfig = GoogleSignInKit.Manager.Configuration(
        clientID: "\(googleAppID).apps.googleusercontent.com",
        defaultScheme: googleSignInScheme,
        defaultCallbackURL: "\(googleSignInScheme)://",
        defaultScopes: [.profile, .email]
    )
}
