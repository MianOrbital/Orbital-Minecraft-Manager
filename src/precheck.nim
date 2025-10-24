#Copywrite Orbital Softworks 2025
#Licensed Under CC0 1.0

#This Simply Checks To See If The Config Exists Or Not
#Not The Greatest Logic, But It Allows A Better User Experience

import std/os

proc preCheck*(): bool =
  let config = "config.ini"
  result = fileExists(config)
