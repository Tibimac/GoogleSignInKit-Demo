//
//  ViewController.swift
//  GoogleSignInKit-Demo
//
//  Created by Thibault Le Cornec on 26/05/2021.
//

import UIKit
import GoogleSignInKit

class ViewController: UIViewController {

    /* Properties */

    private static let buttonHeight: CGFloat = 32.0
    private static let titleHorizontalPadding: CGFloat = 8.0

    /* Views */

    private let signInButton: UIButton = {
        $0.setTitle("Connect with Google", for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.cornerRadius = buttonHeight / 2
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: titleHorizontalPadding, bottom: 0, right: titleHorizontalPadding)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))

    /* Lifecycle */

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton)
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        /* Because of contentEdgeInsets given for horizontal padding around titleLabel the height
         * is changed due to top and bottom contentEdgeInsets at 0. To "fix that", a height
         * constraint is applied. */
        signInButton.heightAnchor.constraint(equalToConstant: Self.buttonHeight).isActive = true
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    /* Actions */

    @objc private func signIn() {
        do {
            try GoogleSignInKit.signIn(configuration: Constants.googleSignInManagerConfig) { [weak self] signInResult in
                switch signInResult {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.displaySignInError(error)
                    }

                case .success(let credentials):
                    DispatchQueue.main.async {
                        self?.displaySignInSucceeded(withCredentials: credentials)
                    }
                }
            }
        } catch let error {
            displaySignInError(error)
        }
    }

    /* Utils */
    
    private func displaySignInSucceeded(withCredentials credentials: GoogleSignInKit.Credentials) {
        let alertController = UIAlertController(title: "Sign-in Done!",
                                                message: "Great the credentials from Google are there! Touch the Share button to share a JSON object of them if you need.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            guard
                let jsonData = try? jsonEncoder.encode(credentials),
                let jsonString = String(data: jsonData, encoding: .utf8)
            else { return }
            let activityVC = UIActivityViewController(activityItems: [jsonString], applicationActivities: nil)
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = self.signInButton
                popover.sourceRect = self.signInButton.bounds
                popover.permittedArrowDirections = [.up, .down]
            }
            self.present(activityVC, animated: true)
        }
        // iOS add the actions from left to right but macOS does it the opposite way! I want the Share action to always be on the right.
        #if targetEnvironment(macCatalyst) || os(macOS)
        alertController.addAction(shareAction)
        alertController.addAction(okAction)
        #elseif os(iOS)
        alertController.addAction(okAction)
        alertController.addAction(shareAction)
        #endif
        alertController.preferredAction = shareAction
        present(alertController, animated: true)
    }

    private func displaySignInError(_ error: Error) {
        let nsError = error as NSError
        guard nsError.domain == GoogleSignInKit.Error.errorDomain, let error = error as? GoogleSignInKit.Error else {
            /** As GoogleSignInKit only use error of type GoogleSignInKit.Error, coming in this else
             should not be possible! */
            return
        }
        switch error {
        case .canceled:
            break

        case .unknown,
             .noConfiguration,
             .failedToSetupAuthenticationRequest,
             .cannotStartAuthentication,
             .authenticationRequestFailed,
             .failedToSetupCredentialsRequest,
             .credentialsRequestFailed:

            let alertController = UIAlertController(
                title: "Error",
                message: "An error occured during sign-in attempt! Please try again.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }

}
