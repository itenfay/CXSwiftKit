//
//  PhotoLibraryViewController.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit
import RxSwift
import RxCocoa

class PhotoLibraryViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private lazy var photoLibHandle = CXPhotoLibraryOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "相簿"
    }
    
    override func configure() {
        
    }
    
    override func makeUI() {
        let paddingX: CGFloat = 15
        let paddingY: CGFloat = 10
        let btnW = (cxScreenWidth - 5*paddingX) / 4
        let btnH: CGFloat = 40
        
        let btnA = UIButton(type: .custom)
        btnA.backgroundColor = .gray
        btnA.setTitle("保存Avatar", for: .normal)
        btnA.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnA.layer.cornerRadius = 10
        btnA.showsTouchWhenHighlighted = true
        view.addSubview(btnA)
        btnA.cx.makeConstraints { maker in
            maker.top.equalToAnchor(self.view.cx.safeTopAnchor).offset(paddingY)
            maker.leading.equalTo(paddingX)
            maker.width.equalTo(btnW)
            maker.height.equalTo(btnH)
        }
        btnA.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.saveToAssetCollection(with: 1)
        }).disposed(by: disposeBag)
        
        let btnB = UIButton(type: .custom)
        btnB.backgroundColor = .gray
        btnB.setTitle("保存Image", for: .normal)
        btnB.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnB.layer.cornerRadius = 10
        btnB.showsTouchWhenHighlighted = true
        view.addSubview(btnB)
        btnB.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnA.topAnchor).offset(0)
            maker.leading.equalToAnchor(btnA.trailingAnchor).offset(paddingX)
            maker.width.equalToDimension(btnA.widthAnchor)
            maker.height.equalToDimension(btnA.heightAnchor)
        }
        btnB.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.saveToAssetCollection(with: 2)
        }).disposed(by: disposeBag)
        
        let btnC = UIButton(type: .custom)
        btnC.backgroundColor = .gray
        btnC.setTitle("保存Video", for: .normal)
        btnC.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnC.layer.cornerRadius = 10
        btnC.showsTouchWhenHighlighted = true
        view.addSubview(btnC)
        btnC.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnB.topAnchor)
            maker.leading.equalToAnchor(btnB.trailingAnchor).offset(paddingX)
            maker.width.equalToDimension(btnB.widthAnchor).offset(0)
            maker.height.equalToDimension(btnB.heightAnchor).offset(0)
        }
        btnC.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.saveToAssetCollection(with: 3)
        }).disposed(by: disposeBag)
        
        let btnD = UIButton(type: .custom)
        btnD.backgroundColor = .gray
        btnD.setTitle("获取Albums", for: .normal)
        btnD.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 16)
        btnD.layer.cornerRadius = 10
        btnD.showsTouchWhenHighlighted = true
        view.addSubview(btnD)
        btnD.cx.makeConstraints { maker in
            maker.top.equalToAnchor(btnC.topAnchor)
            maker.leading.equalToAnchor(btnC.trailingAnchor).offset(paddingX)
            maker.width.equalTo(btnW)
            maker.height.equalTo(btnH)
        }
        btnD.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.saveToAssetCollection(with: 4)
        }).disposed(by: disposeBag)
    }
    
    private func saveToAssetCollection(with type: Int) {
        cx.showProgressHUD(withStatus: "处理中...")
        if type == 1 {
            saveAvatarToPhotosAlbum()
            return
        } else if type == 4 {
            let scale = UIScreen.main.scale
            let albumModels = photoLibHandle.listAlbums()
            for model in albumModels {
                CXLogger.log(level: .info, message: "name=\(model.name), identifier=\(model.identifier), count=\(model.count)")
                let assets = photoLibHandle.fetchAssets(inAssetCollection: model.assetCollection)
                for asset in assets {
                    if asset.mediaType == .image {
                        if asset.mediaSubtypes == .photoLive {
                            photoLibHandle.fetchLivePhoto(fromAsset: asset, targetSize: CGSize(width: CGFloat(asset.pixelWidth)/scale, height: CGFloat(asset.pixelHeight)/scale), contentMode: .aspectFill) { livePhoto in
                                CXLogger.log(level: .info, message: "livePhoto=\(livePhoto?.description ?? "")")
                            }
                        } else {
                            photoLibHandle.fetchImage(fromAsset: asset, targetSize: CGSize(width: CGFloat(asset.pixelWidth)/scale, height: CGFloat(asset.pixelHeight)/scale), contentMode: .aspectFill) { image, info in
                                CXLogger.log(level: .info, message: "image=\(String(describing: image))")
                            }
                        }
                    } else if asset.mediaType == .video {
                        photoLibHandle.fetchVideoAsset(fromAsset: asset) { avAsset, audioMix, info in
                            CXLogger.log(level: .info, message: "avAsset=\(String(describing: avAsset))")
                        }
                    }
                }
            }
            cx.dismissProgressHUD()
            return
        }
        do {
            switch type {
            case 2:
                guard let path = Bundle.main.path(forResource: "panorama_10", ofType: "jpg") else {
                    return
                }
                try photoLibHandle.addPhoto(URL(localFilePath: path), toAlbum: "CXAlbum", completionHandler: { [weak self] success, error in
                    DispatchQueue.cx.mainSync {
                        if success {
                            CXLogger.log(level: .info, message: "panorama_0.jpg 保存成功!")
                            self?.cx_showMessages(withStyle: .light, body: "panorama_0.jpg 保存成功!")
                        }
                        self?.cx.dismissProgressHUD()
                    }
                })
            case 3:
                try photoLibHandle.addVideo(URL(localFilePath: Bundle.main.path(forResource: "sample_320x240", ofType: "mp4")!), toAlbum: "CXTestVideo", completionHandler: { [weak self] success, error in
                    DispatchQueue.cx.mainSync {
                        if success {
                            CXLogger.log(level: .info, message: "sample_320x240.mp4 保存成功!")
                            self?.cx_showMessages(withStyle: .dark, body: "sample_320x240.mp4 保存成功!")
                        }
                        self?.cx.dismissProgressHUD()
                    }
                })
            default: break
            }
        } catch CXPhotoLibraryOperator.PHLError.failed(let description) {
            CXLogger.log(level: .info, message:"\(description)")
            cx.dismissProgressHUD()
        } catch {
            CXLogger.log(level: .info, message:"\(error.localizedDescription)")
            cx.dismissProgressHUD()
        }
    }
    
    private func saveAvatarToPhotosAlbum() {
        let image = UIImage(named: "avatar")
        image!.cx.saveToPhotosAlbum { [weak self] image, error, context in
            DispatchQueue.cx.mainSync {
                if error == nil {
                    CXLogger.log(level: .info, message: "save complelely!")
                    self?.cx_showMessages(withStyle: .light, body: "Avatar 保存成功!")
                } else {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                self?.cx.dismissProgressHUD()
            }
        }
    }
    
}
