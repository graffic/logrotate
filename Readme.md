# Logrotate
[![Build Status](https://img.shields.io/travis/graffic/logrotate?style=flat)](https://travis-ci.org/graffic/logrotate)
[![Docker Pulls](https://img.shields.io/docker/pulls/graffic/logrotate?style=flat&color=blue)](https://hub.docker.com/r/graffic/logrotate)

Opinionated docker container that does logrotate. Designed as sidecar container for Kubernetes pods or stack containers that write logfiles but don't do rotation themselves.

## Considerations

- You most likely don't want to keep a ton of old log files in a running pod
- The purpose of this is solely to ensure logs don't fill up the disk - not long-term archival
- Instead, use a sidecar to `tail` the active log and let the K8S log collector handle the rest

## Usage

- Use shared volumes to share log files with a container that produces logfiles
- Set `LOGROTATE_PATTERN` etc. to configure what logrotate watches.
- Optionally set `LOGROTATE_OPTIONS` to modify how logs are rotated. The global logrotate file contains:
  ```
  rotate 36500
  compress
  su ${CURRENT_USER} ${CURRENT_USER}
  size 100M
  nocreate
  dateext
  dateformat .%Y-%m-%d-%H-%M-%S
  olddir archived
  createolddir 755 ${CURRENT_USER} ${CURRENT_USER}
  ```
- See [docker-compose.yaml](docker-compose.yaml) for a sample app

### Standalone

```sh
docker run -it --rm \
  --env CRON_SCHEDULE='* * * * *' \
  --env LOGROTATE_PATTERN=/myapp/logs/*.log \
  -v logs:/myapp/logs
  logrotate
```

### Docker Compose

- Starts a small sample app that writes a logfile and rotates it:

  ```sh
  docker-compose up --build
  ```

## Customization

Most options below are substituted into the config file for logrotate, so please refer to the
[Manpage for logrotate](https://linux.die.net/man/8/logrotate) for detailled documentation.

|Option|Default|Description|
|------|-------|-----------|
|`CRON_SCHEDULE`|`0 * * * *`|Cron schedule for logrotate command|
|`LOGROTATE_PATTERN`|`/logs/*.log`|Path pattern of log files to manage|
|`LOGROTATE_OPTIONS`| |Multiline configuration options for the pattern given|


## Alternatives

[blacklabelops/logrotate](https://github.com/blacklabelops/logrotate) allows more configuration
options but was not chosen on grounds of the images not being controlled by us and the sensitive
nature of logs.

## See Also

- [Manpage for logrotate](https://linux.die.net/man/8/logrotate)
- [Log handling in Kubernetes](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
