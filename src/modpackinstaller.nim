#Copywrite Orbital Softworks 2025
#Licensed Under CC0 1.0

#This File Handles All Parts Of Modpack Downloading And Installing
#It Is Quite Long, But Is Far More Future Proofed Then Previous Versions

import std/[json, httpclient, os, parsecfg, strutils]

import zippy/ziparchive

proc modpackInstallConfigReader():tuple[orbUrl, launcherManPath, managerDirPath, ram: string] =
  let config = loadConfig("config.ini")
  let orbUrl = config.getSectionValue("Orb", "Url")
  let launcherManPath = config.getSectionValue("Minecraft", "Launcher Manifest Path")
  let managerDirPath = config.getSectionValue("Manager", "Manager Path")
  let ram = config.getSectionValue("Ram", "Value")
  result = (orbUrl, launcherManPath, managerDirPath, ram)

#Reads The Static Online Orb To Fetch Versions And Link
proc orbReader(modpackName, orbUrl: string):tuple[ver, url :string] = 
  var client = newHttpClient()
  let response = get(client, orbUrl)
  let strResponse = body(response)
  let jsonResponse = parseJson(strResponse)
  let ver = jsonResponse[modpackName]["version"].getStr
  let url = jsonResponse[modpackName]["url"].getStr
  close(client)
  result = (ver, url)

#Downloads The Orbit.json
proc orbitDownload(modpackName, url: string):string =
  var client = newHttpClient()
  let jsonName = join(modpackName, ".json")
  downloadFile(client, url, jsonName)
  close(client)
  result = jsonName

proc orbitParser(orbitFile: string):tuple[modpackVersion, vanillaVersion, framework, modpackUrl: string] =
  let orbit = parseFile(orbitFile)
  let modpackVersion = orbit["modpackVersion"].getStr
  let vanillaVersion = orbit["vanillaVersion"].getStr
  let framework = orbit["framework"].getStr
  let modpackUrl = orbit["modpackUrl"].getStr

  result = (modpackVersion, vanillaVersion, framework, modpackUrl)

#Finds The Vanilla Version .json And Returns The Url
proc getVerJsonUrl(vanillaVersion: string): string =
  let versionManifestNode = parseFile("version_manifest_v2.json")
  let versions = versionManifestNode["versions"]

  for versionNode in versions.getElems():
    let idNode = versionNode["id"]

    if idNode.kind == JString and idNode.getStr() == vanillaVersion:
      echo "Found version: ", vanillaVersion

      let url = versionNode["url"].getStr()
      result = url

#Downloads The Needed Vanilla Version .json
proc downloadVerJson(vanillaVersion, vanillaVerJsonUrl: string): string =
  var client = newHttpClient()
  
  let jsonFile = join(vanillaVersion, ".json")
  let response = get(client, vanillaVerJsonUrl)
  let bodyResponse = body(response)
  writeFile(jsonFile, bodyResponse)
  
  close(client)

  result = jsonFile

#Fetches The Version Jar Url      
proc getVerJarUrl(vanillaJson: string): string =
  let verJsonNode = parseFile(vanillaJson)
  let jarUrl = verJsonNode["downloads"]["client"]["url"].getStr()
  echo("Found jar url: ", jarUrl)
  result = jarUrl

#Downloads The Needed Vanilla Version .jar
proc downloadVerJar(vanillaVersion, verJarUrl: string): string =
  var client = newHttpClient()
  let vanillaJarFile = join(vanillaVersion, ".json")

  downloadFile(client, verJarUrl, vanillaJarFile)
  close(client)
  result = vanillaJarFile

#Move .json And .jar To .Minecraft
proc vanillaAssetMover(vanJsonFile: string, vanJarFile: string, vanVer: string) =
  let userAppData = getEnv("APPDATA")
  let vanVerDir = joinPath(userAppData, ".minecraft", "versions", vanVer)
  
  createDir(vanVerDir)
  moveFile(vanJsonFile, vanVerDir)
  moveFile(vanJarFile, vanVerDir)

#Download Pack
proc modpackDownloader(url, modpackName: string): string =
  var client = newHttpClient()
  let modpackZip = join(modpackName, ".zip")

  downloadFile(client, url, modpackZip)
  
  close(client)

  result = modpackZip

#Extract Pack
proc modpackExtracter(zipName: string, modpackName: string) = 
  let modpackInstallDir = joinPath("Modpacks", modpackName)
  extractAll(zipName, modpackInstallDir)

#Create Launcher Profile
proc profileMaker(launcherManPath, modpackName, ram, vanillaVersion, framework, managerDirPath: string) =
  
  var launcherProfileNode = parsefile(launcherManPath) #from config.ini
  let modpackNode = %*  
    {"icon": "Enchanting_Table",
    "gamedir": managerDirPath,
    "name": modpackName,
    "lastVersionID": framework,
    "JavaArgs": ram,
    "type": "custom"}
  launcherProfileNode["profiles"][modpackName] =modpackNode #joins modpackNode to existing profile
  writeFile(launcherManPath, pretty(launcherProfileNode)) #still "unsafe"

#Yeah I don't follow my own rules
proc modpackInstallCLI(): string = 
  echo("Please enter the name of the modpack you would like to install")
  echo("A list of the modpacks can be accessed through the main CLI page")
  return readLine(stdin)

#Writes the install info to config
proc modpackInstallConfigWriter(modpack, modpackVersion: string) =
  var config = loadConfig("config.ini")

  config.setSectionKey("Installed Modpacks", modpack, modpackVersion)
  config.writeConfig("config.ini")

#Neatish and Shippry 
proc modpackInstallLogic*() =
  let configVal = modpackInstallConfigReader()
  let modpack = modpackInstallCLI()
  let orbVal = orbReader(modpack, configVal.orbUrl)
  let modpackJson = orbitDownload(modpack, orbVal.url)
  let orbitVal = orbitParser(modpackJson)
  let vanillaJsonUrl = getVerJsonUrl(orbitVal.vanillaVersion)
  let vanillaJson = downloadVerJson(orbitVal.vanillaVersion, vanillaJsonUrl)
  let vanillaJarUrl = getVerJarUrl(vanillaJson)
  let vanillaJar = downloadVerJar(orbitVal.vanillaVersion, vanillaJarUrl)
  vanillaAssetMover(vanillaJson, vanillaJar, orbitVal.vanillaVersion)
  let modpackZip = modpackDownloader(orbitVal.modpackUrl, modpack)
  modpackExtracter(modpackZip, modpack)
  profileMaker(configVal.launcherManPath, modpack, configVal.ram, orbitVal.vanillaVersion, orbitVal.framework, configVal.managerDirPath)
  modpackInstallConfigWriter(modpack, orbitVal.modpackVersion)