
Pod::Spec.new do |s|
  s.name         = "RNSy"
  s.version      = "1.0.0"
  s.summary      = "RNSy"
  s.description  = <<-DESC
                  RNSy
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNSy.git", :tag => "master" }
  s.source_files  = "RNSy/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "CL_ShanYanSDK"

end

