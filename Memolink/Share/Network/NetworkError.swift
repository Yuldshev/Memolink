import Foundation

enum NetworkError: Error, LocalizedError {
  case noConnection
  case authentication
  case server
  case clientError
}
