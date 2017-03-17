#!/bin/sh
set -e
#
# Usage:
#   'wget -qO- https://get.penkit.io | sh'
#

do_install() {
  echo
  echo "# Welcome to Penkit! (penkit.io)"
  echo
  echo "We will try to install Penkit for you!"

  if sleep 1 && which penkit &> /dev/null ; then
    echo
    echo "## Oh. You already have Penkit."
    echo
    echo "Bye"
    exit 0
  fi

  echo
  echo "## First, let's check some dependencies..."
  echo
  echo "### Looking for Docker..."
  echo
  if ! sleep 1 && which docker &> /dev/null ; then
    echo "Error: Docker was not found in your PATH"
    echo "Please install Docker: https://docs.docker.com/engine/installation/"
    echo
    echo "Bye"
    exit 1
  else
    echo "Found: $(docker --version)"
  fi

  INSTALL_MODE=docker

  echo
  echo "### Looking for Ruby..."
  echo
  if ! sleep 1 && which ruby &> /dev/null ; then
    echo "Warning: Ruby was not found in your path"
  else
    RUBY_VERSION=$(ruby --version)
    echo "Found: $RUBY_VERSION"

    # check for correct ruby version
    if echo $RUBY_VERSION | awk '{ print $2 }' | grep -e "^1.8" &> /dev/null ; then
      echo "Warning: Penkit does not work with Ruby 1.8"
    
    else

      echo
      echo "### Looking for Rubygems..."
      echo
      if ! sleep 1 && which gem &> /dev/null; then
        echo "Warning: Rubygems was not found in your PATH"
      else
        echo "Found: rubygems $(gem --version)"
        INSTALL_MODE=gem
      fi
    fi
  fi

  if [ $INSTALL_MODE = "gem" ]; then
    echo
    echo "## Installing via Ruby Gem..."
    echo
    sleep 3 && gem install penkit
  elif [ $INSTALL_MODE = "docker" ]; then
    echo
    echo "## Installing via Docker..."
    echo
    echo "### Downloading penkit/cli:latest Docker image..."
    sleep 1 && docker pull penkit/cli:latest
    echo
    echo "### Downloading penkit bash script to /usr/local/bin/..."
    sleep 1 && sudo wget --quiet https://gitlab.com/penkit/penkit/raw/master/scripts/penkit -O /usr/local/bin/penkit
    sudo chmod +x /usr/local/bin/penkit
  fi

  echo
  echo "## Verifing Penkit..."
  echo
  if ! which penkit &> /dev/null ; then
    echo "Error: We installed Penkit, but could not find it in your PATH"
    echo
    echo "Bye"
    exit 1
  else
    echo "Found: Penkit $(penkit version)"
    echo
    echo "## Successfully installed Penkit!"
    echo
    echo "Type \"penkit help\" to get started."
    echo
    echo "Bye"
    exit 0
  fi
}

do_install
