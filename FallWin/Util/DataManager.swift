//
//  DataManager.swift
//  FallWin
//
//  Created by 최명근 on 10/16/23.
//

import Foundation
import UIKit

final class DataManager {
    static let shared = DataManager()
    
    init() { }
}

// MARK: - Image
extension DataManager {
    func saveImage(_ image: UIImage) -> String? {
        let name = UUID().uuidString
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileUrl = documentUrl.appendingPathComponent(name, conformingTo: .jpeg)
        
        do {
            if let data = image.jpegData(compressionQuality: 1) {
                try data.write(to: fileUrl)
                print(#function, "Image saved at", fileUrl)
                
                return name
                
            } else {
                print(#function, "Cannot compress image")
            }
            
        } catch {
            print(#function, error)
        }
        
        return nil
    }
    
    func loadImage(name: String) -> UIImage? {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileUrl = documentUrl.appendingPathComponent(name, conformingTo: .jpeg)
        
        if FileManager.default.fileExists(atPath: fileUrl.path()) {
            return UIImage(contentsOfFile: fileUrl.path())
            
        } else {
            print(#function, "File not exists at path", fileUrl.path())
        }
        
        return nil
    }
    
    func deleteImage(name: String) -> Bool {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        let fileUrl = documentUrl.appendingPathComponent(name, conformingTo: .jpeg)
        
        do {
            try FileManager.default.removeItem(atPath: fileUrl.path())
            return true
            
        } catch {
            print(#function, error)
        }
        
        return false
    }
    
}
