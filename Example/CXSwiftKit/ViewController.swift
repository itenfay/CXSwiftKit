//
//  ViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 11/14/2022.
//  Copyright (c) 2022 chenxing. All rights reserved.
//

import UIKit
import CXSwiftKit

class ViewController: UIViewController {
    
    @IBOutlet weak var vSlider: CXVerticalSlider!
    @IBOutlet weak var progressButton: CXCircleProgressButton!
    
    lazy var photoLibHandle = CXPhotoLibraryAccessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        vSlider.cx.cornerRadius = vSlider.cx.width/2
        vSlider.maximumValue = 100
        vSlider.minimumValue = 0
        vSlider.maximumImage = UIColor.white.cx_drawImage()
        vSlider.minimumImage = UIColor.lightGray.cx.drawImage()
        vSlider.thumbImage = UIColor.black.cx.makeImageWithSize(CGSize(width: vSlider.cx.width, height: 20), cornerRadius: 10)
        vSlider.onValueChanged = { (value, ended) in
            print("value=\(value), ended=\(ended)")
        }
        vSlider.setValue(50, animated: true)
        
        progressButton.backgroundColor = .white
        progressButton.cx.cornerRadius = progressButton.cx.width/2
        progressButton.trackColor = UIColor.gray
        progressButton.progressColor = UIColor.orange
        progressButton.lineWidth = 4.0
        progressButton.animationDuration = 30
        progressButton.trackMargin = 5
        progressButton.reverse = true
        progressButton.onFinish = {
            print("The progress is finished.")
        }
        progressButton.startAnimation()
        
        //saveImageToPhotosAlbum()
        //saveToAssetCollection()
    }
    
    func saveToAssetCollection() {
        do {
            try photoLibHandle.addPhoto(CXImage(named: "avatar")!, toAlbum: "CXTest") { success, error in
                if success {
                    print("avatar 保存成功!")
                }
            }
            try photoLibHandle.addVideo(URL(localFilePath: Bundle.main.path(forResource: "sample_320x240", ofType: "mp4")!), toAlbum: "CXTestVideo", completionHandler: { success, error in
                if success {
                    print("sample_320x240.mp4 保存成功!")
                }
            })
        } catch CXPhotoLibraryAccessor.PHLError.failed(let description) {
            print("\(description)")
        } catch {
            print("\(error.localizedDescription)")
        }
        
        if let path = Bundle.main.path(forResource: "panorama_0", ofType: "jpg") {
            photoLibHandle.addPhoto(URL(localFilePath: path), completionHandler: { success, error in
                if success {
                    print("panorama_0.jpg 保存成功!")
                }
            })
        }
    }
    
    func saveImageToPhotosAlbum() {
        let image = UIImage(named: "avatar")
        image!.cx.saveToPhotosAlbum { image, error, context in
            if error == nil {
                CXLogger.log(level: .info, message: "saved complelely!")
            } else {
                CXLogger.log(level: .error, message: "error=\(error!)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
