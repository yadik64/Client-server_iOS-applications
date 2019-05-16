//
//  LoginViewController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 01/04/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let segueIdentifier = "LoginSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoginButton()
        setupTextField()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func actionLoginButton(_ sender: UIButton) {
        
        let checkResult = checkUserData()
        
        if checkResult {
            performSegue(withIdentifier: segueIdentifier, sender: self)
        } else {
            showLoginError()
        }
    }
    
    private func checkUserData() -> Bool {
        
        let login = loginTextField.text!
        let password = passwordTextField.text!
        
        if login == "" && password == "" {
            return true
        } else {
            return false
        }
    }
    
    private func showLoginError() {
        
        let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль!", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupTextField() {
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupLoginButton() {
        
        loginButton.layer.cornerRadius = 6
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide() {
        
        let contentInsets = UIEdgeInsets.zero
        
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardHide() {
        
        scrollView.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.returnKeyType {
        case .next:
            self.passwordTextField.becomeFirstResponder()
        case .go:
            self.passwordTextField.resignFirstResponder()
            actionLoginButton(loginButton)
        default:
            break
        }
        
        return true
    }
    
}
