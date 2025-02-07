# mysticbbs

Docker install of the Mystic v1.12 alpha 48 BBS software.

Includes start, stop and boot script for correct signal term handling.

Visit opicron's board at bbs.opicron.eu

<img src="https://raw.githubusercontent.com/opicron/mysticbbs/master/main.PNG" width="300">
<img src="https://raw.githubusercontent.com/opicron/mysticbbs/master/login.PNG" width="300">

---

## How to use

1. install: `make install`
2. configure: `make config`
3. boot: `make start`
4. upgrade (optional):`make upgrade`
   - To upgrade, simply put the new install files in /installer and run the following commands:

---

## Changelog

### 05/16/2023

- it now installs into /mystic/src
- y4my4my4m revived this project and updated to the latest alpha release
- switched to ubuntu
- simplified the dockerfile
- added docker-support

### 08/11/2020

- added cleanup signal to entrypoint bash script
- no more forced shutdowns (see sigterm handling)

### 10/30/2020

- added cron, zip, rar for fidopoll/mutil mail
- changed from stretch-slim to python2.7.18:stretch (see msg_seek() crash)
- added EXPOSE for BinkP mail server

### 10/28/2020

- added manual compile Python 2.7.18 (overruled by cron, which installs 2.7.13)

### 09/29/2020

- added EXPOSE ports for Synology docker
- changed cryptlib download link
- changed ENTRYPOINT
- changed main window to tail log instead of sleep
- added start/stop bash scripts
- added python for mystic scripts
- added pip for dependency installs
- added link from unrar to rar

---

## Volumes

/mystic (the generated src is gitignored so as to not upload your data)

## Ports

Ports are forwarded to the host system. The following ports are used:

- 22    →　4000
- 22    →　4001
- 24554 →　4002

## telnet clients

- MobaXterm (need configuration to get ANSI working well)
- Netrunner v2 (best for mystic and easy to configure)
- SyncTerm
- EtherTerm3
- MT32
- TelnetClient for ZealOS

## start/stop scripts

Used the following source for the start/stop scripts:
[https://vswitchzero.com/mystic-systemd/]

## todo

- SSL via an apache docker needed?

## synology correct IP in docker

sudo iptables -t nat -A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER

[https://stackoverflow.com/questions/61624998/how-do-i-prevent-docker-from-source-nating-traffic-on-synology-nas]

## modding

[https://www.youtube.com/watch?v=uguo1hr2AQg]

[http://www.mysticbbs.com/downloads.html]

[https://anotherdroidbbs.wordpress.com/2017/07/04/display-ansi-art-in-mystic-menus/]

[http://www.mysticbbs.com/screenshots.html]

[http://andr01d.zapto.org:8080//tutor/p1liner.txt.htm]

[http://andr01d.zapto.org:8080//tutor/1ledit.txt.htm]

[http://docs.wwivbbs.org/en/latest/conn/fail2ban/]

[https://www.youtube.com/watch?v=HLmjBydrL7U]

## ssl

[https://stackoverflow.com/questions/32856389/how-to-import-ssl-in-python-2-7-6]

[https://stackoverflow.com/questions/17309288/importerror-no-module-named-requests]

## msg_seek crash

[https://bbs.electronicchicken.com/?page=001-forum.ssjs&sub=fsxnet_fsx_mys&thread=3930]

[http://necrobbs.com/?page=001-forum.ssjs&sub=fsxnet_fsx_mys&thread=1627]

## sigterm handling

[https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash/146770#146770]

[https://stackoverflow.com/questions/41451159/how-to-execute-a-script-when-i-terminate-a-docker-container]
