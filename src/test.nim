import std/json

#Reads meta data to gain pack info
proc packInfoGetter() =
  let modMan = parseFile("manifest.json")
  
  let modVanVer = modMan["minecraft"]["version"].getStr()
  echo modVanVer
  let modFrame = modMan["minecraft"]["modLoaders"]["id"].getStr()
  echo modFrame
  let modpVer = modMan["version"].getStr()
  echo modpVer
packInfoGetter()