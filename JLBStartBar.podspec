Pod::Spec.new do |s|
  s.name = 'JLBStartBar'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'JLBStartBar swift comment Bar'
  s.homepage = 'https://github.com/tiancanfei/JLBStartBar'
  s.authors = { 'tiancanfei' => 'bjwltiankong@163.com' }
  s.source = { :git => 'https://github.com/tiancanfei/JLBStartBar.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'JLBStartBar/JLBStartBar.swift'
end