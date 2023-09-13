//
//  IntroViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Lottie

class IntroViewController: UIViewController {

    var page: Page?
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var onboardingLottieView: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingLottieView.contentMode = .scaleAspectFit
        onboardingLottieView.loopMode = .loop
        
        

        if let page = page {
            
            titleLabel.text = page.name
            descriptionLabel.text = page.description
            if page.tag == 0 {
                loginButton.isHidden = true
                onboardingLottieView.animation = .named("image1.1")
                onboardingLottieView.play()
            } else if page.tag == 1 {
                loginButton.isHidden = true
                skipButton.isHidden = true
                onboardingLottieView.animation = .named("image1.3.1")
                onboardingLottieView.play()

            } else  {
                loginButton.isHidden = false
                skipButton.isHidden = true
                onboardingLottieView.animation = .named("image1.3")
                onboardingLottieView.play()

            }

        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPageClicked(_ sender: Any) {
        if let login = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            login.modalPresentationStyle = .fullScreen
            present(login, animated: true)
        }
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        if let login = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            login.modalPresentationStyle =  .fullScreen
            present(login, animated: true)
        }
    }
    
}
