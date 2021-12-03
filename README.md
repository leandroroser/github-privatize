
GitHub Privatize
----------------

This script allow you to create private/public copies of repositories (single/bulk copy) or to change the mode of your repositories from public to private. This latter options gives you flexibility to select later which repository should be public or not.

Regarding the first option, as you know at the moment you can only create public forks of repositories (and if you want a private copy, you need to download the repo, push and configure, yay!). The script can create private forks easily (or if you prefer public forks). In addition, the script can also create bulk copies of repositories in private mode.

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
$ cd github-privatize

$ bash github-privatize.sh 
```

Follow the instructions. The script will ask you:

- your username
- If you want to copy external repositories or changing your repositories to private mode
- The url or a txt file name for external repository copy


For changing your repositories to private mode, you need the 'delete' permission when you generate
the access token. THIS FUNCTION CLONES YOUR REPOSITORY, DELETES YOUR ORIGINAL BRANCH, AND PUSHES THE COPY IN PRIVATE MODE. THE FUNCTION IS EXPERIMENTAL AND YOU MUST USE IT AT YOUR OWN RESPONSIBILITY! A folder with your public repositories will be created in the process as security step.
