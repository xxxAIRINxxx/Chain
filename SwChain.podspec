Pod::Spec.new do |s|
  s.name         = "SwChain"
  s.version      = "1.0.0"
  s.summary      = "Method chaining of queued closure (blocks) on GCD (Grand Central Dispatch)"
  s.homepage     = "https://github.com/xxxAIRINxxx/Chain"
  s.license      = 'MIT'
  s.author       = { "Airin" => "xl1138@gmail.com" }
  s.source       = { :git => "https://github.com/xxxAIRINxxx/Chain.git", :tag => s.version.to_s }

  s.requires_arc = true
  s.platform     = :ios, '8.0'

  s.source_files = 'Source/*.swift'
end
