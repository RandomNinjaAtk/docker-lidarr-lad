
# [RandomNinjaAtk/lidarr-lad](https://github.com/RandomNinjaAtk/docker-lidarr-lad)

[Lidarr](https://github.com/lidarr/Lidarr) is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.


[Lidarr-Automated-Downloader (LAD)](https://github.com/RandomNinjaAtk/lidarr-automated-downloader) is a open-source script that is integrated into this container

This containers base image is provided by: [linuxserver/lidarr:preview](https://github.com/linuxserver/docker-lidarr)

[![lidarr](https://github.com/lidarr/Lidarr/blob/develop/Logo/400.png)](https://github.com/lidarr/Lidarr)


## Supported Architectures

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |

## Version Tags

| Tag | Description |
| :----: | --- |
| latest | Lidarr Nightly releases |


## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| --- | --- |
| `-p 8686` | Application WebUI |
| `-p 1730` | DL Client WebUI |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e UMASK_SET=022` | control permissions of files and directories created by Lidarr. |
| `-v /config` | Configuration files for Lidarr. |
| `-v /music` | Music files. |
| `-v /downloads` | Path to your download folder for music. (DO NOT DELETE, this is a required path)|
| `-e downloadmethod=album` | SET TO: album or track :: album method will fallback to track method if it runs into an issue |
| `-e enablefallback=true` | true = enabled :: enables fallback to lower quality if required... |
| `-e VerifyTrackCount=true` | true = enabled :: This will verify album track count vs dl track count, if tracks are found missing, it will skip import... |
| `-e dlcheck=3` | Set the number to desired wait time before checking for completed downloads (if your connection is unstable, longer may be better) |
| `-e albumtimeoutpercentage=8` | Set the number between 1 and 100 :: This number is used to caculate album download timeout length by multiplying Album Length by ##% |
| `-e tracktimeoutpercentage=25` | Set the number between 1 and 100 :: This number is used to caculate  track download timeout length by multiplying Track Length by ##% |
| `-e amount=1000000000` | Maximum: 1000000000 :: Number of missing/cutoff albums to look for... |
| `-e quality=FLAC` | SET TO: FLAC or MP3 or OPUS or AAC or ALAC |
| `-e ConversionBitrate=320` | FLAC -> OPUS/AAC will be converted using this bitrate |
| `-e ReplaygainTagging=TRUE` | TRUE = ENABLED :: adds replaygain tags for compatible players (FLAC ONLY) |
| `-e FolderPermissions=777` | Based on chmod linux permissions |
| `-e FilePermissions=666` | Based on chmod linux permissions |
| `-e DownLoadArtistArtwork=false` | true = enabled :: Uses Lidarr Artist artwork first and fallsback to Deezer |


# LAD Information
* Script is scheduled to run every 15 minutes via a cron job
* Script files are stored in the following dirctories:
  * /config/scripts/
  * /config/scripts/00-lidarr-automated-downloader.exclusivelock/
    * Prevents multiple executions of script via cron
  * /config/scripts/lidarr-automated-downloader/
  * /config/scripts/lidarr-automated-downloader/cache/
    * Contains all cached album-lists to speed up results
* File explanations:
  * cron-job.log
    * Log of last attempt to execute
  * script-run.log
    * Current log of script run, can be seen in normal docker log
  * lidarr-automated-downloader-start.bash
    * Bash file that runs the script, executed automatically by cron job every 15 minutes
  * lidarr-automated-downloader.bash
    * LAD script, this file is updated on every container start from the github repo
  * config
    * File contains all configured settings from provided ENVIRONMENT variables, see [Parameters](https://github.com/RandomNinjaAtk/docker-lidarr-lad#parameters)
  * notfound.log
    * Log file containing list of albums that could not be found using normal or fuzzy matching, automatically cleared every Saturday via cron
  * musicbrainzerror.log
    * Log file containing list of artists without links, open log for more details
  * download.log
    * Log file containing list of albums that were downloaded, automatically cleared every Saturday via cron
 
# Lidarr Configuration Recommendations

## Media Management Settings:
* Disable Track Naming
  * Disabling track renaming enables synced lyrics that are imported as extras to be utilized by media players that support using them


#### Track Naming:

* Artist Folder: `{Artist Name}{ (Artist Disambiguation)}`
* Album Folder: `{Artist Name}{ - ALBUM TYPE}{ - Release Year} - {Album Title}{ ( Album Disambiguation)}`

#### Importing:
* Enable Import Extra Files
  * `lrc,jpg,png`

#### File Management
* Change File Date: Album Release Date
 
#### Permissions
* Enable Set Permissions
