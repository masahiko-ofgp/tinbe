# Copyright 2019 Masahiko Hamazawa @masahiko-ofgp
#
# Licensed under the MIT license <LICENSE or
#  https://opensource.org/licenses/MIT>.
# This file may not be copied, modified, on destributed except
#  according to those terms.
#

import osproc
import os
import parseopt
import json

const VERSION = "0.1.0"


proc createProject(projectName: string) =
  let
    parent = getCurrentDir()
    dir = joinPath(parent, projectName)
    configFile = joinPath(dir, "config.json")
    config = %*
      [
        {"site_name": nil},
        {"site_author": nil},
        {"site_url": nil},
        {"site_description": nil},
        {"copyright": nil},
      ]
    docsDir = joinPath(dir, "docs")

  if not existsDir(dir):
    createDir(dir)

    block createDefaultConfigFile:
      var file: File = open(configFile, FileMode.fmWrite)
      defer:
        close(file)
        echo "\tcreated config.json"
      file.write(config.pretty())

    block createDocsDir:
      if not existsDir(docsDir):
        createDir(docsDir)
      echo "\tcreated docs directory"


proc startProject() =
  discard execCmd("./imgs/tinbe.sh")
  echo "Thanks to use tinbe!! tinbe is static site generator :)"
  echo "Usage: Please read README"
  echo "Project name?"
  var pName: string = readLine(stdin)
  createProject(pName)
  echo "Your project has created!!"


proc main() =
  for kind, key, val in getopt():
    case kind:
    of cmdEnd: doAssert(false)
    of cmdShortOption, cmdLongOption:
      case key:
      of "v", "version": echo VERSION
      else: echo "Not exist option"
    of cmdArgument:
      case key:
      of "start": startProject()
      else: echo "Not exist command"

when isMainModule:
  main()
