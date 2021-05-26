# Copyright (C) Dominik Picheta. All rights reserved.
# MIT License. Look at license.txt for more info.

when not defined(posix):
  {.error: "This module is only supported on POSIX".}
import strutils, os

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

type
  Utsname* {.importc: "struct utsname",
              header: "<sys/utsname.h>",
              final, pure.} = object ## struct utsname
    sysname*,      ## Name of this implementation of the operating system.
    nodename*,     ## Name of this node within the communications
                   ## network to which this node is attached, if any.
    release*,      ## Current release level of this implementation.
    version*,      ## Current version level of this release.
    machine*: cstring ## Name of the hardware type on which the
                                     ## system is running.

proc uname*(a1: var Utsname): cint {.importc, header: "<sys/utsname.h>".}

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
    var rel = $unix_info.release
    if '.' in rel:
      let split = rel.split(".")
      rel = split[0]
    result = "Mac OS X "
    result.add(
      case rel
        of "20": "v11 Big Sur"
        of "19": "v10.15 Catalina"
        of "18": "v10.14 Mojave"
        of "17": "v10.13 High Sierra"
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
        else: "Unknown version ($1)" % $unix_info.release
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
