/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import RealmSwift

enum RealmConfig {

  // copy the pre-bundled file to the documents folder
  private static var copyInitialFile: Void = {
    Exams.copyInitialData(
      Bundle.main.url(forResource: "default_v1.0", withExtension: "realm")!,
      to: RealmConfig.mainConfig.fileURL!)
  }()

  // MARK: - private configurations
  private static let mainConfig = Realm.Configuration(
    fileURL: URL.inDocumentsFolder(fileName: "main.realm"),
    schemaVersion: 2,
    migrationBlock: Exams.migrate,
    objectTypes: [Exam.self]
  )

  private static let staticConfig = Realm.Configuration(
    fileURL: Bundle.main.url(forResource: "static", withExtension: "realm"),
    readOnly: true,
    objectTypes: [SubjectName.self]
  )

  private static let safeConfig = Realm.Configuration(
    fileURL: URL.inDocumentsFolder(fileName: "safe.realm"),
    objectTypes: [SubjectMark.self]
  )

  // MARK: - enum cases
  case main
  case `static`
  case safe(key: String)

  // MARK: - current configuration
  var configuration: Realm.Configuration {
    switch self {
    case .main:
      _ = RealmConfig.copyInitialFile
      return RealmConfig.mainConfig
    case .static:
      return RealmConfig.staticConfig
    case .safe(let key):
      var config = RealmConfig.safeConfig
      config.encryptionKey = key.sha512
      return config
    }
  }

}
