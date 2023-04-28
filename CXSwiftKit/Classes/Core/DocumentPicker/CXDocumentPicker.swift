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
    private weak var _controller: UIViewController!
    private weak var _delegate: CXDocumentDelegate?
    
    private var folderURL: URL?
    private var sourceType: CXDocumentSourceType!
    private var documents = [CXDocument]()
    
    struct PresentationType: OptionSet {
        let rawValue: Int8
        
        static let folder = PresentationType(rawValue: 1 << 0)
        static let file = PresentationType(rawValue: 1 << 1)
        
        static let all: PresentationType = [.folder, .file]
    }
    
    private var _presentationType: PresentationType
    private var _documentTypes: [String] = []
    
    init(controller: UIViewController, delegate: CXDocumentDelegate, presentationType: PresentationType = [.file], documentTypes: [String] = []) {
        self._controller = controller
        self._delegate = delegate
        self._presentationType = presentationType
        self._documentTypes = documentTypes
    }
    
    private func showDocumentPicker() {
        if sourceType == .folder {
            if #available(iOS 14.0, *) {
                let audioType = UTType.audio
                if _documentTypes.contains(audioType.identifier) {
                    _documentTypes.removeAll { $0 == audioType.identifier }
                }
                var types = _documentTypes.compactMap { UTType.init($0) }
                let folderType = UTType.folder
                if !_documentTypes.contains(folderType.identifier) { types.append(folderType) }
                self.picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
                let audioType = kUTTypeAudio as String
                if _documentTypes.contains(audioType) { _documentTypes.removeAll { $0 == audioType } }
                let folderType = kUTTypeFolder as String
                if !_documentTypes.contains(folderType) { _documentTypes.append(folderType) }
                self.picker = UIDocumentPickerViewController.init(documentTypes: _documentTypes, in: .open)
            }
        } else if sourceType == .file {
            if #available(iOS 14.0, *) {
                let folderType = UTType.folder
                if _documentTypes.contains(folderType.identifier) {
                    _documentTypes.removeAll { $0 == folderType.identifier }
                }
                var types = _documentTypes.compactMap { UTType.init($0) }
                let audioType = UTType.audio
                if !_documentTypes.contains(audioType.identifier) { types.append(audioType) }
                self.picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
                let folderType = kUTTypeFolder as String
                if _documentTypes.contains(folderType) { _documentTypes.removeAll { $0 == folderType } }
                let audioType = kUTTypeAudio as String
                if !_documentTypes.contains(audioType) { _documentTypes.append(audioType) }
                self.picker = UIDocumentPickerViewController(documentTypes: _documentTypes, in: .open)
            }
        }
        self.picker!.delegate = self
        if #available(iOS 13.0, *) {
            self.picker!.shouldShowFileExtensions = true
        }
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
            self.picker!.allowsMultipleSelection = sourceType == .folder ? true : false
        }
        self.picker!.modalPresentationStyle = .fullScreen
        self._controller.present(self.picker!, animated: true)
    }
    
    private func folderAction(title: String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.sourceType = .folder
            self.showDocumentPicker()
        }
    }
    
    private func fileAction(title: String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.sourceType = .file
            self.showDocumentPicker()
        }
    }
    
    public func present() {
        /// Select
        let alertController = UIAlertController(title: "选择", message: nil, preferredStyle: .actionSheet)
        if _presentationType == .file {
            let action = self.fileAction(title: "文件")
            alertController.addAction(action)
        } else if _presentationType == .folder {
            let action = self.folderAction(title: "文件夹")
            alertController.addAction(action)
        } else if _presentationType == .all {
            /// Files
            let fileAction = self.fileAction(title: "文件")
            alertController.addAction(fileAction)
            /// Folder
            let folderAction = self.folderAction(title: "文件夹")
            alertController.addAction(folderAction)
        }
        /// Cancel
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = _controller.view
            alertController.popoverPresentationController?.sourceRect = _controller.view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self._controller.present(alertController, animated: true)
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
        guard let url = urls.first else {
            return
        }
        documentFromURL(pickedURL: url)
        //_delegate?.didPickDocuments(documents: documents)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        //_delegate?.didPickDocuments(documents: nil)
    }
    
    private func documentFromURL(pickedURL: URL) {
        switch sourceType {
        case .file:
            let document = CXDocument(fileURL: pickedURL)
            documents.append(document)
            
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
            }
        case .none: break
        }
    }
    
}

#endif
