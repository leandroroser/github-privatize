#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

catch_error() {
    echo "Error: $1"
    exit 1
}

clone() {
    name=$1
    repo=$2
    priv=$3
    folder=$(echo $repo | awk '{ gsub(".*github.com.*/", "./"); print $0}')
    basename=$(echo $folder | awk '{ gsub("./", ""); print $0}')
    repo_full=https://github.com/$name/$basename.git 
    
    if [[ "$priv" =~ [Yy].* ]]; then
        gh repo create $repo_full --confirm --private
    else
        gh repo create $repo_full --confirm --public
    fi
    rm -rf $basename
    message="Copying repo... to $repo_full"
    git clone $repo
    cd $folder
    git remote set-url origin $repo_full
    git branch -M main
    git push origin main
    cd ..   
    rm -rf $folder
    echo "Done!"
}


clone_auto() {  
    basename=$(echo $1 | awk '{ gsub(".*/", ""); print $0}')
    this_repo=https://github.com/$1.git 
    echo "Privatizing repository: $this_repo"
    git clone $this_repo
    cd $basename
    git remote remove origin
    gh repo delete $this_repo --confirm
    gh repo create $this_repo --confirm --private
    git remote set-url origin $this_repo
    git branch -M main
    git push $this_repo main
    cd ..   
    echo "Repository privatized: $this_repo"
}

clone_migration() {
    name=$1
    repo=$2
    priv=$3
    folder=$(echo $repo | awk '{ gsub(".*github.com.*/", "./"); print $0}')
    basename=$(echo $folder | awk '{ gsub("./", ""); print $0}')
    git clone $repo
}

push_migration() {
    name=$1
    repo=$2
    priv=$3
    folder=$(echo $repo | awk '{ gsub(".*github.com.*/", "./"); print $0}')
    basename=$(echo $folder | awk '{ gsub("./", ""); print $0}')
    repo_full=https://github.com/$name/$basename.git 

    mkdir dummy_repository
    cd dummy_repository
    if [[ "$priv" == y ]]; then
        gh repo create $repo_full --confirm --private
    else
        gh repo create $repo_full --confirm --public
    fi
    cd ..
    rm -rf dummy_repository

    message="Copying $repo to $repo_full"
    cd $folder
    git remote set-url origin $repo_full
    git branch -M main
    git push origin main
    cd ..   
    rm -rf $folder
}

remove_cache() {
    while read -p 'Remove cache? (y/n): ' input; do    
            case $input in
                [yY]*)
                    rm -rf github_cache_privatize
                    echo "Cache removed"
                    echo "Done!"
                    break
                    ;;
                [nN]*)
                    echo "Done!"
                    break
                    ;;
                *)
                    echo 'Invalid input, try again' >&2
            esac
        done
}


main() {
    read -p "Enter your GitHub username : " name
    while  read -p "Enter your option:
    1: For copying external repositories 
    2: For setting private mode in your public repositories
    3: For migrating all your repositories to a new account
    Your option: " option ; do    
        case $option in
            1)
                break 
                ;;
            2)
                break
                ;;
            3)
                break
                ;;
            *)
                echo 'Invalid input, try again' >&2
        esac
    done

    if [ $option -eq 1 ]; then
        while  read -p "Do you want the copies to be private? (y/n): " private; do    
            case $private in
                [yYnN]*)
                    break 
                    ;;
                *)
                    echo 'Invalid input, try again' >&2
            esac
        done

        read -p "Enter the repository url or a txt file name: " repo
        if [[ $repo =~ .*[.]txt$ ]]; then
            while read line; do 
                if [ "$line" != "" ]; then
                    echo "clone $line"
                    clone $name $line $private
                fi
            done < $repo
        else
            clone $name $repo $private || catch_error "Problem with cloning. Exiting..."
        fi


    elif [ $option -eq 2 ]; then
        counter=0
        while  read -p "Please confirm writing the key word 'PRIVATIZE':" confirm; do    
            case $confirm in
                PRIVATIZE)
                        break 
                        ;;
                *)  if [ $counter -gt 1 ]; then
                        catch_error "You have entered wrong the key word 3 times. Exiting..."
                    else
                        echo 'Invalid input, try again' >&2
                        ((counter++))
                    fi
            esac
        done

        gh auth refresh -h github.com -s delete_repo
        mkdir github_cache_privatize
        cd github_cache_privatize
        repos=($(gh repo list $name --public | sed 's/\s.*//g'))
        if [ ${#repos[@]} -eq 0 ]; then
            catch_error "There was a problem listing your public repositories. You have no public repos or you are above the API request limits for listing requests. Exiting..."
        else
            for clone_repo in "${repos[@]}"; do
                clone_auto $clone_repo
            done
        fi

        cd ..
        remove_cache
    
    elif [ $option -eq 3 ]; then
        read -p "Enter the username of the GitHub destiny account: " destiny
        reporead -p 'Open in your default web browser your destiny GitHub profile, press enter when you are ready...'s_public=($(gh repo list $name --public | sed 's/\s.*//g'))
        repos_private=($(gh repo list $name --private | sed 's/\s.*//g'))
        read -p 'Open in your default web browser your destiny GitHub profile, press enter when you are ready...'
        mkdir github_cache_privatize
        cd github_cache_privatize
        
        if [ ${#repos_private[@]} -eq 0 ]; then
            echo "No private repositories to migrate (or you reached the GitHub api limit for listing repositories)..."
        else
            for clone_repo_private in "${repos_private[@]}";do
                git clone $clone_repo_private
            done
        fi

        if [ ${#repos_public[@]} -eq 0 ]; then
            echo "No public repositories to migrate (or you reached the GitHub api limit for listing repositories)..."
        else
            for clone_repo_public in "${repos_public[@]}";do
                git clone $clone_repo_public
            done
        fi

        gh auth login 

        for clone_repo_private in "${repos_private[@]}";do
            push_migration $destiny $clone_repo_public y
        done

        for clone_repo_public in "${repos_public[@]}";do
            push_migration $destiny $clone_repo_public n
        done

        cd ..
        remove_cache

    else
        catch_error "Invalid input. Aborted!"
    fi
}

main 
