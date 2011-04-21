$:.reject!{|e| e.include? 'TextMate' }

ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)

require 'fileutils'
LOG_PATH = File.expand_path("../../log", __FILE__)
FileUtils.mkdir_p(LOG_PATH)
TEST_PATH = File.expand_path("..", __FILE__)
$LOAD_PATH.unshift(TEST_PATH) unless $LOAD_PATH.include?(TEST_PATH)

require 'rubygems'
require 'bundler'
Bundler.setup

require 'logger'
require 'test_belt'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'site_map'