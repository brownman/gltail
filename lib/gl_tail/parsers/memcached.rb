# gl_tail.rb - OpenGL visualization of your server traffic
# Copyright 2007 Erlend Simonsen <mr@fudgie.org>
#
# Licensed under the GNU General Public License v2 (see LICENSE)
#

# Parser for a "n & n" custom memcached log format
# Brilliant format design and code by Magnus Holm <judofyr>
class MemcachedParser < Parser
  def parse( line )
    add_activity(:block => 'memcached', :name => 'hit', :color => [0.0, 1.0, 0.0, 1.0]) if line.include?('get ')
    add_activity(:block => 'memcached', :name => 'store', :color => [0.0, 1.0, 0.0, 1.0]) if line.include?('store ')
    add_activity(:block => 'memcached', :name => 'set', :color => [0.0, 1.0, 0.0, 1.0]) if line.include?('set ')
  end
end
