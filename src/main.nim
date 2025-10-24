#Copywrite Orbital Softworks 2025
#Licensed Under CC0 1.0

import cli
import precheck
import managerinstaller
import modpackinstaller
import misc
import configmaker

#Kind of the real main
proc mainCliCaller() =
  let userOpt = mainCliLogic()
  if userOpt == 1:
    modpackInstallLogic()
  elif userOpt == 2:
    echo listConfigReader()
  elif userOpt == 3:
    ramLogic()
  elif userOpt == 4:
    updaterLogic()
    
#Entry point, checks config for install
proc main() =
  if preCheck() == true:
    mainCliCaller()
  if preCheck() == false:
    installCli()
    configmaker()
    managerInstallerLogic()
    mainCliCaller()
main()