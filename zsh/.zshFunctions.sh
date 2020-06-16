#Functions


function execLast {
    # get previous history item
    zle up-history
    # confirm command
    zle accept-line
}

# define execLast widget from function of the same name
zle -N execLast
bindkey '^[.' execLast


first-tab() {
    if [[ $#BUFFER == 0  ]]; then
     BUFFER="cd "
     CURSOR=3
     zle list-choices
     else
     zle expand-or-complete
    fi
}
zle -N first-tab
bindkey '^I' first-tab



makeg()
{
    makeTarget=$1
#    echo "running makeg"
    #alias make="/usr/bin/make -j 8"
    make -j8 $makeTarget 2>&1 | grep -P  ":\d{1,3}"

}

commit()
{
    if [ ! -d ".git" ]; then
        echo "Directory does not contain a git repository. Exiting."
        return
    fi

    echo "Please enter a commit message or hist ctrl-c to cancel commit: "
    message=
    vared -p "Message: " message 

#   echo $message
    echo -e "\n"
    git add .
    git commit -a -m "$message"

    echo "Done commiting"
    echo -e "\nWould you like to push?"
    read ans
    if [ "x$ans" = "xy" ]; then
        echo "Pushing to remote..."
        git push
    else
        echo "Will not push. Exiting"
    fi

}

newJava()
{
    $file=$1
    $basename=$2

    print -s "java $basename"
    print -s "javac ./$file"
    echo "
public class $basename
{
    public static void main(String[] args) {

        System.out.println(\"$basename starting...\");
    }
}
" > $file

}

newSh()
{
    echo "#!/bin/bash " > $file
    print -s ./$file
    print -s ./$file
}

newPy()
{
    file=$1
    baseName=$2
    echo "#!/usr/bin/python3" > $file
    print -s ./$file
    print -s ./$file
}

newCpp()
{
    file=$1
    baseName=$2
    print -s "./$basename"
    print -s "make $basename"
    echo "#include <iostream>
using namespace std;

int main(int argc, char *argv[])
{
    cout << \"$basename starting...\" << endl;

    return 0;
} " > $file
}

newC()
{
    file=$1
    baseName=$2
    print -s "./$basename"
    print -s "make $basename"
    echo "#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    printf(\"$basename starting...\\\n\");

    return 0;
} " > $file
}


newH()
{
    file=$1
    baseName=$2
    upper=`echo $baseName | tr a-z A-Z`
    echo "upper: $upper"
    echo "#ifndef ${upper}_H
#define ${upper}_H


#endif" > $file


}


new()
{
    file=$1
    touch $file && chmod +x $file
    basename="${file%.*}"
    extension="${file##*.}"
    #echo $extension
    if [ -s "$file" ]; then
        return 1
    fi

    if [ "$extension" = 'sh' ]; then
        newSh $file
    fi
    if [ "$extension" = 'py' ]; then
        newPy $file
    fi

    if [ "$extension" = 'java' ]; then
        newJava $file $basename
    fi

    if [ "$extension" = 'cpp' ]; then
        newCpp $file $basename
    fi

    if [ "$extension" = 'c' ]; then
        newC $file $basename
    fi

    if [ "$extension" = 'h' ]; then
        newH $file $basename
    fi

    open $file
}

selectFileTypeInDir()
{
    DIR=$1
    TYPE=$2

    files=($DIR/*.$TYPE)

    read  "selection?$(
            f=0
            for filename in "${files[@]}" ; do
                    filename=`basename $filename`
                    filename=`echo "$filename" | cut -d'.' -f1`
                    echo "$((++f)): $filename"
            done

            echo -ne 'Please select a workspace: '
    )"
    selected_file="${files[$((selection))]}"
    echo `basename $selected_file`
}


workspace()
{
    WORKSPACES_DIR="/mnt/c/Users/joses/Desktop"
    EXTENSION="code-workspace"
    NAME=`selectFileTypeInDir $WORKSPACES_DIR $EXTENSION`
    # echo $NAME
    pushd > /dev/null
    cd /mnt/c/Users/joses/Desktop > /dev/null
    cmd.exe /C code $NAME > /dev/null
    popd > /dev/null
    NAME=`echo "$NAME" | cut -d'.' -f1`
    echo "Opening VSCode workspace $NAME"
}

open()
{
    file=$1
    basename="${file%.*}"
    extension="${file##*.}"
    if [ "$file" = "." ]; then
        /mnt/c/Windows/System32/cmd.exe /C start $file
    elif [ "$file" = "test" ]; then
        currDir=`pwd`
        cd /mnt/c/Users/joses/Desktop > /dev/null
        /mnt/c/Windows/System32/cmd.exe /C code Test.code-workspace > /dev/null
        cd $currDir
    else
        /mnt/c/Windows/System32/cmd.exe /C code $file
    fi

}

# open()
# {

#     file=$1
#     basename="${file%.*}"
#     extension="${file##*.}"

#     if [ "$extension" = "$basename" ]; then
#         cmd.exe /C code $file
#     else
#         cmd.exe /C start $file
#     fi



# }

chCurr()
{
    echo "`pwd`" > ~/.currDir
}

curr()
{
    cd "`cat ~/.currDir`"
}
