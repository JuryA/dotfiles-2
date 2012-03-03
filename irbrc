# thanks:
# https://github.com/aziz/dotfiles/blob/master/irbrc
# https://gist.github.com/807492
# http://pastie.org/179534
# https://github.com/rafmagana/irbrc/blob/master/dot_irbrc
# https://github.com/cjameshuff/irbrc/blob/master/irbrc.rb

require 'rubygems'
require 'irb/completion'

IRB.conf[:USE_READLINE] = true
IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:PROMPT_MODE]  = :SIMPLE

def IRB.reload
  load __FILE__
end

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  # print documentation
  # ri 'Array#pop' or Array.ri or Array.ri :pop or arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    system 'ri', method.to_s
  end
end

class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
  end
end

def hex(x)
  case x
  when Numeric
    "0x%x" % x
  when Array
    x.map{|y| hex(y)}
  when Hash
    x.keys.inject({}){|h, k| h[hex(k)] = hex(x[k]); h}
  end
end

# Convert a value to a binary string, in groups of 4 bits separated by spaces
def bin(x)
  x.to_s(16).chars.to_a.map{|d| d.to_i(16).to_s(2).rjust(4, '0')}.join(' ')
end

# quick benchmarking
def bm(repetitions=100, &block)
  require 'benchmark'
  Benchmark.bmbm do |b|
    b.report {repetitions.times &block}
  end
  nil
end

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  copy content
end

def paste
  `pbpaste`
end

def clear
  system 'clear'
end
alias c clear

%w{wirble sketches hirb hirb/import_object ap pp}.each do |lib|
  begin
    require lib
  rescue LoadError => err
    $stderr.puts "Couldn't load #{lib}: #{err}"
  end
end

Wirble.init
Wirble.colorize
Sketches.config :editor => ENV["EDITOR"]
Hirb.enable
extend Hirb::Console
IRB_START_TIME = Time.now
