# Copyright 2019 Masahiko Hamazawa @masahiko-ofgp
#
# Licensed under the MIT license <LICENSE or
#  https://opensource.org/licenses/MIT>.
# This file may not be copied, modified, on destributed except
#  according to those terms.
#
{.deadCodeElim: on.}
include
  private/init

import
  std/os,
  std/osproc,
  std/parseopt,
  std/strformat,
  std/logging

const VERSION = "0.1.0"

proc startProject() =
  let cur = getCurrentDir()
  let title = fmt"""
  ============
  Tinbe {VERSION}
  ============
  """
  
  echo title

  echo "Thanks to use tinbe!! This is static site generator :)"
  echo "Usage: Please read README"
  echo "Site name?"
  var siteName: string = readLine(stdin)
  echo "Author?"
  var author: string = readLine(stdin)
  echo "Site Description?"
  var description: string = readLine(stdin)
  createProject(siteName, author, description)


proc main() =
  for kind, key, val in getopt():
    case kind:
    of cmdEnd: doAssert(false)
    of cmdShortOption, cmdLongOption:
      case key:
      of "v", "version": echo VERSION
      of "a", "add": createNewPost(val.string)
      of "d", "dir": createNewDir(val.string)
      else: logger.log(lvlInfo, "Not exist option")
    of cmdArgument:
      case key:
      of "start":
        if dirExists($CurDir / "project"):
          logger.log(lvlWarn, fmt"Project already exists.")
        else:
          startProject()
      of "clean":
        discard execCmd("rm -rf project")
        logger.log(lvlInfo, "Deleted all of your project.")
      else: logger.log(lvlInfo, "Not exist command")

when isMainModule:
  main()
