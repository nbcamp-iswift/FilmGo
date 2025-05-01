import Foundation

@objc(SecureStringArrayTransformer)
final class SecureStringArrayTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        [NSArray.self, NSString.self]
    }

    static func register() {
        let name = NSValueTransformerName("SecureStringArrayTransformer")
        let transformer = SecureStringArrayTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
