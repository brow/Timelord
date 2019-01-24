import XCTest

class TimelordUITests: XCTestCase {

    func testExample() {
        // UI testing Siri:
        // https://stackoverflow.com/a/45740212/293215
        let siri = XCUIDevice.shared.siriService
        siri.activate(
            voiceRecognitionText: "In Timelord remind me in 30 minutes to take yams out")
        wait(
            for: [
                expectation(
                    for: NSPredicate { _, _ in sleep(3); return false },
                    evaluatedWith: siri,
                    handler: nil)],
            timeout: 5)
        siri.activate(
            voiceRecognitionText: "Show my Timelord reminders")
    }

}
