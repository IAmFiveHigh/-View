//
//  ScannerView.swift
//  ScannerView
//
//  Created by 每天农资 on 2018/5/29.
//  Copyright © 2018年 我是五高你敢信. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerViewDelegate: class {
    func result(_ result: String?)
}

class ScannerView: UIView {

    private var timer: Timer? = nil
    private let session: AVCaptureSession = AVCaptureSession()
    var isReading: Bool = false
    private let lineImageView = UIImageView(image: UIImage(named: "wq_code_scanner_line"))
    
    weak var delegate: ScannerViewDelegate?
    
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        height = frame.height
        width = frame.width
        
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
        
//        lineImageView.frame = CGRect(x: 0, y: 0, width: width, height: 5)
//        addSubview(lineImageView)

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
        DispatchQueue.main.async {
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.layer.addSublayer(layer)
        }
        
    }
    
    func startRunning() {
        isReading = true
        session.startRunning()
        
//        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(moveUpAndDownLine), userInfo: nil, repeats: true)
    }
    
    
    func stopRunning() {
        if let timer1 = timer {
            if timer1.isValid {
                timer1.invalidate()
                timer = nil
            }
        }
        session.stopRunning()
    }
    
//    @objc private func moveUpAndDownLine() {
//        let y = lineImageView.frame.origin.y
//        if (height - self.lineImageView.frame.size.height == y) {
//            UIView.beginAnimations("asa", context: nil)
//            UIView.setAnimationDuration(1.5)
//            var frame = lineImageView.frame
//            frame.origin.y = 0
//            lineImageView.frame = frame
//            UIView.commitAnimations()
//        }else if (0 == y){
//            UIView.beginAnimations("asa", context: nil)
//            UIView.setAnimationDuration(1.5)
//            var frame = lineImageView.frame
//            frame.origin.y = height - lineImageView.frame.height
//            lineImageView.frame = frame
//            UIView.commitAnimations()
//        }
//    }
    

}

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard isReading else {return}
        
        if (metadataObjects.count > 0) {
            isReading = false
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if let delegate = delegate {
                    delegate.result(metadataObject.stringValue)
                }
            }
        }
    }
}
