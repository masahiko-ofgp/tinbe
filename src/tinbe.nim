# Copyright 2019 Masahiko Hamazawa @masahiko-ofgp
#
# Licensed under the MIT license <LICENSE or
#  https://opensource.org/licenses/MIT>.
# This file may not be copied, modified, on destributed except
#  according to those terms.
#

import osproc
import parseopt
import strformat
import ./private/init

const VERSION = "0.1.0"



proc startProject() =
  discard execCmd("./imgs/tinbe.sh")
  echo "Thanks to use tinbe!! This is static site generator :)"
  echo "Usage: Please read README"
  echo "Project name?"
  var pName: string = readLine(stdin)
  echo "Language?"
  var lang: string = readLine(stdin)
  echo "Site name?"
  var siteName: string = readLine(stdin)
  echo "Author?"
  var author: string = readLine(stdin)
  createProject(pName, lang, siteName, author)
  echo fmt"Your project '{pName}' has created!!"


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
      of "serve": discard  #TODO: Temporary discard 
      of "build": discard  #TODO: Temporary discard
      else: echo "Not exist command"

when isMainModule:
  main()
