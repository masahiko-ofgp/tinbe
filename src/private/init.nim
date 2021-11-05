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
  std/json,
  std/os,
  std/strformat,
  std/times,
  std/logging


var
  logger = newConsoleLogger(fmtStr="[$levelname] $time: ")

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
    if dirExists(projectDir):
      logger.log(lvlInfo, fmt"{projectDir} already exists.")
    else:
      createDir(projectDir)

  block createDefaultConfigFile:
    var file: File

    if fileExists(configFile):
      logger.log(lvlInfo, fmt"{configFile} already exists.")
    else:
      file = open(configFile, FIleMode.fmWrite)
      file.write(config.pretty())
      close(file)

  block createDocsDir:
    if dirExists(docsDir):
      logger.log(lvlInfo, fmt"{docsDir} already exists.")
    else:
      createDir(docsDir)

  block createIndexFile:
    var
      file: File
      header = writeHeader(author, description, siteName)
      body = writeBody("")
      footer = writeFooter(copyright)

    if fileExists(indexFile):
      logger.log(lvlInfo, fmt"{indexFile} already exists.")
    else:
      file = open(indexFile, FileMode.fmWrite)
      file.write(header&body&footer)
      close(file)

  block createStyleDir:
    if dirExists(styleDir):
      logger.log(lvlInfo, fmt"{styleDir} already exists.")
    else:
      createDir(styleDir)

  block createDefaultStyleFile:
    var file: File

    if fileExists(styleFile):
      logger.log(lvlInfo, fmt"{styleFile} already exists.")
    else:
      file = open(styleFile, FileMode.fmWrite)
      close(file)


  block createImageDir:
    if dirExists(imgsDir):
      logger.log(lvlInfo, fmt"{imgsDir} already exists.")
    else:
      createDir(imgsDir)


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

  if dirExists(newDir):
    logger.log(lvlInfo, fmt"{newDir} already exists.")
  else:
    createDir(newDir)


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
      file: File
      header = writeHeader(author, description, siteName)
      body = writeBody("")
      footer = writeFooter(copyright)

    if fileExists(newFile):
      logger.log(lvlInfo, fmt"{filename} already exists.")
    else:
      file = open(newFile, FileMode.fmWrite)
      file.write(header&body&footer)
      echo fmt"{filename}.html has created."
      close(file)
