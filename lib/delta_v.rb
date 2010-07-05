require 'net/http'

# Delta-V HTTP extensions (for SVN)
#
# Relevant RFCs:
# * RFC 2616: Hypertext Transfer Protocol -- HTTP/1.1
# ** http://www.ietf.org/rfc/rfc2616.txt
# * RFC 3253 - Versioning Extensions to WebDAV
# ** http://www.ietf.org/rfc/rfc3253.txt
#
# Additional semantics:
# * OPTIONS
#
# New methods
# * CHECKOUT
# * CHECKIN
# * UNCHECKOUT
# * UPDATE
# * MERGE
# * LABEL
# * REPORT
# * VERSION-CONTROL
# * MKWORKSPACE
# * MKACTIVITY

# Add a body to an OPTIONS request/response
#
# According RFC 2616, OPTIONS *may* have a body, with the purpose of that body
# to be defined by an extension, but that body *may* be discarded if the server
# does not support the extension.  The net/http library chooses to discard any
# extension bodies, but SVN cannot handle this case.  To support SVN, we add
# the body here.
class Net::HTTP::Options
  remove_const :REQUEST_HAS_BODY
  REQUEST_HAS_BODY=true
  remove_const :RESPONSE_HAS_BODY
  RESPONSE_HAS_BODY=true
end

# New methods:
class Net::HTTP::Checkin< Net::HTTPRequest
  METHOD='CHECKIN'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Checkout < Net::HTTPRequest
  METHOD='CHECKOUT'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Uncheckout < Net::HTTPRequest
  METHOD='UNCHECKOUT'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Update < Net::HTTPRequest
  METHOD='UPDATE'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Merge < Net::HTTPRequest
  METHOD='MERGE'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Label < Net::HTTPRequest
  METHOD='LABEL'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Report < Net::HTTPRequest
  METHOD='REPORT'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::VersionControl < Net::HTTPRequest
  METHOD='VERSION-CONTROL'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Mkworkspace < Net::HTTPRequest
  METHOD='MKWORKSPACE'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end

class Net::HTTP::Mkactivity < Net::HTTPRequest
  METHOD='MKACTIVITY'
  REQUEST_HAS_BODY=true
  RESPONSE_HAS_BODY=true
end
