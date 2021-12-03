#!/bin/bash
# Fork to private repo

clone() {

    name=$1
    repo=$2
    priv=$3
    folder=$(echo $repo | awk '{ gsub(".*github.com.*/", "./"); print $0}')
    basename=$(echo $folder | awk '{ gsub("./", ""); print $0}')
    repo_full=https://github.com/$name/$basename.git 
    
    if [ "$priv" == "y" ]; then
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

    basename =$(echo $1 | awk '{ gsub(".*/", ""); print $0}')
    repo=https://github.com/$1.git 
    echo "Privatizing repository: $repo"
    repo=https://github.com/$repo.git 
    git clone $repo
    cd $basename
    gh repo delete $repo --confirm
    gh repo create $repo --confirm --private
    git push $repo
    cd ..   
    rm -rf $basename
    echo "Repository privatized: $repo"

}


main() {

    read -p "Enter your GitHub username : " name
    read -p "Enter your option:
    1: For copying external repositories 
    2: For privatizing your public repositories
    Your option": option

    if [ $option -eq 1 ]; then
        read -p "Do you want the copies to be private? (y/n): " private
        read -p "Enter the repository url or a txt file name: " repo
        if [[ $repo =~ ".txt" ]]; then
            while read line;
            do 
                if [ "$line" != "" ]; then
                    echo "clone $line"
                    clone $name $line $private
                fi
            done < $repo
        else
            clone $name $repo
        fi


    elif [ $option -eq 2 ]; then
        read -p "Please confirm writing the word 'PRIVATIZE':" confirm
        if [ $confirm == "PRIVATIZE" ]; then
            repos=($(gh repo list $1 --public | sed 's/\s.*//g'))
            for repo in "${repos[@]}"
                do
                    clone_auto $repo
                done
        else
            echo "Wrong confirmation. Aborted!"
        fi
    else
        echo "Invalid option. Aborted!"
    fi
}

main 
