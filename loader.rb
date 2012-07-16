lib_dir = File.expand_path('lib', File.dirname(__FILE__))
$LOAD_PATH.unshift lib_dir
Dir.glob(lib_dir + "/*.rb").each do |file|
  require file
end
