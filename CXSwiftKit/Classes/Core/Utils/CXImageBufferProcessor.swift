//
//  CXImageBufferProcessor.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

import Foundation
#if os(iOS)
import UIKit
import CoreMedia
import CoreVideo
import Accelerate
#endif

public class CXImageBufferProcessor: NSObject {
    
    #if os(iOS)
    /// CMSampleBuffer -> UIImage
    @objc public func transformToImage(forSampleBuffer sampleBuffer: CMSampleBuffer) -> UIImage? {
        // 获取CMSampleBuffer的核心视频图像缓冲的媒体数据
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        // 锁定像素缓冲区的基址
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        // 获取像素缓冲区的每行字节数
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        
        // 获取像素缓冲区的每行字节数
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        // 获取像素缓冲的宽度和高度
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        // 创建一个设备相关的RGB颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 使用示例缓冲区数据创建位图图形上下文
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            return nil
        }
        // 根据位图图形上下文中的像素数据创建一个Quartz图像
        guard let quartzImage = context.makeImage() else {
            return nil
        }
        // 解锁像素缓冲区
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let image = UIImage(cgImage: quartzImage)
        return image
    }
    
    /// UIImage -> CVPixelBuffer
    @objc public func transformToPixelBuffer(_ image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace,  bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            return nil
        }
        
        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
    
    /// ARKit中提取到的CVPixelBuffer为YUV420格式，很多时候需要把它转换为RGB格式
    @objc public func transformToImage(forPixelBuffer pixelBuffer: CVPixelBuffer) -> UIImage? {
        // 获取 CVPixelBuffer 类型
        //let osType = CVPixelBufferGetPixelFormatType(pixelBuffer)
        // 在访问buffer内部裸数据的地址時（读或写都一样），需要先将其锁上，用完了再放开
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        // defer block里的代码会在函数 return 之前执行
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        }
        
        // ARKit中通过ARFrame获取的CVPixelBuffer为YUV420格式，YUV420格式Y通道（Luminance）与UV通道（Chrominance）分开储存数据，可通过下面语句获取地址
        let lumaBaseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0)
        let chromaBaseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1)
        
        // 创建vImage_Buffer，参数中包含三个vImage buffer，前两个参数需要基于Y通道与UV通道地址初始化：
        // srcYp：
        let lumaWidth = CVPixelBufferGetWidthOfPlane(pixelBuffer, 0)
        let lumaHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0)
        let lumaRowBytes = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0)
        var sourceLumaBuffer = vImage_Buffer(data: lumaBaseAddress, height: vImagePixelCount(lumaHeight), width: vImagePixelCount(lumaWidth), rowBytes: lumaRowBytes)
        
        // srcCbCr：
        let chromaWidth = CVPixelBufferGetWidthOfPlane(pixelBuffer, 1)
        let chromaHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1)
        let chromaRowBytes = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1)
        var sourceChromaBuffer = vImage_Buffer(data: chromaBaseAddress, height: vImagePixelCount(chromaHeight), width: vImagePixelCount(chromaWidth), rowBytes: chromaRowBytes)
        
        // 参数中第三个vImage buffer需要初始化一个新的buffer，dest：
        let rawRGBBuffer: UnsafeMutableRawPointer = malloc(lumaWidth * lumaHeight * 4)
        var rgbBuffer: vImage_Buffer = vImage_Buffer(data: rawRGBBuffer, height: vImagePixelCount(lumaHeight), width: vImagePixelCount(lumaWidth), rowBytes: lumaWidth * 4)
        
        // 第四个参数info
        guard var conversionInfoYpCbCrToARGB = _conversionInfoYpCbCrToARGB else {
            return nil
        }
        
        // 利用函数进行转换
        guard vImageConvert_420Yp8_CbCr8ToARGB8888(&sourceLumaBuffer, &sourceChromaBuffer, &rgbBuffer, &conversionInfoYpCbCrToARGB, nil, 255, vImage_Flags(kvImageNoFlags)) == kvImageNoError else {
            return nil
        }
        
        // 把RGB格式的buffer转换为UIImage，注意bitmapInfo的值
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(data: rgbBuffer.data, width: lumaWidth, height: lumaHeight, bitsPerComponent: 8, bytesPerRow: rgbBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }
        
        guard let imageRef = ctx.makeImage() else {
            return nil
        }
        let uiimage = UIImage(cgImage: imageRef)
        
        // 释放rawRGBBuffer
        rawRGBBuffer.deallocate()
        return uiimage
    }
    
    private var _conversionInfoYpCbCrToARGB: vImage_YpCbCrToARGB? = {
        var pixelRange = vImage_YpCbCrPixelRange(Yp_bias: 16, CbCr_bias: 128, YpRangeMax: 235, CbCrRangeMax: 240, YpMax: 235, YpMin: 16, CbCrMax: 240, CbCrMin: 16)
        var infoYpCbCrToARGB = vImage_YpCbCrToARGB()
        guard vImageConvert_YpCbCrToARGB_GenerateConversion(kvImage_YpCbCrToARGBMatrix_ITU_R_601_4!, &pixelRange, &infoYpCbCrToARGB, kvImage422CbYpCrYp8, kvImageARGB8888, vImage_Flags(kvImageNoFlags)) == kvImageNoError else {
            return nil
        }
        return infoYpCbCrToARGB
    }()
    #endif
    
}
