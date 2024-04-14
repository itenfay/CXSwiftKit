//
//  NetworkViewController.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CXSwiftKit
import MarsUIKit
import HandyJSON

class NetworkViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        btnA.setTitle("下载展示", for: .normal)
        btnA.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 15)
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
            self?.request(with: 1)
        }).disposed(by: disposeBag)
        
        let btnB = UIButton(type: .custom)
        btnB.backgroundColor = .gray
        btnB.setTitle("示例2", for: .normal)
        btnB.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 15)
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
            self?.request(with: 2)
        }).disposed(by: disposeBag)
        
        let btnC = UIButton(type: .custom)
        btnC.backgroundColor = .gray
        btnC.setTitle("示例3", for: .normal)
        btnC.titleLabel?.font = UIFont.cx.mediumPingFang(ofSize: 15)
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
            self?.request(with: 3)
        }).disposed(by: disposeBag)
        
        let btnD = UIButton(type: .custom)
        btnD.backgroundColor = .gray
        btnD.setTitle("示例4", for: .normal)
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
            self?.request(with: 4)
        }).disposed(by: disposeBag)
        
        imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.cx.makeConstraints { maker in
            maker.leading.equalTo(paddingX)
            maker.trailing.equalTo(-paddingX)
            maker.top.equalToAnchor(btnA.bottomAnchor).offset(paddingY)
            maker.height.equalTo(500)
        }
    }
    
    func request(with tag: Int) {
        UIDevice.current.cx.makeImpactFeedback(style: .heavy)
        if tag == 1 {
            let url = "https://atts.w3cschool.cn/attachments/image/20171028/1509160178371523.png"
            CXNetWorkManager.shared.request(api: StreamAPI(downloadURL: URL(string: url)!, toDirectory: "Images")) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.displayImage(with: String(data: data, encoding: .utf8))
                case .failure(let error):
                    CXLog.error("\(error.localizedDescription)")
                    DispatchQueue.cx.mainAsync {
                        self?.ms_showMessages(withStyle: .light, body: "1509160178371523.png下载失败")
                    }
                }
            }
        } else if tag == 2 {
            // Gets an image data.
            let base = "https://xxx.xxx.xx"
            let imgCodePath = "/auth/v1/verify/phoneImgCode"
            CXNetWorkManager.shared.request(api: API(baseUrl: base, path: imgCodePath, method: .get)) { [weak self] result in
                switch result {
                case .success(let data):
                    CXLog.info("data=\(data)")
                    if let image = UIImage(data: data) {
                        CXLog.info("Verified code image=\(image)")
                    }
                case .failure(let error):
                    CXLog.error("\(error.localizedDescription)")
                    DispatchQueue.cx.mainAsync {
                        self?.ms_showMessages(withStyle: .light, body: "获取图片验证码失败")
                    }
                }
            }
            // Gets cookies, and so on.
            CXNetWorkManager.shared.onRequestCompletion = { response in
                CXLog.info("response: \(response), httpURLRespone: \(String(describing: response.response))")
            }
        } else if tag == 3 {
            // Post
            ListResponse<MemberModel>.request(api: API(path: "https://xxx.xxx.xxx/getMembers", entity: MemberRequestEntity(id: "19384563"))) { result in
                switch result {
                case .success(let r):
                    if let members = r.data {
                        CXLog.info("members=\(members)")
                    }
                case .failure(let error):
                    CXLog.error("\(error.localizedDescription)")
                }
            }
        } else if tag == 4 {
            MessageResponse.request(api: API(baseUrl: "https://xxx.xxx.xxx", path: "/getMessage", method: .get)) { resust in
                switch resust {
                case .success(let r):
                    if let message = r.data {
                        CXLog.info("message=\(message)")
                    }
                case .failure(let error):
                    CXLog.error("\(error.localizedDescription)")
                }
            }
        }
    }
    
    private func displayImage(with filePath: String?) {
        guard let fp = filePath, fp.cx.isNotEmpty() else {
            return
        }
        CXLog.info("Image filePath=" + fp)
        DispatchQueue.cx.mainAsync {
            self.imageView.image = UIImage(contentsOfFile: fp)
        }
    }
    
}
