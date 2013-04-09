#!/bin/bash

iwatch -e close_write -c "lua external/ldoc/ldoc.lua src" -X "[~#]." -r src
