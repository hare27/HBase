
Pod::Spec.new do |s|

  s.name         = "HBase"
  s.version      = "0.0.1"
  s.summary      = "自己用的"
  s.description  = <<-DESC
自己用的
                   DESC

  s.homepage     = "https://github.com/hare27/HBase"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "hare27" => "947363526@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/hare27/HBase.git", :tag => "#{s.version}" }
  s.source_files  = "HBase", "HBase/**/*.{h,m}"

end
