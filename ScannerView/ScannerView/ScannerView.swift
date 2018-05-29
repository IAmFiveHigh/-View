//
//  ScannerView.swift
//  ScannerView
//
//  Created by 每天农资 on 2018/5/29.
//  Copyright © 2018年 我是五高你敢信. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerView: UIView {

    private var timer: Timer? = nil
    private let session: AVCaptureSession = AVCaptureSession()
    private var isReading: Bool = false
    private let lineImageView = UIImageView(image: UIImage(named: "wq_code_scanner_line"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
 
        AVCaptureDevice.requestAccess(for: .video) { (flag) in
            if flag {
                self.loadScanView()
                self.startRunning()
            }else {
                
            }
        }

    }
    
    private func loadScanView() {
        guard let device = AVCaptureDevice.default(for: .video) else {return}
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {return}
        
        let output = AVCaptureMetadataOutput()
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        session.sessionPreset = .high
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = [.ean13, .ean8, .upce, .code39, .code39Mod43, .code93, .code128, .pdf417]
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = self.frame
        self.layer.addSublayer(layer)
    }
    
    private func startRunning() {
        isReading = true
        session.startRunning()
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(moveUpAndDownLine), userInfo: nil, repeats: true)
    }
    
    
    @objc private func moveUpAndDownLine() {
        var y = lineImageView.frame.origin.y
    }
    
    /*
        - (void)moveUpAndDownLine {
    CGFloat Y = self.lineImageView.frame.origin.y;
    if (_height + self.lineImageView.frame.size.width - 5 == Y) {
    [UIView beginAnimations: @"asa" context:nil];
    [UIView setAnimationDuration:1.5];
    CGRect frame = self.lineImageView.frame;
    frame.origin.y = _height;
    self.lineImageView.frame = frame;
    [UIView commitAnimations];
    } else if (_height == Y){
    [UIView beginAnimations: @"asa" context:nil];
    [UIView setAnimationDuration:1.5];
    CGRect frame = self.lineImageView.frame;
    frame.origin.y = _height + self.lineImageView.frame.size.width - 5;
    self.lineImageView.frame = frame;
    [UIView commitAnimations];
    }
    }
 */
}

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    
}
