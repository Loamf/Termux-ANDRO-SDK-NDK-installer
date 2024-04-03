# ANDRO-SNDK
Android-SDK and NDK for Termux.

## Requirement packages

`
apt update && yes | apt upgrade && yes | apt install coreutils figlet
`

## Usage options
```
Usage: bash android-sdk.sh [option]

        option                  Description

        --pkgs                  For install requirements
        --help or -h            For see instructions
        --codeassist            For install codeAssist app
                                from PlayStore.
        --install-sdk           For setup Android sdk and
                                ndk on termux.
        --size                  For watch Download file
                                size.
        --template              set template for
                                termux gradle.

hint: bash android-sdk.sh --codeassist
```
