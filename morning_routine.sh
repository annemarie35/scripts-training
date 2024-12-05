#!/usr/bin/env bash

set -e
set -o pipefail

COUNTER=0
# Colorize output
green='\033[0;32m'
red='\033[0;31m'
orange='\033[0;33m'
no_color='\033[0m'

repositorieslist=($REPOS_LIST)

onlyCommandFound=false
noNpmCiCommandFound=false
skipRepositoryCommandFound=false

script_given_parameters=$@

function display_footer {
  echo "${green}🎉 Congratulations! Your environment has been updated for $COUNTER services.${no_color}\n"
}

function display_success_message {
  echo "---------------------------------------------------------------------------------------"
  echo "(⸝⸝ᵕᴗᵕ⸝⸝) $1 for ${green}$2${no_color}."
  echo "---------------------------------------------------------------------------------------${no_color}"
}

function display_error_message {
  echo "${red} ❌  The repository ${2} doesn't match repositories list.${no_color}"
}

function update_repository {
  local repositorieslist=($REPOS_LIST) repositoryname=$1 noNpmCiCommandFound=$2;

  if [[ ! $(echo "${repositorieslist[@]}" | fgrep -w $repositoryname) ]]; then
    display_error_message "This repository doesn't match repositories list" $repositoryname
    exit 1
  fi

  let COUNTER=COUNTER+1

  echo "${orange}---------------------------------------------------------------------------------------"
  echo " 🐦‍🔥 Starting updating $1"
  echo "---------------------------------------------------------------------------------------${no_color}"
  cd "$PROJECT_PATH"$1 || (display_error_message "The repository directory cannot be found" && exit 1);

  display_success_message "Switch to the dev branch" $1
  git checkout dev

  display_success_message "Synchronize dev branch with the latest changes" $1
  git pull --rebase

  if [[  "$noNpmCiCommandFound" = false ]]; then
    display_success_message "InstallAs dependencies" $1
    npm ci
  fi

  if [ "$1" != "commons" ]; then
    echo "--->  Build $1"
    npm run build
  fi

  display_success_message "Updating with success" $1
}

function getFlagsInParameters {
  if [[ $script_given_parameters  ==  *"--skip"* ]]; then
    echo "Found 'skip' in string."
    skipRepositoryCommandFound=true
  fi

  if [[ $script_given_parameters  ==  *"--no-npm-ci"* ]]; then
    echo "Found 'world' in string."
    noNpmCiCommandFound=true
  fi

  if [[ $script_given_parameters  == *"--only"* ]]; then
    echo "Found 'world' in string."
    onlyCommandFound=true
  fi
}

getFlagsInParameters

if [[ $onlyCommandFound == true && $skipRepositoryCommandFound == true ]]; then
  display_error_message "Please choose between skip and only parameters."
  exit 1
fi

if $skipRepositoryCommandFound; then
  # Remove --skip command from arguments
  word='--skip'
  respositories_to_skip=${script_given_parameters//$word/}
  number_of_words=$(wc -w <<< "$respositories_to_skip")
  echo "---> $number_of_words repositories to skip : $respositories_to_skip"

  # Remove each repo from available repos list
  all_repositories_list=${repositorieslist[@]}
    for repo in $respositories_to_skip; do
      if [ repo = "--no-npm-ci" ]; then
        noNpmCiCommandFound=true
      else
        all_repositories_list=${all_repositories_list//$repo/}
      fi
    done

  # Print the modified string
  number_of_words=$(wc -w <<< "$all_repositories_list")
  echo "---> $number_of_words repositories to update : $all_repositories_list"

  # Update only repos not skipped
  for repo in $all_repositories_list; do
    update_repository $repo $noNpmCiCommandFound
  done
  exit 1
fi

# Update only one repo or all the repositories
if $onlyCommandFound; then
  repositoryname="$2"
  if [ $repositoryname ]; then
    update_repository $repositoryname $noNpmCiCommandFound
  else
    display_error_message "Please provide the repository you want to only to update."
    exit 1
  fi
else
    for repositoryname in "${repositorieslist[@]}"; do
      update_repository "$repositoryname" $noNpmCiCommandFound
    done
fi

display_footer