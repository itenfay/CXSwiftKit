//
//  CXDocumentPicker.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/9.
//

#if os(iOS)
import UIKit
#if canImport(MobileCoreServices) && canImport(UniformTypeIdentifiers)
import MobileCoreServices
import UniformTypeIdentifiers

@objc public protocol ISKDocumentPicker: AnyObject {
    var actionSheetTitle: String { get set }
    var actionSheetFileTitle: String { get set }
    var actionSheetFolderTitle: String { get set }
    var actionSheetCancelTitle: String { get set }
    var fullScreenEnabled: Bool { get set }
    init(controller: UIViewController, delegate: CXDocumentDelegate?)
    func present()
    /// The document type must be `public.folder`, `public.item`, `public.data`, etc.
    func present(documentTypes: [String])
}

open class CXDocumentPicker: NSObject {
    
    private var picker: UIDocumentPickerViewController?
    private weak var controller: UIViewController!
    @objc public weak var delegate: CXDocumentDelegate?
    
    private var folderURL: URL?
    private var sourceType: CXDocumentSourceType = .none
    private var documents = [CXDocument]()
    private var documentTypes: [String] = []
    
    public var actionSheetTitle: String = "Select"
    public var actionSheetFileTitle: String = "File"
    public var actionSheetFolderTitle: String = "Folder"
    public var actionSheetCancelTitle: String = "Cancel"
    public var fullScreenEnabled: Bool = false
    
    required public init(
        controller: UIViewController,
        delegate: CXDocumentDelegate?)
    {
        self.controller = controller
        self.delegate = delegate
    }
    
    @objc public convenience init(
        controller: UIViewController)
    {
        self.init(controller: controller, delegate: nil)
    }
    
    private func presentDocumentPicker() {
        if sourceType == .folder {
            if #available(iOS 14.0, *) {
                let folderType = UTType.folder
                if !documentTypes.contains(folderType.identifier) {
                    documentTypes.append(folderType.identifier)
                }
                let types = documentTypes.compactMap { UTType($0) }
                picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
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
        } else {
            if #available(iOS 14.0, *) {
                let types = documentTypes.compactMap { UTType($0) }
                picker = UIDocumentPickerViewController.init(forOpeningContentTypes: types)
            } else {
                picker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .open)
            }
        }
        if picker == nil { return }
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
    
    public func present() {
        // Select
        let sheetController = UIAlertController(title: actionSheetTitle, message: nil, preferredStyle: .actionSheet)
        
        // Files
        let fileAction = fileAction(title: actionSheetFileTitle)
        sheetController.addAction(fileAction)
        // Folder
        let folderAction = folderAction(title: actionSheetFolderTitle)
        sheetController.addAction(folderAction)
        // Cancel
        let cancelAction = UIAlertAction(title: actionSheetCancelTitle, style: .cancel, handler: nil)
        sheetController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            sheetController.popoverPresentationController?.sourceView = controller.view
            sheetController.popoverPresentationController?.sourceRect = controller.view.bounds
            sheetController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        controller.present(sheetController, animated: true)
    }
    
    public func present(documentTypes: [String]) {
        self.documentTypes = documentTypes
        if documentTypes.isEmpty {
            present()
        } else {
            presentDocumentPicker()
        }
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
#endif
