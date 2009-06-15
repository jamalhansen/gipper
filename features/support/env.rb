$LOAD_PATH.unshift(File.join [File.dirname(__FILE__), "..", "..", "lib"])
require 'gipper'

$LOAD_PATH.unshift(File.join [File.dirname(__FILE__), "..", "..", "test"])
require 'custom_assertions'
include CustomAssertions

require 'test/unit/assertions'

World(Test::Unit::Assertions)