//
//  QuadCurveViewController.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CXSwiftKit

class QuadCurveViewController: BaseViewController {
    
    private var imageView: UIImageView!
    private var imageView2: UIImageView!
    private var imageView3: UIImageView!
    private var imageView4: UIImageView!
    
    private var isDrawed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        
    }
    
    override func makeUI() {
        view.backgroundColor = .white
        let paddingY: CGFloat = 20
        
        imageView = UIImageView()
        imageView.image = CXImage(named: "panorama_10")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.cx.makeConstraints { make in
            make.top.equalToAnchor(self.view.cx.safeTopAnchor)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        imageView2 = UIImageView()
        imageView2.image = CXImage(named: "panorama_11")
        imageView2.contentMode = .scaleAspectFill
        imageView2.clipsToBounds = true
        view.addSubview(imageView2)
        imageView2.cx.makeConstraints { [weak self] make in
            guard let s = self else { return }
            make.top.equalToAnchor(s.imageView.bottomAnchor).offset(paddingY)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        imageView3 = UIImageView()
        imageView3.image = CXImage(named: "panorama_11")
        imageView3.contentMode = .scaleAspectFill
        imageView3.clipsToBounds = true
        view.addSubview(imageView3)
        imageView3.cx.makeConstraints { [weak self] make in
            guard let s = self else { return }
            make.top.equalToAnchor(s.imageView2.bottomAnchor).offset(paddingY)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        imageView4 = UIImageView()
        imageView4.image = CXImage(named: "panorama_18")
        imageView4.contentMode = .scaleAspectFill
        imageView4.clipsToBounds = true
        view.addSubview(imageView4)
        imageView4.cx.makeConstraints { [weak self] make in
            guard let s = self else { return }
            make.top.equalToAnchor(s.imageView3.bottomAnchor).offset(paddingY)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if isDrawed { return }
        isDrawed = true
        drawQuadCurve()
    }
    
    func drawQuadCurve() {
        imageView.cx.drawQuadCurve(withRadian: 30, direction: .bottom)
        imageView2.cx.drawQuadCurve(withRadian: 10, direction: .right, fillColor: CXColor.cx.color(withHexString: "#999999"))
        imageView3.cx.drawQuadCurve(withRadian: 40, direction: .top)
        imageView4.cx.drawQuadCurve(withRadian: 20, direction: .left)
    }
    
}
