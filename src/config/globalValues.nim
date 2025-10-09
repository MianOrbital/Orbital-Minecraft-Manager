#Assigns Global Values
#This will evolve into a config.ini

#Standard Library
import std/os


#Top Level Manually Set Constants 
let
  topLvlNoDep* = (
    mainName: "Orbital Minecraft Manager",
    mainDirName: "Orbital_Minecraft_Manager",
    version: "0.2"
  )

#Top Level StdLib Dependent Constants
let
  topLvlStdLib* = (
    userLocalAppDir: getCacheDir(), #Cross Platform
    userRoamAppDir: getEnv("APPDATA") #Windows specific maybe
  )

#Second Level Constants
let
  secLvlStdLib* = (
    mainDir: joinPath(topLvlStdLib.userLocalAppDir, topLvlNoDep.mainDirName),
    minecraftBin: joinPath(topLvlStdLib.userRoamAppDir, ".minecraft")
  )

#Modpack Specifc Variables (These will be assigned elsewhere in the future)
var
  topLvlModVars* = (
    modpackUrl: "https://www.dropbox.com/scl/fi/jk3w6h9hiqdktehwnttzs/Modpack.zip?rlkey=h0nm86f05t7xhg8izpk0azp2p&st=3m3ltn35&dl=1",
    modpackName: "Infinite Hyperdeath 3",
    modpackNameZip: "Modpack.zip",
    modpackFramework: "1.20.1-forge-47.4.0"
  )

#Second Level Modpack Variables
var
  secLvlModVars* = (
    tempZipPath: joinPath("tempDownloads", "tempZip"),
    modpackInstallDir: joinPath(secLvlStdLib.mainDir, "Modpacks", topLvlModVars.modpackName),
    frameworkInstallDir: joinPath(secLvlStdLib.minecraftBin, "versions", topLvlModVars.modpackFramework)
  )

#Third Level Modpack Vars
var
  thrdLvlModVars* = (
    modpackDlDir: joinPath(secLvlStdLib.mainDir, secLvlModVars.tempZipPath, topLvlModVars.modpackName),
    frameworkDlDir: joinPath(secLvlStdLib.maindir, secLvlModVars.tempZipPath, topLvlModVars.modpackFramework)
  )