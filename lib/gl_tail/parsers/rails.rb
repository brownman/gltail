# gl_tail.rb - OpenGL visualization of your server traffic
# Copyright 2007 Erlend Simonsen <mr@fudgie.org>
#
# Licensed under the GNU General Public License v2 (see LICENSE)
#

# Parser which handles Rails access logs
class RailsParser < Parser
  def parse( line )
    puts "parser: rails.rb: parse #{line}"
    if matchdata = /^Started (GET|PUT|DELETE|POST) \"([\/A-Za-z0-9\-_]+)\" for (\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)/.match(line)
      _, method, url, host = matchdata.to_a
    end
    
    if url
      add_activity(:block => 'content', :name => 'page')
      add_activity(:block => 'users', :name => host) if host
      add_activity(:block => 'method', :name => method) if method

      # Events to pop up
      add_event(:block => 'info', :name => "Revisions", :message => "Revision", :update_stats => true, :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('pages') && method == "POST"
      add_event(:block => 'info', :name => "Attachments", :message => "Attachment", :update_stats => true, :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('attachments') && method == "POST"
      add_event(:block => 'info', :name => "Logins", :message => "Login...", :update_stats => true, :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('/users/login')
      add_event(:block => 'info', :name => "Sales", :message => "$", :update_stats => true, :color => [1.5, 0.0, 0.0, 1.0]) if url.include?('/users/checkout')
      add_event(:block => 'info', :name => "Signups", :message => "New User...", :update_stats => true, :color => [1.0, 1.0, 1.0, 1.0]) if(url.include?('/users/signup') || url.include?('/users/create'))
    elsif line.include?('Error (')
      _, error, msg = /^([^ ]+Error) \((.*)\):/.match(line).to_a
      if error
        add_event(:block => 'info', :name => "Exceptions", :message => error, :update_stats => true, :color => [1.0, 0.0, 0.0, 1.0])
        add_event(:block => 'info', :name => "Exceptions", :message => msg, :update_stats => false, :color => [1.0, 0.0, 0.0, 1.0])
        add_activity(:block => 'warnings', :name => msg)
      end
    end
  end
end
