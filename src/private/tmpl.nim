# Copyright 2019 Masahiko Hamazawa @masahiko-ofgp
#
# Licensed under the MIT license <LICENSE or
#  https://opensource.org/licenses/MIT>.
# This file may not be copied, modified, on destributed except
#  according to those terms.
#
import strformat

proc generateHtml*(lang, site_name, author, copyright: string): string =
  result = fmt"""
<!DOCTYPE HTML>
  <html lang='{lang}'>
    <head>
      <meta charset='utf-8'>
      <meta http-equiv='X-UA-Compatible' content='IE=edge'>
      <meta name='viewport' content='width=device-width,initial-scale=1.0'>

      <title></title>
      <meta name='description' content=''>
      <meta name='keywords' content=''>
      <meta name='author' content='{author}'>
      <link rel='stylesheet' href='./style/style.css' type='text/css'>
    </head>
    <body>
      <header>
        <h1>{site_name}</h1>
      </header>
      <p>Welcome!</p>

      <footer>
        {copyright}
      </footer>
    </body>
  </html>
  """
