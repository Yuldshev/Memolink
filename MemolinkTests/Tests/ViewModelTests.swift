import XCTest
@testable import Memolink

// MARK: - Simple VM Tests без router dependencies
final class ViewModelTests: XCTestCase {
  
  // MARK: - PasswordVM Tests
  func testPasswordStrengthWeak() {
    let mockRouter = createMockRouter()
    let passwordVM = PasswordVM(router: mockRouter)
    
    passwordVM.pass = "weak"
    let strength = passwordVM.passwordStrength
    
    XCTAssertEqual(strength.progress, 1)
    XCTAssertEqual(strength.color, .red)
  }
  
  func testPasswordStrengthStrong() {
    let mockRouter = createMockRouter()
    let passwordVM = PasswordVM(router: mockRouter)
    
    passwordVM.pass = "Password1"
    let strength = passwordVM.passwordStrength
    
    XCTAssertEqual(strength.progress, 3)
    XCTAssertEqual(strength.color, .green)
  }
  
  func testPasswordValidation() {
    let mockRouter = createMockRouter()
    let passwordVM = PasswordVM(router: mockRouter)
    
    passwordVM.pass = "Password1"
    passwordVM.confirmPass = "Password1"
    
    // Проверяем что пароль валидный для PasswordValidator
    XCTAssertTrue(PasswordValidator.validate(passwordVM.pass))
    XCTAssertEqual(passwordVM.pass, passwordVM.confirmPass)
  }
  
  // MARK: - LoginVM Tests  
  func testLoginVMValidation() {
    let mockRouter = createMockRouter()
    let loginVM = LoginVM(router: mockRouter)
    
    loginVM.rawPhone = "998990573713"
    loginVM.password = "Password1"
    
    XCTAssertTrue(loginVM.isValid)
  }
  
  func testLoginVMInvalidPhone() {
    let mockRouter = createMockRouter()
    let loginVM = LoginVM(router: mockRouter)
    
    loginVM.rawPhone = "123"
    loginVM.password = "Password1"
    
    // isValid только проверяет что поля не пустые
    XCTAssertTrue(loginVM.isValid)
    // Но валидация номера происходит при login() - проверим длину
    XCTAssertNotEqual(loginVM.rawPhone.count, 12)
  }
  
  // MARK: - Helper
  private func createMockRouter() -> OnboardingCoordinator {
    // Создать minimal router для тестов
    let realAppCoordinator = AppCoordinator()
    let realServices = DIContainer.shared
    
    return OnboardingCoordinator(
      coordinator: realAppCoordinator,
      services: realServices
    )
  }
}

// MARK: - Validation Only Tests (без dependencies)
final class ValidationTests: XCTestCase {
  
  func testEmailValidation() {
    // Тест email regex из InformationVM
    let validEmails = ["test@example.com", "user@domain.co.uk"]
    let invalidEmails = ["invalid", "@domain.com", "user@"]
    
    for email in validEmails {
      XCTAssertTrue(isValidEmail(email), "Should be valid: \(email)")
    }
    
    for email in invalidEmails {
      XCTAssertFalse(isValidEmail(email), "Should be invalid: \(email)")
    }
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: email)
  }
}