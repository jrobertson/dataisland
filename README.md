#Introducing the dataisland gem

The dataisland gem outputs HTML with tables, or lists rendered from the embedded Dynarex, or Polyrex dataisland element attributes.
e.g.

    require 'dataisland'

    url = 'http://jamesrobertson.eu/health/index.html'
    dataisland = DataIsland.new(url)
    dataisland.html_doc.xml pretty: true

