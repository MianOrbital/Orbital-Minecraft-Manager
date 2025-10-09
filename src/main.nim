#Copywrite Oribtal Softworks 2025
#Licensed under CC0 1.0
#Clunking Clankers 0

#This is all of the procedures and value assignments.
#I may split some of this in the future but honestly Nim's circular import is stinky

#Std Lib Imports
import std/os
import std/httpclient
import std/json

#Community Imports
import zippy/ziparchives


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

#Forward Declarations

proc mainCli()
proc modpackInstaller()

#Start Of Procedures


#Launchs the launcher -WIP
proc launcher() =
  echo "WIP - launch via Mojang Launcher (set ram!)"


#Lists all available modpacks - Will probably make this fancy later
proc modpackList() =
  echo(
    "The following modpacks are available:",
    "Infinite Hyperdeath 3",
  )


#Sets user ram
proc ram(): string =
  echo("Please enter the amount of ram you would like to allocate in GB")
  echo("For example: for 1GB enter 1")
  var userIn = readline(stdin)
  result = "-Xmx" & userIn & "G"
  echo("Ram Argument Set to: ", result)


#Installs the main files for the launcher
proc launcherInstaller() =
  echo("holder")
  #install in program files, make this posix


#Main modpack CLI
proc modpackCli() =
  echo(
    "Please select from the following",
    "Modpack Name: Enter the modpack's name to install",
    "List: List available modpacks"
    )
  
  var userIn = readLine(stdin) #var for retries
  
  if userIn == "test":
    try:
      echo("Installing ", userIn)
      modpackInstaller()
      echo("Finished installing ", userIn)
      echo("Press enter to return to the main menu")
      mainCli()
    except:
      echo(
        "Errror during modpack install",
        getCurrentExceptionMsg()
      )
      modpackCli()
  
  elif userIn == "List":
    try:
      echo("Here are the available packs")
      modpackList()
      echo("Press enter to return to the modpack menu")
      discard readLine(stdin)
      modpackCli()
    except:
      echo(
        "Error during modpack listing",
        "Honestly not sure how that one happened",
        getCurrentExceptionMsg()
      )
      modpackCli()
  
  else:
    echo("Invalid input, try again")
    modpackCli()


#Main modpackInstaller - very messy
proc modpackInstaller() =
  setCurrentDir(managerDir)
  createDir("tempDownloads")
  setCurrentDir("tempDownloads")

  let client = newHttpClient()
  echo("Starting Modpack Download!")
  try:
    let response = client.get(modpackUrl)
    let f = open(modpackNameZip, fmWrite)
    f.write(response.body)
    f.close()
    echo("Downloaded Modpack!")
  except HttpRequestError as e:
    echo("HTTP Error: ", e.msg)
  except CatchableError as e:
    echo("General Error: ", e.msg)
  finally:
    try:
      client.close()
    except Exception as e:
      echo("Error Closing Client: ", e.msg)
  echo("Finished Downloader!")

  echo("setting dir to mainDir")
  setCurrentDir(managerDir)
  echo("joining dlPath")
  let dlPath = joinPath("tempDownloads", modpackNameZip)
  echo("starting extract")
  try:
    echo("extracting dlPath to tempDownloads")
    extractAll(dlPath, tempZipPath)
    echo("Finished Unzipping!")
  except CatchableError as e:
    echo("Error during unzip: ", e.msg)

  echo("Starting Install!")
  createDir("Modpacks" / modpackName)
  moveDir(modpackDlDir, modpackInstallDir)

  setCurrentDir(minecraftBin)
  createDir("versions" / modpackFramework)
  moveDir(frameworkDlDir, frameworkInstallDir)
  echo("Finished install!")

  setCurrentDir(minecraftBin)
  let javaRamArg = ram()
  var launcherProfileNode = parsefile("launcher_profiles.json")
  let modpackNode = %*  
    {"icon": "Enchanting_Table",
    "gamedir": managerDir / "Modpacks" / modpackName,
    "name": modpackName,
    "lastVersionID": modpackFramework,
    "JavaArgs": javaRamArg,
    "type": "custom"}
  launcherProfileNode["profiles"]["Infinite Hyperdeath 3"] =modpackNode #joins modpackNode to existing profile
  writeFile("launcher_profiles.json", pretty(launcherProfileNode)) #still "unsafe"
  echo("JSON Managment Finished!")

  setCurrentDir(managerDir)
  removeDir("tempDownloads")
  echo("Finished cleanup!")



# Main CLI interface
proc mainCli() =
  echo(
    "Welcome to ", managerName,
    "Version ", managerVersion,
    "",
    "Please select from the following:",
    "1. Launch ", managerName,
    "2. Install a modpack",
    "3. List the available modpacks",
    "4. First time install"
  )
  var userIn = readLine(stdin) #Var for retries
  
  if userIn == "1":
    try:
      echo("Starting the launcher!")
      launcher()
    except:
      echo("Error starting the launcher.",
        getCurrentExceptionMsg()
      )
  
  elif userIn == "2":
    try:
      echo("Starting the modpack installer!")
      modpackCli()
      echo("Modpack install finished!")
      echo("Press enter to return to main menu")
      discard readLine(stdin)
      mainCli()
    except:
      echo(
        "Error during the modpack installation process",
        getCurrentExceptionMsg()
      )

  elif userIn == "3":
    try:
      echo("Here are the available packs")
      modpackList()
      echo("Press enter to return to the main menu")
      discard readLine(stdin)
      mainCli()
    except:
      echo(
      "Error during modpack listing",
      "Honestly not sure how that one happened",
      getCurrentExceptionMsg()
      )

  elif userIn == "4":
    try:
      echo("Starting the launcher install!")
      launcherInstaller()
      echo("Install finished!")
      echo("Press enter to return to the main menu")
      discard readLine(stdin)
      mainCli()
    except:
      echo(
        "Error during launcher install",
        getCurrentExceptionMsg()
      )
  
  else:
    echo("Uh oh... Stinky!")
    mainCli()
mainCli()