//
//  BaseViewController.swift
//  boilerplate
//
//  Created by Aleksandr Pronin on 20.04.19.
//  Copyright © 2019 Aleksandr Pronin. All rights reserved.
//

import UIKit
import ReusableDataInput
import Toaster

enum BackgroundType:String
{
    case none = ""
    case one = "background01"
    case two = "background02"
}

class BaseViewController: UIViewController
{
    @IBOutlet var inputViewCollection: [InputView]!
    
    // MARK: - Object lifecycle
    
    // MARK: - View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: nil)
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    override open func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupViewResizerOnKeyboardShown()
    }
    
    override open func viewDidAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.storedViewFrame = self.view.frame
            /*
             print("[\(type(of: self)) \(#function)] storedViewFrame: \(self.storedViewFrame)")
             */
        }
        if let scrollView = self.view.scrollView {
            scrollView.contentOffset = CGPoint.zero
        }
    }

    override open func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(false)
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func willMove(toParent parent: UIViewController?)
    {
        if parent == nil { //popping
            self.backgroundImageView?.isHidden = true
        }
    }
    
    override open func viewDidLayoutSubviews()
    {
        /*
         print("[\(type(of: self)) \(#function)] self.view.frame: \(self.view.frame)")
         */
        super.viewDidLayoutSubviews()
        if self.storedViewFrame == nil {
            self.storedViewFrame = self.view.frame
            self.setupBackground()
        }
    }

    // MARK: - Event handling
    
    // MARK: - Display logic
    internal func displayError(message: String?)
    {
        /*
         guard let safeMessage = message else {
         self.passwordTextInput.errorMessage = nil
         self.passwordTextInput.state = .normal
         return
         }
         self.passwordTextInput.errorMessage = safeMessage
         self.passwordTextInput.state = .error
         */
        
        guard let safeMessage = message else {
            return
        }
        let toast = Toast(text: safeMessage, duration: Constants.toastDuration)
        toast.show()
    }

    // MARK: - Keyboard
    internal var storedViewFrame: CGRect?
    
    internal func setupViewResizerOnKeyboardShown()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc internal func keyboardWillShow(notification: NSNotification)
    {
        /*
         print("[\(type(of: self)) \(#function)]")
         */
        guard
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let windowFrame = self.storedViewFrame
            else
        {
            return
        }
        
        /*
         var navigationBarHeight: CGFloat = 0
         var statusBarHeight: CGFloat = 0
        if
            let topViewController = UIApplication.topViewController(),
            let navigationController = topViewController.navigationController,
            navigationController.isNavigationBarHidden != nil,
            !navigationController.isNavigationBarHidden
        {
            navigationBarHeight = navigationController.navigationBar.frame.size.height
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        }
        */
        let viewFrame = CGRect(
            x: windowFrame.origin.x,
            y: windowFrame.origin.y,
            width: windowFrame.size.width,
            height: windowFrame.origin.y + windowFrame.size.height - keyboardFrame.size.height// - navigationBarHeight - statusBarHeight
        )
        
        self.view.frame = viewFrame;
    }
    
    @objc internal func keyboardWillHide(notification: NSNotification)
    {
        guard let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        UIView.animate(withDuration: duration) {
            if let storedViewFrame = self.storedViewFrame {
                self.view.frame = storedViewFrame
            }
        }
    }
    
    // MARK: - Background
    internal var backgroundType: BackgroundType = .none
    internal var backgroundImageView: UIImageView?
    
    internal func setupBackground()
    {
        guard
            self.backgroundType != .none,
            let storedViewFrame = self.storedViewFrame
        else
        {
            return
        }
        
        let imageBaseName = self.backgroundType.rawValue
        let imageName: String
        switch UIDevice.current.type {
        case .iPhone4OrLess:
            imageName = imageBaseName
            break
        case .iPhone5:
            imageName = "\(imageBaseName)-568h"
            break
        case .iPhone:
            imageName = "\(imageBaseName)-667h"
            break
        case .iPhonePlus:
            imageName = "\(imageBaseName)-736h"
            break
        default:
            // iPhoneX etc.
            imageName = "\(imageBaseName)-812h"
            break
        }
        
        /*
         print("[\(type(of: self)) \(#function)] imageName: \(imageName)")
         */
        
        let backgroundImageView = UIImageView(image: UIImage(named: imageName))
        backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView = backgroundImageView
        
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let views:[String:UIView] = [
            "backgroundImageView" : backgroundImageView
        ]
        let backgroundHeight = storedViewFrame.size.height
        let metrics = ["height" : backgroundHeight]
        var constraints: [NSLayoutConstraint] = []
        
        // horizontal
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"H:|-0-[backgroundImageView]-0-|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: metrics, views: views)
        
        // vertical
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[backgroundImageView]", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: metrics, views: views)
        
        let heightConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: backgroundHeight)
        constraints += [heightConstraint]
        constraints.forEach { (constraint) in
            constraint.isActive = true
        }
    }
    
    // MARK: - Helper

    // MARK: - Private
}

// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate
{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        // some button touched - do nothing
        if touch.view is UIButton { return true }
        
        // check if user inputs are on the form
        var userInputViews = [InputViewProtocol]()
        if let inputViewCollection = self.inputViewCollection as [InputViewProtocol]?, inputViewCollection.count > 0 {
            userInputViews += inputViewCollection
        }
        
        // no user input on the form - do nothing
        guard userInputViews.count > 0 else { return true }
        
        // check if some user input touched
        let isUserInputTouched = userInputViews.map({$0.isTouched(touch: touch)}).reduce(false) {$0 || $1}
        
        // if user input touched - do nothing
        guard !isUserInputTouched else { return true }
        
        // dismiss keyboard for user input view
        userInputViews.forEach({$0.resignFirstResponderWith(touch: touch)})
        return true
    }
}
