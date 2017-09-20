# Copyright (C) Dominik Picheta. All rights reserved.
# MIT License. Look at license.txt for more info.

when not defined(posix):
  {.error: "This module is only supported on POSIX".}

import "$nim/lib/posix/posix", strutils, os

when false:
  type
    Tstatfs {.importc: "struct statfs64",
              header: "<sys/statfs.h>", final, pure.} = object
      f_type: int
      f_bsize: int
      f_blocks: int
      f_bfree: int
      f_bavail: int
      f_files: int
      f_ffree: int
      f_fsid: int
      f_namelen: int

  proc statfs(path: string, buf: var Tstatfs): int {.
    importc, header: "<sys/vfs.h>".}



proc getSystemVersion*(): string =
  result = ""

  var unix_info: Utsname

  if uname(unix_info) != 0:
    os.raiseOSError(osLastError())

  if $unix_info.sysname == "Linux":
    # Linux
    result = "Linux $1 $2" % [$unix_info.release, $unix_info.machine]
  elif $unix_info.sysname == "Darwin":
    # Darwin
    result = "Mac OS X "
    result.add(
      case $unix_info.release
        of "16": "v10.12 Sierra"
        of "15": "v10.11 El Capitan"
        of "14": "v10.10 Yosemite"
        of "13": "v10.9 Mavericks"
        of "12": "v10.8 Mountain Lion"
        of "11": "v10.7 Lion"
        of "10": "v10.6 Snow Leopard"
        of "9": "v10.5 Leopard"
        of "8": "v10.4 Tiger"
        of "7": "v10.3 Panther"
        of "6": "v10.2 Jaguar"
        of "1.4": "v10.1 Puma"
        of "1.3": "v10.0 Cheetah"
        else: "Unknown version"
    )
  else:
    result = "$1 $2" % [$unix_info.release, $unix_info.machine]

when isMainModule:
  var unix_info: Utsname
  echo(uname(unix_info))
  echo(unix_info.sysname)
  echo("8" in $unix_info.release)
  echo(unix_info)

  echo(getSystemVersion())

  # var stfs: TStatfs
  # echo(statfs("sysinfo_posix.nim", stfs))
  # echo(stfs.f_files)

