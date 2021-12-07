Pod::Spec.new do |spec|

  spec.name         = "Arsenal-OBJC"
  spec.version      = "1.0.0"
  spec.summary      = "Code decoupling solutions for Objective-C"

  spec.description  = <<-DESC
		     Code decoupling solutions for Objective-C
                   DESC

  spec.homepage     = "https://github.com/cmwsssss/CCMQ"

  spec.license      = "MIT"

  spec.author       = { "cmw" => "cmwsssss@hotmail.com" }

  spec.platform     = :ios, "6.0"

  spec.source       = { :git => "https://github.com/cmwsssss/Arsenal.git", :tag => "1.0.0" }

  spec.source_files  = "Arsenal", "Arsenal/**/*.{h,m}"
  spec.exclude_files = "Arsenal/Exclude"

end
