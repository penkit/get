#!/bin/sh
set -e
#
# Usage:
#   'wget -qO- http://get.penkit.io | sh'
#

do_install() {
  echo
  echo "# Welcome to Penkit! (penkit.io)"
  echo
  echo "How would you like to like to install penkit?"
  echo "1) Docker Container"
  echo "2) Ruby Gem"

  read input

  if [ $input = 1 ]; then
    echo
    echo "### Looking for Docker..."
    echo
    if ! sleep 1 && which docker > /dev/null 2> /dev/null ; then
      echo "Error: Docker was not found in your PATH"
      echo "Please install Docker: https://docs.docker.com/engine/installation/"
      echo
      echo "Bye"
      exit 1
    else
      echo "Found: $(docker --version)"
      INSTALL_MODE=docker
    fi
  elif [ $input = 2 ]; then
    echo
    echo "### Looking for Ruby..."
    echo
    if ! sleep 1 && which ruby > /dev/null 2> /dev/null ; then
      echo "Warning: Ruby was not found in your PATH"
      exit 1
    else
      RUBY_VERSION=$(ruby --version)
      echo "Found: $RUBY_VERSION"

      # check for correct ruby version
      if echo $RUBY_VERSION | awk '{ print $2 }' | grep -e "^1.8" > /dev/null 2> /dev/null ; then
        echo "Warning: Penkit does not work with Ruby 1.8"
        exit 1
      else
        echo
        echo "### Looking for Rubygems..."
        echo
        if ! sleep 1 && which gem > /dev/null 2> /dev/null; then
          echo "Warning: Rubygems was not found in your PATH"
          exit 1
        else
          echo "Found: rubygems $(gem --version)"
          INSTALL_MODE=gem
        fi
      fi
    fi
  else
    echo "Invalid input"
    exit 1
  fi

  if [ $INSTALL_MODE = "gem" ]; then
    echo
    echo "## Installing via Ruby Gem..."
    echo
    sleep 1 && gem install penkit
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
  if ! which penkit > /dev/null 2> /dev/null ; then
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
