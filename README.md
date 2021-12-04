
GitHub Privatize
----------------

- This script allows you convert all your public repositories into private. This option gives you the flexibility of selecting after the process which repositories should be public or not. Under the hood, it is using github/github-cli commands and clone/push processes.

- The scripts can also create private/public copies of repositories (single/bulk copies). As you may know, at this moment you can only create public forks of repositories (and if you want a private copy, you need to download the repo, push and configure, etc). The script can create private forks easily (or if you prefer, public forks).

## Requisites

You need to install github-cli and login:
https://cli.github.com/


```python
$ gh auth login
```

## Clone this repo

```python
$ git clone https://github.com/leandroroser/github-privatize.sh
```

## Usage

```python
$ sh ./github-privatize/github-privatize.sh 
```

Follow the instructions. The script will ask you:

- your username
- If you want to copy external repositories or changing your public repositories to private mode
- The GitHub URL or a txt file name (with a list of repositories URLs) for external copy


For changing your repositories to private mode, you need the 'delete' permission for your generated access token. THIS FUNCTION CLONES YOUR REPOSITORY, DELETES YOUR ORIGINAL BRANCH, AND PUSHES A FRESH PRIVATE COPY. YOU MUST USE THIS SCRIPT AT YOUR OWN RESPONSIBILITY! 
A folder with your public repositories will be created in the process as security copies.


License
-------
© Leandro Roser, 2021. Licensed under an [Apache-2](https://github.com/leandroroser/github-privatize/blob/main/LICENSE.txt) license.

