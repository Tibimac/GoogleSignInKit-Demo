//
//  AppDelegate.swift
//  GoogleSignInKit-Demo
//
//  Created by Thibault Le Cornec on 26/05/2021.
//

import UIKit
import GoogleSignInKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /* If you app target deployment is under iOS 12 you should handle the URL callback by
         * yourself from the AppDelegate and give it back to the GoogleSignInKit. In fact,
         * GoogleSignInKit use an ASWebAuthenticationSession which handle itself the URL callback,
         * but it's only available starting iOS 12. For previous iOS version it simply use an
         * SFSafariViewController which doesn't handle the callback by itself. */
        if url.scheme == Constants.googleSignInScheme {
            GoogleSignInKit.handleCallback(url: url)
            return true
        } else {
            return false
        }
    }
}
