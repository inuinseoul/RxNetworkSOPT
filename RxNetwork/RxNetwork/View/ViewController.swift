//
//  ViewController.swift
//  RxNetwork
//
//  Created by Inwoo Park on 2022/05/11.
//

import UIKit

import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let networkService = NetworkService()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginResultLabel: UILabel!
    @IBOutlet weak var postResultLabel: UILabel!
    
    @IBOutlet weak var postTitleLabel: UILabel!    
    @IBOutlet weak var postContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonTouched(_ sender: Any) {
        do {
            try login()
        } catch {
            print(error)
        }
    }
    
    @IBAction func checkPostButtonTouched(_ sender: Any) {
        checkPost()
    }
    
    private func login() throws {
        guard let id = idTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        try networkService.loginRequest(id: id, password: password)
            .asDriver(onErrorJustReturn: "Error")
            .drive(loginResultLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func checkPost() {        
        networkService.checkPostRequest()
            .asDriver(onErrorJustReturn: (result: "Error", title: "", content: ""))
            .drive { [weak self] (result, title, content) in
                self?.postResultLabel.text = result
                self?.postTitleLabel.text = title
                self?.postContentLabel.text = content
            }
            .disposed(by: disposeBag)
        
    }
}

