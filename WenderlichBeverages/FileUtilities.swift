import Foundation

struct FileUtilities {
  
  static func documentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
  }
  
  static func contractsDirectory() -> String {
    let contractsPath = (FileUtilities.documentsDirectory() as NSString).appendingPathComponent("contracts")
    var isDir : ObjCBool = false
    if !FileManager.default.fileExists(atPath: contractsPath, isDirectory: &isDir) {
      try? FileManager.default.createDirectory(atPath: contractsPath, withIntermediateDirectories: true, attributes: nil)
    }
    return contractsPath
  }
  
  static func createdDocuments() -> String {
    let createdDocsPath = (FileUtilities.documentsDirectory() as NSString).appendingPathComponent("usercreated")
    var isDir : ObjCBool = false
    if !FileManager.default.fileExists(atPath: createdDocsPath, isDirectory: &isDir) {
      try? FileManager.default.createDirectory(atPath: createdDocsPath, withIntermediateDirectories: true, attributes: nil)
    }
    return createdDocsPath
  }
  
}

enum SalesDocument: String {
  case wbCola
  case wbRaysReserve
  
  func nameWithExtension() -> String {
    return (self.rawValue as NSString).appendingPathExtension("pdf")!
  }
  
  static func allDocuments() -> [SalesDocument] {
    return [.wbCola, .wbRaysReserve]
  }
}

enum ContractDocument: String {
  case contractTemplate
}
