# Project Daily Start & Stop Services

You will find here how to update all your repositories to 
- have last commits on dev branch, 
- fetch for new remote branches,
- and install or update node dependencies.

## Prerequisites
Install [Direnv](https://direnv.net/)

## How it works

If you use Direnvn, create a .envrc file
```bash
cp scripts/.envrc.sample envrc
```
Replace path with your own and add project repositories name that you have in local for example `'back-end customers message-history front-end receive-whatsapp receive-sms send-whatsapp send-sms commons'`

Run `direnv allow` in your project to charge env variables from `.envrc`

If you prefer you can export those env variables with other manner, like :

```bash 
export PROJECT_PATH=/Users/your-project-directory-path/
export REPOS_LIST='repository_name_1 repository_name_2'
```

Run the script for all the connect repositories, for example

```bash
sh scripts/morning_routine.sh
```

or just for one with `--only` with the repositoty name

```bash
sh scripts/morning_routine.sh --only back-end
```

skipping the npm ci step by just adding `--no-npm-ci`

```bash
sh scripts/morning_routine.sh --only back-end --no-npm-ci
```

or skip one or more repository with `--skip` with the repository name (can be combined with --no-npm-ci)

```bash
sh scripts/morning_routine.sh --skip commons back-end front-end  --no-npm-ci
```


