#Copywrite Oribtal Softworks 2025
#Licensed Under CC0 1.0

#This Installs The Manager Framework/Directory System

import std/[os, parsecfg, httpclient, syncio]

#Reads From config.ini
proc installConfigReader():tuple[managerName: string, managerDirName:string, manifestUrl: string] = 
  var config = loadConfig("config.ini")
  
  let managerName = config.getSectionValue("Manager", "Manager Name")
  let managerDirName = config.getSectionValue("Manager", "Manager Directory Name")
  let manifestUrl = config.getSectionValue("Mojang", "Version Manifest")
  
  result = (managerName, managerDirName, manifestURL)


#Sets Up The Folders, Moves Config, Moves Working Dir
proc directoryManager(managerName: string, managerDirName: string):string =
  let programFiles = getEnv("PROGRAMFILES") #Windows Specifc
  let managerDir = joinPath(programFiles, managerDirName)
  
  createDir(managerDir)
  echo("Made the main directory!")
  
  let configPath = joinPath(managerDir, "config.ini")
  moveFile("..\\config.ini", configPath)
  
  setCurrentDir(managerDir) #Final Resting Place
  
  createDir("Modpacks")
  createDir("Vanilla")
  echo("Made the sub directories!")
  
  result = managerDir
  

#Downloads The Official Version Manifest From Mojang
proc versionManDownloader(manifestUrl: string) =
  var client = newHttpClient()
  
  let response = get(client, manifestUrl)
  let bodyResponse = body(response)
  writeFile("version_manifest_v2.json", bodyResponse)
  close(client)


#Writes The Install Dir & .minecraft Info To The Config 
proc installConfigWriter(managerDirPath: string) =
  var config = loadConfig("config.ini")
  
  config.setSectionKey("Manager", "Path", managerDirPath)
  config.setSectionKey("", "Install", "True")
  config.writeConfig("config.ini")


#Nice importable logic
proc managerInstallerLogic*() =
  let config = installConfigReader()
  let managerDirPath = directoryManager(config.managerName, config.managerDirName)
  versionManDownloader(config.manifestUrl)
  installConfigWriter(managerDirPath)
  echo("The manager has been installed!")
  echo("Press enter to return to the main interface...")
  discard readLine(stdin)