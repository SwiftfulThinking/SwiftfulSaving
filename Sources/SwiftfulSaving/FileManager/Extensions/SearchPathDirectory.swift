//
//  SearchPathDirectory.swift
//  SwiftfulSaving
//
//  Created by Nick Sarno on 1/2/22.
//

import Foundation

extension FileManager.SearchPathDirectory {
    
    var name: String {
        switch self {
        case .applicationDirectory: return "applicationDirectory"
        case .demoApplicationDirectory: return "demoApplicationDirectory"
        case .developerApplicationDirectory: return "developerApplicationDirectory"
        case .adminApplicationDirectory: return "adminApplicationDirectory"
        case .libraryDirectory: return "libraryDirectory"
        case .developerDirectory: return "developerDirectory"
        case .userDirectory: return "userDirectory"
        case .documentationDirectory: return "documentationDirectory"
        case .documentDirectory: return "documentDirectory"
        case .coreServiceDirectory: return "coreServiceDirectory"
        case .autosavedInformationDirectory: return "autosavedInformationDirectory"
        case .desktopDirectory: return "desktopDirectory"
        case .cachesDirectory: return "cachesDirectory"
        case .applicationSupportDirectory: return "applicationSupportDirectory"
        case .downloadsDirectory: return "downloadsDirectory"
        case .inputMethodsDirectory: return "inputMethodsDirectory"
        case .moviesDirectory: return "moviesDirectory"
        case .musicDirectory: return "musicDirectory"
        case .picturesDirectory: return "picturesDirectory"
        case .printerDescriptionDirectory: return "printerDescriptionDirectory"
        case .sharedPublicDirectory: return "sharedPublicDirectory"
        case .preferencePanesDirectory: return "preferencePanesDirectory"
        case .itemReplacementDirectory: return "itemReplacementDirectory"
        case .allApplicationsDirectory: return "allApplicationsDirectory"
        case .allLibrariesDirectory: return "allLibrariesDirectory"
        case .trashDirectory: return "trashDirectory"
        default:
            return "WARNING: UNKNOWN DIRECTORY"
        }
    }
}
