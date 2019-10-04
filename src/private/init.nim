import json
import os
import strformat
import times
import ./tmpl

proc createProject*(lang, siteName, author: string) =
  let
    cur = getCurrentDir()
    projectDir = joinPath(cur, "project")
    configFile = joinPath(projectDir, "config.json")
    docsDir = joinPath(projectDir, "docs")
    indexFile = joinPath(docsDir, "index.html")
    styleDir = joinPath(docsDir, "style")
    styleFile = joinPath(styleDir, "style.css")
    pubDate = getTime().format("YYYY")
    copyright = fmt"Copyright (c) {pubDate} {author} {siteName}"
    config = %*
      {
        "lang": lang,
        "site_name": siteName,
        "site_author": author,
        "site_url": nil,
        "site_description": nil,
        "copyright": copyright,
      }

  block createProjectDir:
    if not existsDir(projectDir):
      createDir(projectDir)
    echo "project"

  block createDefaultConfigFile:
    var file: File = open(configFile, FileMode.fmWrite)
    defer:
      close(file)
      echo "|-- config.json"
    file.write(config.pretty())

  block createDocsDir:
    if not existsDir(docsDir):
      createDir(docsDir)
    echo "|-- docs/"

  block createIndexHtml:
    var
      file: File = open(indexFile, FileMode.fmWrite)
      htmlCode: string = generateHtml(lang, siteName, author, copyright)
    defer:
      close(file)
      echo "\t|-- index.html"
    file.writeLine(htmlCode)

  block createStyleDir:
    if not existsDir(styleDir):
      createDir(styleDir)
    echo "\t|-- style/"

  block createDefaultStyleFile:
    var file: File = open(styleFile, FileMode.fmWrite)
    defer:
      close(file)
      echo "\t\t|-- style.css"


proc createNewPost*(filename: string) =
  var
    cur = getCurrentDir()
    projectDir = joinPath(cur, "project")
    configFile = joinPath(projectDir, "config.json")
    jf = parseFile(configFile)
    lang = jf["lang"].getStr()
    siteName = jf["site_name"].getStr()
    author = jf["site_author"].getStr()
    copyright = jf["copyright"].getStr()
    docsDir = joinPath(projectDir, "docs")
    newFile = joinPath(docsDir, fmt"{filename}.html")
  
  block:
    var
      file: File = open(newFile, FileMode.fmWrite)
      htmlCode: string = generateHtml(lang, siteName, author, copyright)
    defer:
      close(file)
      echo fmt"{filename}.html has created"
    file.writeLine(htmlCode)
