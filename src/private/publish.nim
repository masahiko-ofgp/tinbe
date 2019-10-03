import htmlgen
import strformat
import markdown

var
  charset = meta(charset = "utf-8")
  stylesheet = link(rel = "stylesheet",
                    type = "text/css",
                    href = "style.css")
  pageTop = fmt"""
<!DOCTYPE HTML>
<html>
  <head>
    {charset}
    {stylesheet}
  </head>
"""
  pageBottom = """
</html>
"""
