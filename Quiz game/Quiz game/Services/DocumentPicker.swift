//
//  DocumentPicker.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import UIKit
import SwiftUI
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var fileContent: String
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        
        if #available(iOS 14, *) {
            controller = UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: true)
        } else {
            controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText)], in: .import)
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @Binding var fileContent: String
    
    init(fileContent: Binding<String>) {
        _fileContent = fileContent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileURL = urls[0]
        do {
            fileContent = try String(contentsOf: fileURL, encoding: .utf8)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
