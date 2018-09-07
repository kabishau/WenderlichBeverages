import UIKit
import PDFKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var documentsStackView: UIStackView!
  @IBOutlet weak var imageView1: UIImageView!
  @IBOutlet weak var imageView2: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preloadDocuments()
    loadDocumentThumbnails()
  }
  
  private func preloadDocuments() {
    for document in SalesDocument.allDocuments() {
      let documentPath = FileUtilities.documentsDirectory().appending("/\(document.nameWithExtension())")
      if !FileManager.default.fileExists(atPath: documentPath) {
        guard let pdfPath = Bundle.main.path(forResource: document.rawValue, ofType: "pdf"),
          let pdfDocument = PDFDocument(url: URL(fileURLWithPath: pdfPath)) else { continue }
        pdfDocument.write(toFile: documentPath)
      }
    }
  }
  
  private func loadDocumentThumbnails() {
    let document1Path = FileUtilities.documentsDirectory().appending("/\(SalesDocument.wbCola.nameWithExtension())")
    let colaDocument = PDFDocument(url: URL(fileURLWithPath: document1Path))
    let document2Path = FileUtilities.documentsDirectory().appending("/\(SalesDocument.wbRaysReserve.nameWithExtension())")
    let rrDocument = PDFDocument(url: URL(fileURLWithPath: document2Path))
    imageView1.image = thumbnailImageForPDFDocument(document: colaDocument)
    imageView2.image = thumbnailImageForPDFDocument(document: rrDocument)
  }
  
  private func thumbnailImageForPDFDocument(document: PDFDocument?) -> UIImage? {
    guard let document = document,
      let page = document.page(at: 0) else { return nil }
    return page.thumbnail(of: CGSize(width: documentsStackView.frame.size.width, height: documentsStackView.frame.size.height / 2), for: .cropBox)
  }
  
  @IBAction func showDocument(_ sender: UITapGestureRecognizer) {
    guard let view = sender.view as? UIImageView else { return }
    let document: String
    if view === imageView1 {
      document = SalesDocument.wbCola.nameWithExtension()
    } else {
      document = SalesDocument.wbRaysReserve.nameWithExtension()
    }
    let urlPath = URL(fileURLWithPath: FileUtilities.documentsDirectory().appending("/\(document)"))
    let pdfDocument = PDFDocument(url: urlPath)
    performSegue(withIdentifier: SegueIdentifiers.showDocumentSegue.rawValue, sender: pdfDocument)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    if identifier == SegueIdentifiers.showDocumentSegue.rawValue {
      if let document = sender as? PDFDocument,
        let upcoming = segue.destination as? DocumentViewController {
        upcoming.document = document
        upcoming.title = "Sales Document"
      }
    }
  }
  
}
