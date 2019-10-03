import json
import os
import strformat
import times

proc createProject*(projectName, lang, siteName, author: string) =
  let
    parent = getCurrentDir()
    dir = joinPath(parent, projectName)
    configFile = joinPath(dir, "config.json")
    docsDir = joinPath(dir, "docs")
    exampleFile = joinPath(docsDir, "example.md")
    styleDir = joinPath(dir, "style")
    styleFile = joinPath(styleDir, "style.css")
    pubDate = getTime().format("YYYY")
    config = %*
      {
        "lang": lang,
        "charset": "utf-8",
        "site_name": siteName,
        "site_author": author,
        "site_url": nil,
        "site_description": nil,
        "copyright": fmt"Copyright (c) {pubDate} {author} {siteName}",
        "docs": "./docs",
        "style": "./style",
      }


  if not existsDir(dir):
    createDir(dir)

    block createDefaultConfigFile:
      var file: File = open(configFile, FileMode.fmWrite)
      defer:
        close(file)
        echo "  |-- config.json"
      file.write(config.pretty())

    block createDocsDir:
      if not existsDir(docsDir):
        createDir(docsDir)
      echo "  |-- docs/"

    block createExampleFile:
      var file: File = open(exampleFile, FileMode.fmWrite)
      defer:
        close(file)
        echo "  \t|-- example.md"

    block createStyleDir:
      if not existsDir(styleDir):
        createDir(styleDir)
      echo "  |-- style/"

    block createDefaultStyleFile:
      var file: File = open(styleFile, FileMode.fmWrite)
      defer:
        close(file)
        echo "  \t|-- style.css"
