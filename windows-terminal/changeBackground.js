#! /usr/bin/node
"use strict";
const fs = require("fs");
const path = require("path");
// const minify = require('node-json-minify');

changeBackground();
function changeBackground() {
    const settingsPath =
        "/mnt/c/Users/jethv/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json";
    var folderPath = "/mnt/c/Users/jethv/Pictures/Anime/";
    var folderWritePathWindows = "C:/Users/jethv/Pictures/Anime/";

    // reading the settings file and creating an Object
    var settings = fs.readFileSync(settingsPath, { encoding: "utf-8" });
    var settingsObject = JSON.parse(settings); // while reading the first time, clear the comments using minify and then mutate the object

    // reading the filenames of the anime folder
    var fileNames = fs.readdirSync(folderPath);

    //building the image path
    var newImagePath = path.join(
        folderWritePathWindows,
        fileNames[Math.floor(Math.random() * fileNames.length)]
    );

    // updating the image path in the settings object
    settingsObject.profiles.list[2].backgroundImage = newImagePath;

    //converting to string and writign back to the file.
    var settingsString = JSON.stringify(settingsObject);
    fs.writeFileSync(settingsPath, settingsString);
}
