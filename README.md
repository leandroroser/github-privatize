
GitHub Privatize
----------------

- This script allow you to to change the mode of all your public repositories to private mode. This option gives you flexibility to select later which repository should be public or not.

- The scripts also is able to create private/public copies of repositories (single/bulk copies).

Regarding this last option, as you know at the moment you can only create public forks of repositories (and if you want a private copy, you need to download the repo, push and configure, yay!). The script can create private forks easily (or if you prefer public forks). In addition, the script can also create bulk copies.

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

```python
$ bash ./github-privatize/github-privatize.sh 
```

Follow the instructions. The script will ask you:

- your username
- If you want to copy external repositories or changing your repositories to private mode
- The url or a txt file name (with a list of repositories) for external copy


For changing your repositories to private mode, you need the 'delete' permission when you generate
the access token. THIS FUNCTION CLONES YOUR REPOSITORY, DELETES YOUR ORIGINAL BRANCH, AND PUSHES THE COPY IN PRIVATE MODE. YOU MUST USE THIS SCRIPT AT YOUR OWN RESPONSIBILITY! 
A folder with your public repositories will be created in the process as security step.


License
-------
© Leandro Roser, 2021. Licensed under an [Apache-2](https://github.com/leandroroser/github-privatize/blob/main/LICENSE.txt) license.

