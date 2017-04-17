//
//  ContentTableHeaderView.swift
//  ReVBX
//
//  Created by 和田 昌紘 on 2017/04/14.
//  Copyright © 2017年 mediba inc. All rights reserved.
//

import UIKit
import AVFoundation

class ContentTableHeaderView: UIView {

    var nibName: String = "ContentTableHeaderView"
//    var viewController: UIViewController!
    var delegate: ContentTableHeaderViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
//    convenience init(frame: CGRect, rootViewController: UIViewController) {
    convenience init(frame: CGRect, delegate: ContentTableHeaderViewDelegate) {
        self.init(frame: frame)
//        self.viewController = rootViewController
        self.delegate = delegate
    }
    
    func setup() {
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.addSubview(view)
    }
    
    @IBAction func takePictureAction(_ sender: UIButton) {
        NSLog("takePicture")
        
        if self.availableCamera() {
            let status = self.authorizedStatus()
            switch status {
            case .authorized, .notDetermined:
                self.showCameraViewController()
            default:
                self.showPermissionAlert()
            }
        }
        else {
            self.showPermissionAlert()
        }
        
    }
    
    private func availableCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    private func authorizedStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    }
    
    private func showCameraViewController() {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        self.viewController.present(picker, animated: true, completion: nil)
        
        self.delegate.willPushCameraViewController()
    }
    
    private func showPermissionAlert() {
//        let alert = UIAlertController(title: nil, message: "このアプリではカメラ機能を使用します。アクセスを許可してください。", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "設定", style: .default, handler: {action in
//            if let url = URL(string: "App-Prefs:root=Privacy") {
//                UIApplication.shared.openURL(url);
//            }
//        }))
//        self.viewController.present(alert, animated: true, completion: nil)
        
        self.delegate.willShowAccessPermissionAlert()
    }
    
    private func showNotUseAlert() {
//        let alert = UIAlertController(title: nil, message: "このデバイスでは本機能の利用はできません", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
//        self.viewController.present(alert, animated: true, completion: nil)
        
        self.delegate.willShowCannotUseAlert()
    }

}


protocol ContentTableHeaderViewDelegate {
    func willShowAccessPermissionAlert()
    func willPushCameraViewController()
    func willShowCannotUseAlert()
}
