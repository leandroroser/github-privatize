#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

catch_error() {
    echo "Error: $1" >&2
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


main() {
    read -p "Enter your GitHub username : " name
    while  read -p "Enter your option:
    1: For copying external repositories 
    2: For setting private mode in your public repositories
    Your option: " option ; do    
        case $option in
            1)
                break 
                ;;
            2)
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
            while read line;
            do 
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
        repos=($(gh repo list $name --public --limit 1000000 | sed 's/\s.*//g'))
        if [ ${#repos[@]} -eq 0 ]; then
            catch_error "There was a problem listing your public repositories. You have no public repos or you are above the API request limits for listing requests. Exiting..."
        else
            for clone_repo in "${repos[@]}"
            do
                clone_auto $clone_repo
            done
        fi

        cd ..
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
    else
        catch_error "Invalid input. Aborted!"
    fi
}

main 
