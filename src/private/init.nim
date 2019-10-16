# Copyright 2019 Masahiko Hamazawa @masahiko-ofgp
#
# Licensed under the MIT license <LICENSE or
#  https://opensource.org/licenses/MIT>.
# This file may not be copied, modified, on destributed except
#  according to those terms.
#
include "./template/header.nimf"
include "./template/footer.nimf"
include "./template/body.nimf"

import
  json,
  os,
  strformat,
  times


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
        "config": configFile,
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

  block createIndexFile:
    var
      file: File = open(indexFile, FileMode.fmWrite)
      header = writeHeader(author, description, siteName)
      body = writeBody("")
      footer = writeFooter(copyright)
    defer:
      close(file)
      echo "\t|-- index.html"
    file.write(header&body&footer)

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


# Helper
proc getConfig(): JsonNode =
  var
    cur = getCurrentDir()
    projectDir = joinPath(cur, "project")
    configFile = joinPath(projectDir, "config.json")
  result = parseFile(configFile)


proc createNewDir*(dirname: string) =
  var
    jf = getConfig()
    docsDir = jf["docs"].getStr()
    newDir = joinPath(docsDir, dirname)

  if not existsDir(newDir):
      createDir(newDir)
  echo fmt"{dirname} has created."


proc createNewPost*(filename: string) =
  var
    jf = getConfig()
    siteName = jf["site_name"].getStr()
    author = jf["site_author"].getStr()
    description = jf["site_description"].getStr()
    copyright = jf["copyright"].getStr()
    docsDir = jf["docs"].getStr()
    newFile = joinPath(docsDir, fmt"{filename}.html")
  
  block:
    var
      file: File = open(newFile, FileMode.fmWrite)
      header = writeHeader(author, description, siteName)
      body = writeBody("")
      footer = writeFooter(copyright)
    defer:
      close(file)
      echo fmt"{filename}.html has created"
    file.write(header&body&footer)
