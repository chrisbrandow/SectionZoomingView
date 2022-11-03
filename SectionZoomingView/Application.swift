import UIKit

class Application: UIApplication {
    static let shakeNotification = Notification.Name("Hey, we shakin' up in here!")

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: Self.shakeNotification, object: nil)
        }
        super.motionBegan(motion, with: event)
    }
}
