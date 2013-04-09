#!/bin/bash

# If the ldoc project hasn't been checked out:
if [ ! -d "external/ldoc" ]; then
    # Clone ldoc for documentation generation
    git clone https://github.com/stevedonovan/LDoc.git external/ldoc
fi

