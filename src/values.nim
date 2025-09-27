#Assigns Global Values
#This will evolve into a config.ini

#Standard Library
import std/os


#Top Level Manually Set Constants 
let managerName = "Orbital Minecraft Manager"
let managerDirName ="OrbitalMinecraftManager"
let managerVersion = "0.4"

#Top Level StdLib Dependent Constants
#These Are Windows Specific
let userProgramDir = getEnv("PROGRAMFILES")
let userRoamAppDir = getEnv("APPDATA") 


#Second Level Constants
let managerDir = joinPath(userProgramDir, managerDirName)
let minecraftBin = joinPath(userRoamAppDir, ".minecraft")

#Top Level Modpack Specifc Variables
#These will be set automatically in the furture.
let modpackUrl = "https://www.dropbox.com/scl/fi/qmb6mdbqd4scstktnj9h2/Modpack.zip?rlkey=32jszohogtyn86xuceyr585ui&st=bm7beeq7&dl=1"
let modpackName = "Infinite Hyperdeath 3"
let modpackNameZip = "Modpack.zip"
let modpackFramework = "1.20.1-forge-47.4.0"

#Second Level Modpack Specific Variables
let tempZipPath = joinPath("tempDownloads", "tempZip")
let modpackInstallDir = joinPath(managerDir, "Modpacks", modpackName)
let frameworkInstallDir = joinPath(minecraftBin, "versions", modpackFramework)

#Third Level Modpack Specific Variables
let modpackDlDir = joinPath(managerDir, tempZipPath, modpackName)
let frameworkDlDir = joinPath(managerDir, tempZipPath, modpackFramework)