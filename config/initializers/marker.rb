# configure marker
require 'marker'
require 'marker_templates'

# set up the templates
Marker.templates = CodeFoundryTemplates

# set Marker's internal link base
Marker.link_base = Settings.marker.link_base

# Override Marker's default template to hide ugliness
class << Marker.templates
  def method_missing( sym, *args ) #:nodoc:
    format, ordered, named, = args
    "<abbr title='#{sym}( :#{format}, #{html_safe(ordered.inspect)}, #{html_safe(named.inspect)} )'>(#{sym})</abbr>"
  end
end
