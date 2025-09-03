import XCTest
@testable import Memolink

final class PasswordVMTests: XCTestCase {
  var passwordVM: PasswordVM!
  var mockAppCoordinator: MockAppCoordinator!
  var onboardingCoordinator: OnboardingCoordinator!
  
  override func setUp() {
    super.setUp()
    let realAppCoordinator = AppCoordinator()
    onboardingCoordinator = OnboardingCoordinator(coordinator: realAppCoordinator, services: DIContainer.shared)
    passwordVM = PasswordVM(router: onboardingCoordinator)
  }
  
  // MARK: - Password Strength Tests
  func testWeakPasswordStrength() {
    passwordVM.pass = "weak"
    
    let strength = passwordVM.passwordStrength
    XCTAssertEqual(strength.progress, 1)
    XCTAssertEqual(strength.color, .red)
  }
  
  func testMediumPasswordStrength() {
    passwordVM.pass = "Password"  // Missing numbers
    
    let strength = passwordVM.passwordStrength
    XCTAssertEqual(strength.progress, 2)
    XCTAssertEqual(strength.color, .yellow)
  }
  
  func testStrongPasswordStrength() {
    passwordVM.pass = "Password1"
    
    let strength = passwordVM.passwordStrength
    XCTAssertEqual(strength.progress, 3)
    XCTAssertEqual(strength.color, .green)
  }
  
  func testEmptyPasswordStrength() {
    passwordVM.pass = ""
    
    let strength = passwordVM.passwordStrength
    XCTAssertEqual(strength.progress, 0)
    XCTAssertEqual(strength.color, .black200)
  }
  
  // MARK: - Validation Tests
  func testValidPasswordAndConfirmation() {
    passwordVM.pass = "Password1"
    passwordVM.confirmPass = "Password1"
    
    passwordVM.next()
    
    XCTAssertEqual(onboardingCoordinator.store.password, "Password1")
    // Проверяем что произошла навигация (path не пустой)
    XCTAssertFalse(onboardingCoordinator.path.isEmpty)
  }
  
  func testEmptyPassword() {
    passwordVM.pass = ""
    passwordVM.confirmPass = ""
    
    passwordVM.next()
    
    // Проверяем что навигация НЕ произошла при пустом пароле
    XCTAssertTrue(onboardingCoordinator.path.isEmpty)
  }
  
  func testWeakPassword() {
    passwordVM.pass = "weak"
    passwordVM.confirmPass = "weak"
    
    passwordVM.next()
    
    // Проверяем что навигация НЕ произошла при слабом пароле
    XCTAssertTrue(onboardingCoordinator.path.isEmpty)
  }
  
  func testPasswordMismatch() {
    passwordVM.pass = "Password1"
    passwordVM.confirmPass = "Password2"
    
    passwordVM.next()
    
    // Проверяем что навигация НЕ произошла при несовпадающих паролях
    XCTAssertTrue(onboardingCoordinator.path.isEmpty)
  }
  
  func testMediumStrengthPassword() {
    passwordVM.pass = "Password"  // Missing numbers
    passwordVM.confirmPass = "Password"
    
    passwordVM.next()
    
    // Проверяем что навигация НЕ произошла при пароле средней силы
    XCTAssertTrue(onboardingCoordinator.path.isEmpty)
  }
}