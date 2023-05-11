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
    
    @objc public var actionSheetTitle: String = "Select"
    @objc public var actionSheetFileTitle: String = "File"
    @objc public var actionSheetFolderTitle: String = "Folder"
    @objc public var actionSheetCancelTitle: String = "Cancel"
    @objc public var fullScreenEnabled: Bool = false
    
    @objc public convenience init(controller: UIViewController) {
        self.init(controller: controller, delegate: nil)
    }
    
    @objc public init(controller: UIViewController, delegate: CXDocumentDelegate?) {
        self.controller = controller
        self.delegate = delegate
    }
    
    private func presentDocumentPicker() {
        if sourceType == .folder {
            if #available(iOS 14.0, *) {
                if documentTypes.isEmpty {
                    documentTypes.append(UTType.item.identifier)
                }
                let folderType = UTType.folder
                if !documentTypes.contains(folderType.identifier) {
                    documentTypes.append(folderType.identifier)
                }
                let types = documentTypes.compactMap { UTType($0) }
                picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
                if documentTypes.isEmpty {
                    documentTypes.append(kUTTypeItem as String)
                }
                let folderType = kUTTypeFolder as String
                if !documentTypes.contains(folderType) { documentTypes.append(folderType) }
                picker = UIDocumentPickerViewController.init(documentTypes: documentTypes, in: .open)
            }
        } else if sourceType == .file {
            if #available(iOS 14.0, *) {
                if documentTypes.isEmpty {
                    documentTypes.append(UTType.data.identifier)
                }
                let types = documentTypes.compactMap { UTType($0) }
                picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
                if documentTypes.isEmpty {
                    documentTypes.append(kUTTypeData as String)
                }
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
    
    @objc public func present(documentTypes: [String]) {
        self.documentTypes = documentTypes
        
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
        switch sourceType {
        case .file:
            let document = CXDocument(fileURL: pickedURL)
            documents.append(document)
        case .folder:
            let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
            defer {
                if shouldStopAccessing { pickedURL.stopAccessingSecurityScopedResource() }
            }
            NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { folderURL in
                let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
                if let directoryEnumerator = FileManager.default.enumerator(
                    at: folderURL,
                    includingPropertiesForKeys: Array(resourceKeys),
                    options: .skipsHiddenFiles)
                {
                    for case let fileURL as URL in directoryEnumerator {
                        guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                              let isDirectory = resourceValues.isDirectory,
                              let name = resourceValues.name
                        else {
                            continue
                        }
                        if isDirectory {
                            if name == "_extras" {
                                directoryEnumerator.skipDescendants()
                            }
                        } else {
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
