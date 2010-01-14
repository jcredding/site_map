# http://sneaq.net/textmate-wtf
$:.reject!{|e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda'

lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

root_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)
test_support_path = File.expand_path(File.join(File.dirname(__FILE__), 'support'))
$LOAD_PATH.unshift(test_support_path) unless $LOAD_PATH.include?(test_support_path)
Dir.chdir(test_support_path)

require 'site_map'
