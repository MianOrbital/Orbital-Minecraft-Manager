#Copywrite Orbital Softworks 2025
#Licensed Under CC0 1.0

#This holds some small features inplace of seperate files

import std/[parsecfg, strutils, streams, httpclient, json]

#Reads config for current ram
proc ramConfigReader():string =
  let config = loadConfig("config.ini")
  let ram = config.getSectionValue("Ram", "Value")
  return ram

#Ram CLI
proc ramSetter(ram: string):string = 
  echo("Ram is currently set as ", ram)
  echo("Please enter the desired ram as a number in GB")
  var ram = readLine(stdin)
  echo("Ram being changed to ", ram)
  ram = join(ram, "GB")
  return ram

#Writes new value to the config
proc ramConfigWriter(ram: string) =
  let ram = ramSetter(ramConfigReader())
  var config = loadConfig("config.ini")
  config.setSectionKey("Ram", "Value", ram)
  config.writeConfig("config.ini")

#Neat shipping
proc ramLogic*() = 
  var ram = ramConfigReader()
  ram = ramSetter(ram)
  ramConfigWriter(ram)

#Reads config for list of installed packs
#I love the simplicity across Nim's Stdlib
proc listConfigReader*():seq[string] =
  var list = newseq[string]()
  let configFile = "config.ini"
  var f = newFileStream(configFile, fmRead)
  var p: CfgParser
  open(p, f, configFile)
  while true:
    var e = next(p)
    case e.kind
    of cfgEof: break
    of cfgOption: break
    of cfgError: break
    of cfgKeyValuePair: return
    of cfgSectionStart:
      if e.section == "Installed Modpacks":
        for pack in e.section:
          var packName = e.key
          var packVer = e.value
          var combo = join(packName, packVer)
          list.add(combo)
      else: break
  close(p)
  result = list

#Reads the config for current version of modpack
proc updaterConfigReader(modpack: string):tuple[installedVer, orbUrl: string] =
  let config = loadConfig("config.ini")
  let version = config.getSectionValue("Installed Modpacks", modpack)
  let orbUrl = config.getSectionValue("Orb", "Url")
  result = (version, orbUrl)

#Reads the orb for latest shiped version
proc updaterOrbReader(modpack, orbUrl: string): string =
  var client = newHttpClient()
  let response = get(client, orbUrl)
  let strResponse = body(response)
  let jsonResponse = parseJson(strResponse)
  let ver = jsonResponse[modpack]["version"].getStr
  result = ver

#Compares them/Output CLI
proc updaterComparer(installedVer, orbVer: string) =
  if installedVer == orbVer:
    echo ("The most recent version is installed!")
  else:
    echo ("It seems the installed version is outdated!")
    echo ("Installed version: ", installedVer)
    echo ("Most recent version: ", orbVer)
    echo ("")
    echo ("Please run the installer again to update!")

#CLI
proc updaterCLI():string =
  echo ("Please enter the modpack name that you would like to check!")
  let userIn = readLine(stdin)
  result = userIn

#Nice and Neat
proc updaterLogic*() =
  let modpack = updaterCLI()
  let configVal = updaterConfigReader(modpack)
  let orbVal = updaterOrbReader(modpack, configVal.orbUrl)
  updaterComparer(configVal.installedVer, orbVal)