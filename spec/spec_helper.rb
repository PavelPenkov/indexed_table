lib_dir = File.expand_path('../lib', File.dirname(__FILE__))
$:.unshift lib_dir
Dir.glob(lib_dir + "/*.rb").each do |file|
  require file
end

class Message
  class << self
    def all; @messages ||= []; end

    def add(msg); all << msg; end
  end
end

def message(msg)
  Message.add msg
end

RSpec.configure do |c|
  unless ENV["perf"] == "1"
    c.filter_run_excluding :perf => true
  end
  c.after(:suite) do
    unless Message.all.empty?
      puts "\nMessages:"
      Message.all.each {|m| puts m}
    end
  end
end

def rand_string(max_length = 10)
  str = ""
  rand(max_length + 1).times{ str << ('a'..'z').to_a[rand(26)] }
end
