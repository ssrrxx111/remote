//
//  FileManager.swift
//  NewUstock
//
//  Created by Kyle on 16/6/13.
//  Copyright © 2016年 ustock. All rights reserved.
//

import UIKit

public struct FileManagerItems {

	fileprivate var items: [String] = []

	fileprivate init() {
	}

	func all() -> [String] {
		return self.items
	}

	func filter(_ contants: String) -> [String] {
		var filterItems: [String] = []
		for item in self.items {
			if item.contains(contants) {
				filterItems.append(item)
			}
		}
		return filterItems
	}

}

extension FileManagerPath {

	public func write(_ data: Data) -> Bool {
		return ((try? data.write(to: URL(fileURLWithPath: self.path), options: [.atomic])) != nil)
	}

	public func read() -> Data? {
		return FileManager.default.contents(atPath: self.path)
	}

	public func delete() {
		do {
			try FileManager.default.removeItem(atPath: self.path)
		} catch {
			SSLog("Delete Fail : \(self.path)")
		}
	}

	public func move(_ toPath: FileManagerPath) {
		do {
			try FileManager.default.moveItem(atPath: self.path, toPath: toPath.path)
		} catch {
			SSLog("Move Fail : \(self.path)")
		}
	}

	public func copy(_ toPath: FileManagerPath) {
		do {
			try FileManager.default.copyItem(atPath: self.path, toPath: toPath.path)
		} catch {
			SSLog("Copy Fail : \(self.path)")
		}
	}

}

extension FileManagerPath {

	fileprivate func createFolder(_ path: String) {
		if !FileManager.isExistIn(path) {
			do {
				try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
			} catch {
				SSLog("Create Fail : \(self.path)")
			}
		}
	}

	fileprivate func folderList(_ isFolder: Bool) -> FileManagerItems {
		var items = FileManagerItems()

		guard let safeItems = try? FileManager.default.contentsOfDirectory(atPath: self.path) else {
			SSLog("Path Fail")
			return items
		}

		var isDirectory: ObjCBool = false
		for item in safeItems {
			let itemPath = self.path + "/" + item
			FileManager.default.fileExists(atPath: itemPath, isDirectory: &isDirectory)

			if isDirectory.boolValue == isFolder {
				items.items.append(item)
			}
		}
		return items
	}

}

extension FileManagerPath {

	public var files: FileManagerItems {
		return self.folderList(false)
	}

	public var folders: FileManagerItems {
		return self.folderList(true)
	}

	public var path: String {
		return self.paths.joined(separator: "/") + (self.isFolder ? "/" : "")
	}

}

public struct FileManagerPath {

	fileprivate var paths: [String] = []

	fileprivate var isFolder: Bool = true

	fileprivate init() {
	}

	public subscript(path: String) -> FileManagerPath {
		var newFileManagerPath = self
		newFileManagerPath.isFolder = path.characters.last == "/"
		let splitPath = path.components(separatedBy: "/").filter { (eachPath) -> Bool in
			return (eachPath.characters.count > 0)
		}
		for eachPath in splitPath {
			newFileManagerPath.paths.append(eachPath)
			if eachPath != splitPath.last {
				newFileManagerPath.createFolder(newFileManagerPath.path)
			} else {
				if newFileManagerPath.isFolder {
					newFileManagerPath.createFolder(newFileManagerPath.path)
				}
			}
		}
		return newFileManagerPath
	}

}

extension FileManager {
    
    public static func isExistIn(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
	// documentPath
	public static var document: FileManagerPath {
        var newFileManager = FileManagerPath()
        guard let safeDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            SSLog("Get Document Path Fail")
            return newFileManager
        }
        newFileManager.paths.append(safeDocumentPath)
        return newFileManager
	}

	public static var resource: FileManagerPath {
        var newFileManager = FileManagerPath()
        newFileManager.paths.append(Bundle.main.bundlePath)
        return newFileManager
	}

	public static func custom(_ paths: [String]) -> FileManagerPath {
		var newFileManager = FileManagerPath()
		for path in paths {
			if path == paths.first {
				newFileManager.paths.append("/" + path)
			} else {
				newFileManager.paths.append(path)
			}
		}
		return newFileManager
	}

}
