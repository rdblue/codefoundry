module ApplicationHelper
  def marker_to_html( markup, options = {} )
    # Marker can't handle windows newlines and does not do sanitization so we
    # account for that here.
    Marker.parse( h( markup.gsub(/\r/, '') ) ).to_html( options )
  rescue NoMethodError
    # if Marker cannot parse the markup, it will return Nil and a NoMethodError
    # will be raised for to_html.  Catch this and return default formatting
    # with the error message hidden.
    text_to_html( markup ) + "\n<!-- #{Marker.parser.failure_reason} -->"
  end

  def text_to_html( text, options = {} )
    # do the simplest thing for now
    "<pre>text</pre>"
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
