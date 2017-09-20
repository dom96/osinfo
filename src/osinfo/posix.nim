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
    result.add("Linux ")

    result.add($unix_info.release & " ")
    result.add($unix_info.machine)
  elif $unix_info.sysname == "Darwin":
    # Darwin
    result.add("Mac OS X ")
    if "16" in $unix_info.release:
      result.add("v10.12 Sierra")
    elif "15" in $unix_info.release:
      result.add("v10.11 El Capitan")
    elif "14" in $unix_info.release:
      result.add("v10.10 Yosemite")
    elif "13" in $unix_info.release:
      result.add("v10.9 Mavericks")
    elif "12" in $unix_info.release:
      result.add("v10.8 Mountain Lion")
    elif "11" in $unix_info.release:
      result.add("v10.7 Lion")
    elif "10" in $unix_info.release:
      result.add("v10.6 Snow Leopard")
    elif "9" in $unix_info.release:
      result.add("v10.5 Leopard")
    elif "8" in $unix_info.release:
      result.add("v10.4 Tiger")
    elif "7" in $unix_info.release:
      result.add("v10.3 Panther")
    elif "6" in $unix_info.release:
      result.add("v10.2 Jaguar")
    elif "1.4" in $unix_info.release:
      result.add("v10.1 Puma")
    elif "1.3" in $unix_info.release:
      result.add("v10.0 Cheetah")
    else:
      result.add("Unknown version")
  else:
    result.add($unix_info.sysname & " " & $unix_info.release)

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

