//
//  CXDocumentPicker.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/9.
//

#if canImport(UIKit) && canImport(MobileCoreServices) && canImport(UniformTypeIdentifiers)
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

open class CXDocumentPicker: NSObject {
    
    private var picker: UIDocumentPickerViewController?
    private weak var controller: UIViewController!
    @objc public weak var delegate: CXDocumentDelegate?
    
    private var folderURL: URL?
    private var sourceType: CXDocumentSourceType!
    private var documents = [CXDocument]()
    private var documentTypes: [String] = []
    private var mutex = DispatchSemaphore(value: 1)
    
    @objc public var actionSheetTitle: String = "Select"
    @objc public var actionSheetFileTitle: String = "File"
    @objc public var actionSheetFolderTitle: String = "Folder"
    @objc public var actionSheetCancelTitle: String = "Cancel"
    @objc public var fullScreenEnabled: Bool = false
    
    convenience init(controller: UIViewController) {
        self.init(controller: controller, delegate: nil)
    }
    
    init(controller: UIViewController, delegate: CXDocumentDelegate?) {
        self.controller = controller
        self.delegate = delegate
    }
    
    private func presentDocumentPicker() {
        if sourceType == .folder {
            if #available(iOS 14.0, *) {
                let audioType = UTType.audio
                if documentTypes.contains(audioType.identifier) {
                    documentTypes.removeAll { $0 == audioType.identifier }
                }
                var types = documentTypes.compactMap { UTType.init($0) }
                let folderType = UTType.folder
                if !documentTypes.contains(folderType.identifier) { types.append(folderType) }
                picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
                let audioType = kUTTypeAudio as String
                if documentTypes.contains(audioType) { documentTypes.removeAll { $0 == audioType } }
                let folderType = kUTTypeFolder as String
                if !documentTypes.contains(folderType) { documentTypes.append(folderType) }
                picker = UIDocumentPickerViewController.init(documentTypes: documentTypes, in: .open)
            }
        } else if sourceType == .file {
            if #available(iOS 14.0, *) {
                let folderType = UTType.folder
                if documentTypes.contains(folderType.identifier) {
                    documentTypes.removeAll { $0 == folderType.identifier }
                }
                var types = documentTypes.compactMap { UTType.init($0) }
                let audioType = UTType.audio
                if !documentTypes.contains(audioType.identifier) { types.append(audioType) }
                picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
                let folderType = kUTTypeFolder as String
                if documentTypes.contains(folderType) { documentTypes.removeAll { $0 == folderType } }
                let audioType = kUTTypeAudio as String
                if !documentTypes.contains(audioType) { documentTypes.append(audioType) }
                picker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .open)
            }
        }
        if picker != nil {
            picker?.delegate = self
            if #available(iOS 13.0, *) {
                picker?.shouldShowFileExtensions = true
            }
            if #available(iOS 11.0, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                picker?.allowsMultipleSelection = true
            }
            if fullScreenEnabled {
                picker?.modalPresentationStyle = .fullScreen
            }
            controller.present(picker!, animated: true)
        }
    }
    
    private func folderAction(title: String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.sourceType = .folder
            self.presentDocumentPicker()
        }
    }
    
    private func fileAction(title: String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.sourceType = .file
            self.presentDocumentPicker()
        }
    }
    
    @objc public func present() {
        // Select
        let alertController = UIAlertController(title: actionSheetTitle, message: nil, preferredStyle: .actionSheet)
        
        // Files
        let fileAction = fileAction(title: actionSheetFileTitle)
        alertController.addAction(fileAction)
        // Folder
        let folderAction = folderAction(title: actionSheetFolderTitle)
        alertController.addAction(folderAction)
        // Cancel
        let cancelAction = UIAlertAction(title: actionSheetCancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = controller.view
            alertController.popoverPresentationController?.sourceRect = controller.view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        controller.present(alertController, animated: true)
    }
    
}

//MARK: - UINavigationControllerDelegate

extension CXDocumentPicker: UINavigationControllerDelegate {}

//MARK: - UIDocumentPickerDelegate

extension CXDocumentPicker: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        for url in urls {
            appendDocument(from: url)
        }
        delegate?.cxDidPickDocuments(documents)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        delegate?.cxDidPickDocuments(nil)
    }
    
    private func appendDocument(from pickedURL: URL) {
        mutex.wait()
        switch sourceType {
        case .file:
            let document = CXDocument(fileURL: pickedURL)
            documents.append(document)
            mutex.signal()
        case .folder:
            let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
            defer {
                if shouldStopAccessing { pickedURL.stopAccessingSecurityScopedResource() }
            }
            NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
                let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
                if let urls = FileManager.default.enumerator(at: folderURL, includingPropertiesForKeys: keys) {
                    for case let fileURL as URL in urls {
                        if !fileURL.cx.isDirectory {
                            let document = CXDocument(fileURL: fileURL)
                            self.documents.append(document)
                        }
                    }
                }
                self.mutex.signal()
            }
        case .none: break
        }
    }
    
}

#endif
