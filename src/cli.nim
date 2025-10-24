#Copywrite Orbital Softworks 2025
#Licensed Under CC0 1.0

#This File Handles (some of) the CLI procedures

import std/parsecfg

#Reads config.ini To Assign The Name And Version To The CLI
proc cliConfigReader():tuple[managerName: string, managerVersion: string] =
  let config = loadConfig("config.ini")
  
  let managerName = config.getSectionValue("Manager", "Manager Name")
  let managerVersion = config.getSectionValue("Manager", "Manager Version")

  result = (managerName, managerVersion)


#Main CLI Under An If/Else Flow
proc mainCli(managerName, managerVersion: string): string =
  echo("Welcome to ", managerName)
  echo("Version: ", managerVersion)
  echo("")
  echo("Please select an option:")
  echo("1. Install a modpack")
  echo("2. List all available modpacks")
  echo("3. Set universal RAM arguments")
  echo("4. Check for modpack updates")
  
  var userIn = readLine(stdin)
  if userIn == "1":
    result = "1"
  elif userIn == "2":
    result = "2"
  elif userIn == "3":
    result = "3"
  elif userIn == "4":
    result = "4"
  else:
    echo("Please input just one number")
    echo("Press enter to return...")
    discard readLine(stdin)
    return mainCli(managerName, managerVersion)


#Take the main CLI calls and ships them as a nice import
proc mainCliLogic*(): int =
  let config = cliConfigReader()
  let userIn = mainCli(config.managerName, config.managerVersion)
  
  if userIn == "1":
    result = 1
  elif userIn == "2":
    result = 2
  elif userIn == "3":
    result = 3
  elif userIn == "4":
    result = 4
  else:
    echo("Main CLI returned error!")
    discard readLine(stdin)
    quit()

#Calls if precheck fails
proc installCli*() =
  echo("Welcome!")
  echo("If this is your first time using the manager press enter to install!")
  echo("Make sure you have used admin permissions")
  echo("They are needed to create the folder...")
  echo("")
  echo("If you already have the manager installed, ensure the config.ini is in the right place")
  echo("Press enter to start the install process!")
  discard readLine(stdin)
