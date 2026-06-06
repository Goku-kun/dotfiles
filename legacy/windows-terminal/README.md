# Setting up the randomized bg for Windows Terminal

1. use the settings-tobeused.json file but rename it as settings.json or simply copy-paste the contents to the settings.json file.
2. save the changeBackground.js file in the home folder and make it executable.
3. open up the cron-jobs using the command `cron -e` and setup the frequency and command for execution as follows:

```
# m h  dom mon dow   command

*/30 * * * * /home/novaxrono/changeBackground.js
```

4. Once this is done, simply restart the cronjobs using the `service` command.
5. DONE

