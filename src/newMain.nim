#Copywrite Oribtal Softworks 2025
#Licensed under CC0 1.0
#Clunking Clankers 0

import std/json
import std/httpclient
import std/streams
import std/os

#Reads meta data to gain pack info
proc packInfoGetter(modpack: string): truple =
	let modMan = parseFile("manifest.json")
	let modVanVer = modMan["minecraft"]["version"].getStr()
	let modFrame = modMan["minecraft"]["modloader"]["id"].getStr()
	let modpVer = modMan["version"].getStr()

#Community Imports
import zippy/ziparchives

#Downloads the needed vanilla version .jar
proc downloadVerJar(verJarFile: string, verJarUrl: string) =
  var client = newHttpClient()

  downloadFile(client, verJarUrl, verJarFile)
  close(client)

#Downloads the needed vanilla version .json
proc downloadVerJson(verJsonFile: string, verJsonUrl: string) =
  var client = newHttpClient()
  
  let response = get(client, verJsonUrl)
  let strResonse = readAll(response.bodyStream)
  writeFile(verJsonFile, strResonse)
  close(client)


#Finds the vanilla version .json from the repository and returns the URL
#This will be passed to the downloader
proc getVerJsonUrl(targetId: string): string =
  let verManNode = parseFile("version_manifest_v2.json")
  let versions = verManNode["versions"]

  for versionNode in versions.getElems():
    let idNode = versionNode["id"]

    if idNode.kind == JString and idNode.getStr() == targetId:
      echo "Found version: ", targetId

      let url = versionNode["url"].getStr()
      result = url
