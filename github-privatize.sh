#!/bin/bash
# Fork to private repo

clone() {
    
    name=$1
    repo=$2
    folder=$(echo $repo | awk '{ gsub(".*github.com.*/", "./"); print $0}')
    basename=$(echo $folder | awk '{ gsub("./", ""); print $0}')
    repo_full=https://github.com/$name/$basename.git 

    gh repo create $repo_full --confirm --private
    rm -rf $basename
    message="Copying repo..."
    git clone $repo

    cd $folder
    rm -rf .git

    git init
    git add .
    git commit -m "first commit"
    git branch -M main
    git remote add origin https://github.com/$name/$basename.git 
    git push origin main
    cd ..   
    rm -rf $folder

    echo "Done!"
    echo "Repo url : $repo_full"
}


read -p "Enter your GitHub username : " name
read -p "Enter the repository url : " repo

if [[ $repo =~ ".txt" ]]; then
    while read line;
    do 
        if [ "$line" != "" ]; then
            echo "clone $line"
            clone $name $line
        fi
    done < $repo
else
    clone $name $repo
fi
