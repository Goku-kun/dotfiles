# Compiler CPP

This script is responsible for compiling a cpp file and then creating an output file of the same name as the compiled file.
Then, the output is executed by this script without the need of invoking the output file separately.


## Dependencies
Only depends on node modules. No extra dependencies needed.

## Setup
1. git clone this repository.
2. Go into the "compiler-cpp-util" folder and run `sudo npm link`.
3. That's it. The `compilercpp` command will now be accessible everywhere.


## Usage:
1. Once the setup is done, use the `compilercpp {FILENAME}` as the command to compile and execute the cpp file.
2. The terminal will show the stdout and stderr with the respective annotations if the cpp program uses these streams.

## Example:
"compiler-cpp-util" folder contains a "sample_test_cpp" folder with a cpp file.
`cd` into the folder and run the following command:
`compilercpp Hello_World.cpp`

This will print the following output:
```
OUTPUT:
**********************************
Hello World

**********************************
```
