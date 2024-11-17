//
//  VPlayerController.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/17.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation
import CXSwiftKit

class VPlayerController: BaseViewController {
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    private(set) var path: String?
    private var sliderDragging: Bool = false
    
    convenience init(path: String?) {
        self.init(nibName: nil, bundle: nil)
        self.path = path
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeUI() {
        guard let localPath = path else {
            print("[Warning]: the path can not be nil.")
            return
        }
        
        let slider = UISlider(frame: CGRect(x: 30, y: cxNavBarH + cxAdapt(400), width: cxScreenWidth - 60, height: 50))
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(slider)
        
        player = AVPlayer(url: URL(localFilePath: localPath))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: cxNavBarH + cxAdapt(20), width: cxScreenWidth, height: cxScreenWidth * 9 / 16)
        playerLayer.backgroundColor = UIColor.black.cgColor
        view.layer.addSublayer(playerLayer)
        
        player.play()
        
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self] time in
            guard let s = self, let item = s.player.currentItem else {
                return
            }
            if s.sliderDragging {
                return
            }
            slider.value = Float(CMTimeGetSeconds(time) / CMTimeGetSeconds(item.duration))
        }
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        sliderDragging = true
        guard let item = player.currentItem else {
            sliderDragging = false
            return
        }
        let time = slider.value * Float(CMTimeGetSeconds(item.duration))
        if time.isNaN || time.isInfinite {
            sliderDragging = false
            return
        }
        player.seek(to: CMTime(value: CMTimeValue(time), timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
            if !finished { return }
            self?.sliderDragging = false
            self?.player.play()
        }
    }
    
}
