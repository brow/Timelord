import UIKit

extension UIApplication {
  func open(_ URL: URL) {
    open(URL, options: [:], completionHandler: nil)
  }
  
  func openSettings() {
    if let URL = URL(string: UIApplication.openSettingsURLString) {
      open(URL)
    }
  }
}
