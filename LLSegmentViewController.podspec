Pod::Spec.new do |s|
s.name         = 'LLSegmentViewController'
s.version      = '1.0.3'
s.summary      = '使用block替代监听点击'
s.homepage     = 'https://github.com/CoderLinLee/LLSegmentViewController'
s.license      = 'MIT'
s.authors      = {'CoderLinLee' => '736764509@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'git@github.com:CoderLinLee/LLSegmentViewController.git', :tag => s.version}
s.source_files = 'LLSegmentViewController/LLSegmentViewController/**/*'
s.requires_arc = true
s.swift_version = "4.0"
end
