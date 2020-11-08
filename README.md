Visit my board at bbs.opicron.eu

# mysticbbs

Synology specific Docker install of the Mystic v1.12 alpha 39 BBS software

<img src="https://raw.githubusercontent.com/opicron/mysticbbs/master/main.PNG" width="300"><img src="https://raw.githubusercontent.com/opicron/mysticbbs/master/login.PNG" width="300">

// Yes, I know there is an version alpha 46, i'm running it-- upgrade yourself ;)

11/08/2020:
- added cleanup signal to entrypoint bash script
- no more forced shutdowns (see sigterm handling)

30/10/2020:
- added cron, zip, rar for fidopoll/mutil mail
- changed from stretch-slim to python2.7.18:stretch (see msg_seek() crash)
- added EXPOSE for BinkP mail server

28/10/2020:
- added manual compile Python 2.7.18 (overruled by cron, which installs 2.7.13)

29/09/2020:
- added EXPOSE ports for Synology docker
- changed cryptlib download link
- changed ENTRYPOINT
- changed main window to tail log instead of sleep
- added start/stop bash scripts
- added python for mystic scripts
- added pip for dependency installs
- added link from unrar to rar

# start/stop scripts

Used the following source for the start/stop scripts:
https://vswitchzero.com/mystic-systemd/

# todo:
- tba

# install

## Volumes

If you want to mount your custom mystic install you can mount the volume as below and it will override the fresh install. Do not mount the mystic volume if you wish to use the default install. It is recommended to copy the files after a fresh install and add the docker again mounting your own mystic folder to keep your configuration data outside the docker.

<img src="https://raw.githubusercontent.com/opicron/mysticbbs/master/volumes_crop.png" width="400">

## Logs

To make the usage easier the logs are tail'ed in main docker window as in the following example. 

<img src="https://raw.githubusercontent.com/opicron/mysticbbs/master/logs.png" width="400">

## Ports

Make sure you map the ports from AUTO to manually set ports. If not set manually Synology will set random ports on each restart:

<img src="https://raw.githubusercontent.com/opicron/mysticbbs/master/ports_crop.png" width="400">

# telnet clients

- MobaXterm (need configuration to get ANSI working well)
- Netrunner v2 (best for mystic and easy to configure)
- SyncTerm
- EtherTerm3
- MT32

# synology correct IP in docker

sudo iptables -t nat -A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
https://stackoverflow.com/questions/61624998/how-do-i-prevent-docker-from-source-nating-traffic-on-synology-nas

# modding

https://www.youtube.com/watch?v=uguo1hr2AQg

http://www.mysticbbs.com/downloads.html

https://anotherdroidbbs.wordpress.com/2017/07/04/display-ansi-art-in-mystic-menus/

http://www.mysticbbs.com/screenshots.html 

http://andr01d.zapto.org:8080//tutor/p1liner.txt.htm

http://andr01d.zapto.org:8080//tutor/1ledit.txt.htm

http://docs.wwivbbs.org/en/latest/conn/fail2ban/

https://www.youtube.com/watch?v=HLmjBydrL7U

# ssl

https://stackoverflow.com/questions/32856389/how-to-import-ssl-in-python-2-7-6

https://stackoverflow.com/questions/17309288/importerror-no-module-named-requests

# msg_seek crash

https://bbs.electronicchicken.com/?page=001-forum.ssjs&sub=fsxnet_fsx_mys&thread=3930

http://necrobbs.com/?page=001-forum.ssjs&sub=fsxnet_fsx_mys&thread=1627

# sigterm handling

https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash/146770#146770

https://stackoverflow.com/questions/41451159/how-to-execute-a-script-when-i-terminate-a-docker-container



