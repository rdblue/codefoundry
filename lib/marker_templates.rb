def html_safe( str ) #:nodoc:
  str.gsub!(/>/, '&gt;')
  str.gsub!(/</, '&lt;')
  str.gsub!(/'/, '&quot;')
end

module CodeFoundryTemplates
end
