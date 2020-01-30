Pod::Spec.new do |spec|

  spec.name         = "PassportReaderUA"
  spec.version      = "0.1.0"
  spec.summary      = "PassportScannerUA lets a user to scan NFC and get information about owner."

  spec.homepage     = "https://github.com/SaliienkoAleksandr/PassportReaderUA"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author    = "Aleksandr Saliienko"

  spec.platform     = :ios, "13.0"

  spec.source       = { :git => "https://github.com/SaliienkoAleksandr/PassportReaderUA.git", :tag => "#{spec.version}" }

  spec.source_files  = "PassportReaderUA/**/*.{swift}"

  spec.framework  = "UIKit"
  
  spec.requires_arc = true

  spec.dependency "QKMRZScanner", "~> 2.1.2"
  spec.dependency "NFCPassportReader", "~> 1.0.7"

end
