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
    projectDir = $CurDir / "project"
    configFile = projectDir / "config.json"
    docsDir = projectDir / "docs"
    indexFile = docsDir / "index.html"
    styleDir = docsDir / "style"
    styleFile = styleDir / "style.css"
    imgsDir = docsDir / "imgs"
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
    if not dirExists(projectDir):
      createDir(projectDir)
    echo "project"

  block createDefaultConfigFile:
    var file: File = open(configFile, FileMode.fmWrite)
    defer:
      close(file)
      echo "|-- config.json"
    file.write(config.pretty())

  block createDocsDir:
    if not dirExists(docsDir):
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
    if not dirExists(styleDir):
      createDir(styleDir)
    echo "\t|-- style/"

  block createDefaultStyleFile:
    var file: File = open(styleFile, FileMode.fmWrite)
    defer:
      close(file)
      echo "\t\t|-- style.css"

  block createImageDir:
    if not dirExists(imgsDir):
      createDir(imgsDir)
    echo "\t|-- imgs/"


# Helper
proc getConfig(): JsonNode =
  var
    projectDir = $CurDir / "project"
    configFile = projectDir / "config.json"
  result = parseFile(configFile)


proc createNewDir*(dirname: string) =
  var
    jf = getConfig()
    docsDir = jf["docs"].getStr()
    newDir = docsDir / dirname

  if not dirExists(newDir):
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
    newFile = docsDir / fmt"{filename}.html"
  
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
