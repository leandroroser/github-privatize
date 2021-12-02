
As you know, at the moment you can only create public forks of repositories (and if you want a private copy, you need to download the repo, push and configure, yay!).

This script will allow you to create private forks easily. In addition, the script can create bulk copies of repositories in private mode. 

## Requisites

You need to install github cli and login:
https://cli.github.com/


```
gh auth login

```

## Clone this repo

```
$ git clone https://github.com/leandroroser/github-privatize.sh
```

## Usage

```
$ cd github-privatize

# here the repo to copy:
$ bash github-privatize.sh https://github.com/leandroroser/dummy

# or bulk copy:
$ bash github-privatize.sh txt_file_with_repos.txt
```
