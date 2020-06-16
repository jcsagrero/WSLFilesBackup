# Python zsh functions

run()
{
    command="$1"
    # echo $command
    echo -e "print($command)" | python3
}

fromhex()
{
    HEX="$1"
    # echo $BINARY
    echo -e "print(int('$HEX', 16))" | python3
}

tohex()
{
    NUM="$1"
    # echo $BINARY
    echo -e "print(hex($NUM))" | python3
}

frombin()
{
    BINARY="$1"
    # echo $BINARY
    echo -e "print(int('$BINARY',2))" | python3
}

tobin()
{
    NUM="$1"
    # echo $BINARY
    echo -e "print(bin($NUM))" | python3
}
