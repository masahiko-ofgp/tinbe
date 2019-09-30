# Copyright 2019 Masahiko Hamazawa @masahiko-ofgp
#
# Licensed under the MIT license <LICENSE or
#  https://opensource.org/licenses/MIT>.
# This file may not be copied, modified, on destributed except
#  according to those terms.
#

import os
import json
import parseopt
#import markdown


proc createProject(projectName: string) =
  let
    parent = parentDir(getCurrentDir())
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
    readmeFile = joinPath(dir, "README.md")

  if not existsDir(dir):
    createDir(dir)

    block createDefaultConfigFile:
      var file: File = open(configFile, FileMode.fmWrite)
      defer:
        close(file)
        echo "created Config.json"
      file.write(config.pretty())

    block createREADME:
      var file: File = open(readmeFile, FileMode.fmWrite)
      defer:
        close(file)
        echo "created README.md"
      file.write("# Your project")

    block createDocsDir:
      let docsDir = joinPath(dir, "docs")
      if not existsDir(docsDir):
        createDir(docsDir)


proc main() =
  for kind, key, val in getopt():
    case kind:
    of cmdEnd: doAssert(false)
    of cmdShortOption, cmdLongOption:
      case key:
      of "c", "create": createProject(val.string)
      else:
        echo "ERROR: Not exists " & key & " key."
    of cmdArgument:
      echo "ERROR: Not exists " & val & " command."


when isMainModule:
  main()
