#! /usr/bin/env node
const { exec } = require("child_process");
if (process.argv.length < 3) {
    throw new Error("No file specified.");
}
var arg = process.argv.slice(2)[0];

arg = arg.split(".")[0];

exec(`g++ ${arg}.cpp -o ${arg}`, (error, stdout, stderr) => {
    if (error) {
        console.error(`Compile time error!\n \n${error}`);
        return;
    }

    if (stderr) {
        console.log("Compilation generated error starts.");
        console.log(stderr);
        console.log("Compilation generated error ends.");
        return;
    }

    if (stdout) {
        console.log("Compilation output starts.");
        console.log(stdout);
        console.log("Compilation output ends.");
    }

    exec(`./${arg}`, (error, stdout, stderr) => {
        if (error) {
            console.log(`Error executing the output. ${error}`);
            return;
        }

        if (stderr) {
            console.log("ERROR:");
            console.log("**********************************");
            console.log(stderr);
            console.log("**********************************");
        }

        if (stdout) {
            console.log("OUTPUT:");
            console.log("**********************************");
            console.log(stdout);
            console.log("**********************************");
        }
    });
});
