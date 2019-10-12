# Copyright 2019 Masahiko Hamazawa @masahiko-ofgp
#
# Licensed under the MIT license <LICENSE or
#  https://opensource.org/licenses/MIT>.
# This file may not be copied, modified, on destributed except
#  according to those terms.
#
import
  json,
  os,
  strformat,
  times,
  ./tmpl


proc createProject*(siteName, author, description: string) =
  let
    cur = getCurrentDir()
    projectDir = joinPath(cur, "project")
    configFile = joinPath(projectDir, "config.json")
    docsDir = joinPath(projectDir, "docs")
    indexFile = joinPath(docsDir, "index.html")
    styleDir = joinPath(docsDir, "style")
    styleFile = joinPath(styleDir, "style.css")
    imgsDir = joinPath(docsDir, "imgs")
    pubDate = getTime().format("YYYY")
    copyright = fmt"Copyright (c) {pubDate} {author} {siteName}"
    config = %*
      {
        "site_name": siteName,
        "site_author": author,
        "site_url": nil,
        "site_description": description,
        "copyright": copyright,
        "root": projectDir,
        "docs": docsDir,
        "style": styleDir
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
      htmlCode: string = generateHtml(siteName, author, copyright)
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

  block createImageDir:
    if not existsDir(imgsDir):
      createDir(imgsDir)
    echo "\t|-- imgs/"


proc createNewPost*(filename: string) =
  var
    cur = getCurrentDir()
    projectDir = joinPath(cur, "project")
    configFile = joinPath(projectDir, "config.json")
    jf = parseFile(configFile)
    siteName = jf["site_name"].getStr()
    author = jf["site_author"].getStr()
    copyright = jf["copyright"].getStr()
    #docsDir = joinPath(projectDir, "docs")
    docsDir = jf["docs"].getStr()
    newFile = joinPath(docsDir, fmt"{filename}.html")
  
  block:
    var
      file: File = open(newFile, FileMode.fmWrite)
      htmlCode: string = generateHtml(siteName, author, copyright)
    defer:
      close(file)
      echo fmt"{filename}.html has created"
    file.writeLine(htmlCode)
