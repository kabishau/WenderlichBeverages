import UIKit
import PDFKit

class LockedMark: PDFPage {
  override func draw(with box: PDFDisplayBox, to context: CGContext) {
    super.draw(with: box, to: context)
    UIGraphicsPushContext(context)
    context.saveGState()
    let pageBounds = self.bounds(for: box)
    context.translateBy(x: 0.0, y: pageBounds.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    
    let string: NSString = "SIGNED"
    let attributes: [NSAttributedStringKey: Any] = [
      NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5),
      NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 30)
    ]
    string.draw(at: CGPoint(x:250, y:40), withAttributes: attributes)
    context.restoreGState()
    UIGraphicsPopContext()
  }
}
