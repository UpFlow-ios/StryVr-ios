#!/bin/bash

# StryVr Safe Build Manager
# Prevents multiple Xcode builds from running simultaneously

# Delegate to the safe build manager
exec "$(dirname "$0")/Scripts/safe_build.sh"


