# xc_launcher
This script open .xcodeproj or .xcworkspace via Xcode on command line.

- If you have xcodeproj, open it.
- If you have xcodeproj and xcworkspace, open xcworkspace.
- If you have multiple Xcode projects, open the first one with the project name in A-Z order.

## Runtime Requirements

- Ruby 2.6.3 or later

## Installation

**Download script file**
```shell script
$ cd ~/Downloads/
$ curl -sO https://raw.githubusercontent.com/mothule/xc_launcher/master/xc
```

**Create symbolic link**
```shell script
$ ln -s /usr/local/bin ~/Downloads/xc
```

## Usage

If no argument is specified, the Xcode project will be searched in the current directory.
```shell script
$ cd your/xcode/project/directory
$ xc 
```

If you pass a directory path as the first argument, the Xcode project in that directory will be searched and opened.
```shell script
$ xc your/xcode/project/directory
```

## LICENSE
MIT License