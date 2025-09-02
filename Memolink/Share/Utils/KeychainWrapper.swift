import Foundation
import Security

enum KeychainAccessibility {
  case whenUnlocked
  case whenUnlockedThisDeviceOnly
  case afterFirstUnlock
  case afterFirstUnlockThisDeviceOnly
  
  var attribute: CFString {
    switch self {
    case .whenUnlocked:
      return kSecAttrAccessibleWhenUnlocked
    case .whenUnlockedThisDeviceOnly:
      return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    case .afterFirstUnlock:
      return kSecAttrAccessibleAfterFirstUnlock
    case .afterFirstUnlockThisDeviceOnly:
      return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    }
  }
}

struct Keychain<T: Codable> {
  static func set(_ value: T, key: String, accessibility: KeychainAccessibility = .whenUnlockedThisDeviceOnly) {
    do {
      let data = try JSONEncoder().encode(value)
      let query: [CFString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: key,
        kSecValueData: data,
        kSecAttrAccessible: accessibility.attribute,
        kSecAttrSynchronizable: false
      ]
      
      SecItemDelete(query as CFDictionary)
      
      let status = SecItemAdd(query as CFDictionary, nil)
    } catch {
      
    }
  }
  
  static func setSecureToken(_ value: T, key: String) {
    set(value, key: key, accessibility: .whenUnlockedThisDeviceOnly)
  }
  
  static func get(_ key: String) -> T? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecReturnData: kCFBooleanTrue as Any,
      kSecMatchLimit: kSecMatchLimitOne
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecSuccess, let data = item as? Data {
      do {
        let value = try JSONDecoder().decode(T.self, from: data)
        return value
      } catch {
        print("Error decoding data: \(error)")
      }
    }
    return nil
  }
  
  static func delete(_ key: String) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess
  }
}
