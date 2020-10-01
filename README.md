Visit my board at bbs.opicron.eu

# mysticbbs

Synology specific Docker install of the mystic BBS software

29/09/2020:
- added EXPOSE ports for Synology docker
- changed cryptlib download link
- changed ENTRYPOINT
- changed main window to tail log instead of sleep
- added start/stop scripts

# start/stop scripts

Used the following source for the start/stop scripts:
https://vswitchzero.com/mystic-systemd/

# todo:
- tba

# install

Volumes:

If you want to mount your custom mystic install you can mount the volume as below and it will override the fresh install. Do not mount the mystic volume if you wish to use the default install. It is recommended to copy the files after a fresh install and add the docker again mounting your own mystic folder to keep your configuration data outside the docker.

![Alt text](/volumes.png?raw=true "Volumes")

Ports:

![Alt text](/ports.png?raw=true "Ports")

# random

https://anotherdroidbbs.wordpress.com/2017/07/04/display-ansi-art-in-mystic-menus/
http://www.mysticbbs.com/screenshots.html 
