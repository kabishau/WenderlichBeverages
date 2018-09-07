import UIKit
import PDFKit

class ContractsTableViewController: UITableViewController {
  
  var documents: [String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadDocuments()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    if identifier == SegueIdentifiers.newContractSegue.rawValue {
      guard let pdfPath = Bundle.main.path(forResource: ContractDocument.contractTemplate.rawValue, ofType: "pdf"),
        let upcoming = segue.destination as? DocumentViewController else {
          return
      }
      upcoming.document = PDFDocument(url: URL(fileURLWithPath: pdfPath))
      upcoming.title = "New Contract"
      upcoming.addAnnotations = true
      upcoming.delegate = self
    } else if identifier == SegueIdentifiers.currentContract.rawValue {
      guard let upcoming = segue.destination as? DocumentViewController,
        let cell = sender as? UITableViewCell,
        let indexPath = tableView.indexPath(for: cell),
        let documents = documents else { return }
      let document = documents[indexPath.row]
      upcoming.addAnnotations = false
      upcoming.title = document
      let path = FileUtilities.contractsDirectory().appending("/\(document)")
      upcoming.document = PDFDocument(url: URL(fileURLWithPath: path))
      upcoming.delegate = self
    }
  }
  
  func loadDocuments() {
    documents = try? FileManager.default.contentsOfDirectory(atPath: FileUtilities.contractsDirectory())
    documents = documents?.filter { path -> Bool in
      return (path as NSString).pathExtension == "pdf"
    }
    tableView.reloadData()
  }
}

extension ContractsTableViewController: DocumentViewControllerDelegate {
  func didSaveDocument() {
    loadDocuments()
  }
}

// MARK: - Table view data source
extension ContractsTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let documents = documents else { return 0 }
    return documents.count
  }
}

// MARK: - Table view delegate
extension ContractsTableViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    if let documents = documents {
      let document = documents[indexPath.row]
      cell.textLabel?.text = (document as NSString).lastPathComponent
    }
    return cell
  }
}

