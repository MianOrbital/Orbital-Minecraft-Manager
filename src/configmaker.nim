#Copywrite Orbital Softworks 2025
#Licensed Under CC0 1.0


#This Makes The config.ini
#This file is kept small to make it simple to change key values
#This should also be the only OS specific place

import std/parsecfg
import std/os

let managerName = "Orbital Minecraft Manager"
let managerDirName = "OrbitalMinecraftManager"
let orbUrl = "https://gist.github.com/MianOrbital/4e9e7de8c8357bf573b1cb44c3007e5e"
let verManifest = "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"

let userAppEnv = getEnv("APPDATA")
let minecraftDir = joinPath(userAppEnv, ".minecraft")
let minecraftVerDir = joinPath(minecraftDir, "versions")
let launcherVerJson = joinPath(minecraftDir, "launcher_manifest_v2.json")

proc configMaker*() = 
  var config = newConfig()
 
  config.setSectionKey("Manager", "Manager Name", managerName)
  config.setSectionKey("Manager", "Manager Directory Name", managerDirName)
  config.setSectionKey("Orb", "Url", orbUrl)
  config.setSectionKey("Mojang", "Version Manifest", verManifest)
  config.setSectionKey("Minecraft", ".minecraft Path", minecraftDir)
  config.setSectionKey("Minecraft", "Version Path", minecraftVerDir)
  config.setSectionKey("Minecraft", "Launcher Manifest Path", launcherVerJson)
  config.writeConfig ("config.ini")
