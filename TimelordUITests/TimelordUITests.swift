import XCTest

// UI testing Siri:
// https://stackoverflow.com/a/45740212/293215

class TimelordUITests: XCTestCase {

    func testExample() {
        let siri = XCUIDevice.shared.siriService
        siri.activate(
            voiceRecognitionText: "In Timelord remind me in 30 minutes to take yams out")
        wait(seconds: 3)
        siri.activate(
            voiceRecognitionText: "Show my Timelord reminders")
    }

    private func wait(seconds: Int) {
        wait(
            for: [
                expectation(
                    for: NSPredicate { _, _ in
                        sleep(UInt32(seconds))
                        return true
                    },
                    evaluatedWith: self,
                    handler: nil)],
            timeout: TimeInterval(seconds) + 1)
    }
}
