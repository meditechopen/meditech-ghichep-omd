## Thư mục lưu trữ các metric của các host khi thu thập

- CACHE:

```
/opt/omd/sites/site1/tmp/check_mk/cache
```

- Kết quả lưu trữ các lượt Check trong ngày:

```
/opt/omd/sites/site1/var/nagios/nagios.log
```

- Cấu hình lưu log cho Nagios:

```
/opt/omd/sites/site1/etc/nagios/nagios.d/logging.cfg
```

Toàn bộ file có nội dung như sau:

```
# OMD default settings.

# Please do not change settings here. Copy the variables
# you want to override to ../nagios.cfg and edit them there.
# Settings in nagios.cfg have always precedence.

# Log and debug configuration

# LOG ROTATION METHOD
# This is the log rotation method that Nagios should use to rotate
# the main log file. Values are as follows..
#       n       = None - don't rotate the log
#       h       = Hourly rotation (top of the hour)
#       d       = Daily rotation (midnight every day)
#       w       = Weekly rotation (midnight on Saturday evening)
#       m       = Monthly rotation (midnight last day of month)

log_rotation_method=d

# LOGGING OPTIONS
# If you want messages logged to the syslog facility, as well as the
# Nagios log file set this option to 1.  If not, set it to 0.

use_syslog=0

# NOTIFICATION LOGGING OPTION
# If you don't want notifications to be logged, set this value to 0.
# If notifications should be logged, set the value to 1.

log_notifications=1

# SERVICE RETRY LOGGING OPTION
# If you don't want service check retries to be logged, set this value
# to 0.  If retries should be logged, set the value to 1.

log_service_retries=1

# HOST RETRY LOGGING OPTION
# If you don't want host check retries to be logged, set this value to
# 0.  If retries should be logged, set the value to 1.

log_host_retries=1

# EVENT HANDLER LOGGING OPTION
# If you don't want host and service event handlers to be logged, set
# this value to 0.  If event handlers should be logged, set the value
# to 1.

log_event_handlers=1

# INITIAL STATES LOGGING OPTION
# If you want Nagios to log all initial host and service states to
# the main log file (the first time the service or host is checked)
# you can enable this option by setting this value to 1.  If you
# are not using an external application that does long term state
# statistics reporting, you do not need to enable this option.  In
# this case, set the value to 0.

log_initial_states=1

# EXTERNAL COMMANDS LOGGING OPTION
# If you don't want Nagios to log external commands, set this value
# to 0.  If external commands should be logged, set this value to 1.
# Note: This option does not include logging of passive service
# checks - see the option below for controlling whether or not
# passive checks are logged.

log_external_commands=0

# PASSIVE CHECKS LOGGING OPTION
# If you don't want Nagios to log passive host and service checks, set
# this value to 0.  If passive checks should be logged, set
# this value to 1.

log_passive_checks=0

# DEBUG LEVEL
# This option determines how much (if any) debugging information will
# be written to the debug file.  OR values together to log multiple
# types of information.
# Values: 
#          -1 = Everything
#          0 = Nothing
#          1 = Functions
#          2 = Configuration
#          4 = Process information
#          8 = Scheduled events
#          16 = Host/service checks
#          32 = Notifications
#          64 = Event broker
#          128 = External commands
#          256 = Commands
#          512 = Scheduled downtime
#          1024 = Comments
#          2048 = Macros

debug_level=0

# DEBUG VERBOSITY
# This option determines how verbose the debug log out will be.
# Values: 0 = Brief output
#         1 = More detailed
#         2 = Very detailed

debug_verbosity=0

# MAX DEBUG FILE SIZE
# This option determines the maximum size (in bytes) of the debug file.  If
# the file grows larger than this size, it will be renamed with a .old
# extension.  If a file already exists with a .old extension it will
# automatically be deleted.  This helps ensure your disk space usage doesn't
# get out of control when debugging Nagios.

max_debug_file_size=1000000

# DAEMON CORE DUMP OPTION
# This option determines whether or not Nagios is allowed to create
# a core dump when it runs as a daemon.  Note that it is generally
# considered bad form to allow this, but it may be useful for
# debugging purposes.  Enabling this option doesn't guarantee that
# a core file will be produced, but that's just life...
# Values: 1 - Allow core dumps
#         0 - Do not allow core dumps (default)

daemon_dumps_core=0
```

- Lưu trữ:

```
/opt/omd/sites/site1/var/nagios/archive
```

- https://mathias-kettner.de/checkmk_omd.html

## Xem lại kết quả trên Dashboard

**Views > Others > Host and Service Events**

<img src="/images/ghinhap1.png" />

Ví dụ, xem lại kết quả ngày 20/9/2017


## Tự động phát hiện dịch vụ mới và xóa bỏ dịch vụ bị lỗi

**WATO > Host & Service Parameters > Monitoring Configuration > Inventory and Check_MK settings > Periodic service discovery**

<img src="/images/auto-update-services.png" />

## Lệnh check_mk

```
WAYS TO CALL:
 cmk [-n] [-v] [-p] HOST [IPADDRESS]  check all services on HOST
 cmk -I [HOST ..]                     inventory - find new services
 cmk -II ...                          renew inventory, drop old services
 cmk -N [HOSTS...]                    output Nagios configuration
 cmk -B                               create configuration for core
 cmk -C, --compile                    precompile host checks
 cmk -U, --update                     precompile + create config for core
 cmk -O, --reload                     precompile + config + core reload
 cmk -R, --restart                    precompile + config + core restart
 cmk -D, --dump [H1 H2 ..]            dump all or some hosts
 cmk -d HOSTNAME|IPADDRESS            show raw information from agent
 cmk --check-discovery HOSTNAME       check for items not yet checked
 cmk --discover-marked-hosts          run discovery for hosts known to have changed services
 cmk --update-dns-cache               update IP address lookup cache
 cmk -l, --list-hosts [G1 G2 ...]     print list of all hosts
 cmk --list-tag TAG1 TAG2 ...         list hosts having certain tags
 cmk -L, --list-checks                list all available check types
 cmk -M, --man [CHECKTYPE]            show manpage for check CHECKTYPE
 cmk -m, --browse-man                 open interactive manpage browser
 cmk --paths                          list all pathnames and directories
 cmk -X, --check-config               check configuration for invalid vars
 cmk --backup BACKUPFILE.tar.gz       make backup of configuration and data
 cmk --restore BACKUPFILE.tar.gz      restore configuration and data
 cmk --flush [HOST1 HOST2...]         flush all data of some or all hosts
 cmk --donate                         Email data of configured hosts to MK
 cmk --snmpwalk HOST1 HOST2 ...       Do snmpwalk on one or more hosts
 cmk --snmptranslate HOST             Do snmptranslate on walk
 cmk --snmpget OID HOST1 HOST2 ...    Fetch single OIDs and output them
 cmk --scan-parents [HOST1 HOST2...]  autoscan parents, create conf.d/parents.mk
 cmk -P, --package COMMAND            do package operations
 cmk --localize COMMAND               do localization operations
 cmk --notify                         used to send notifications from core
 cmk --create-rrd [--keepalive|SPEC]  create round robin database (only CEE)
 cmk --convert-rrds [--split] [H...]  convert exiting RRD to new format (only CEE)
 cmk --compress-history FILES...      optimize monitoring history files for CMC
 cmk --handle-alerts                  alert handling, always in keepalive mode (only CEE)
 cmk --real-time-checks               process real time check results (only CEE)
 cmk -i, --inventory [HOST1 HOST2...] Do a HW/SW-Inventory of some ar all hosts
 cmk --inventory-as-check HOST        Do HW/SW-Inventory, behave like check plugin
 cmk -A, --bake-agents [-f] [H1 H2..] Bake agents for hosts (not in all versions)
 cmk --cap pack|unpack|list FILE.cap  Pack/unpack agent packages (not in all versions)
 cmk --show-snmp-stats                Analyzes recorded Inline SNMP statistics
 cmk -V, --version                    print version
 cmk -h, --help                       print this help

OPTIONS:
  -v             show what's going on
  -p             also show performance data (use with -v)
  -n             do not submit results to core, do not save counters
  -c FILE        read config file FILE instead of /omd/sites/site1/etc/check_mk/main.mk
  --cache        read info from cache file is present and fresh, use TCP
                 only, if cache file is absent or too old
  --no-cache     never use cached information
  --no-tcp       for -I: only use cache files. Skip hosts without
                 cache files.
  --fake-dns IP  fake IP addresses of all hosts to be IP. This
                 prevents DNS lookups.
  --usewalk      use snmpwalk stored with --snmpwalk
  --debug        never catch Python exceptions
  --interactive  Some errors are only reported in interactive mode, i.e. if stdout
                 is a TTY. This option forces interactive mode even if the output
                 is directed into a pipe or file.
  --procs N      start up to N processes in parallel during --scan-parents
  --checks A,..  restrict checks/inventory to specified checks (tcp/snmp/check type)
  --keepalive    used by Check_MK Mirco Core: run check and --notify
                 in continous mode. Read data from stdin and from cmd line.
  --cmc-file=X   relative filename for CMC config file (used by -B/-U)
  --extraoid A   Do --snmpwalk also on this OID, in addition to mib-2 and enterprises.
                 You can specify this option multiple times.
  --oid A        Do --snmpwalk on this OID instead of mib-2 and enterprises.
                 You can specify this option multiple times.
  --hw-changes=S --inventory-as-check: Use monitoring state S for HW changes
  --sw-changes=S --inventory-as-check: Use monitoring state S for SW changes
  --inv-fail-status=S Use monitoring state S in case if error during inventory

NOTES:
  -I can be restricted to certain check types. Write '--checks df -I' if you
  just want to look for new filesystems. Use 'check_mk -L' for a list
  of all check types. Use 'tcp' for all TCP based checks and 'snmp' for
  all SNMP based checks.

  -II does the same as -I but deletes all existing checks of the
  specified types and hosts.

  -N outputs the Nagios configuration. You may optionally add a list
  of hosts. In that case the configuration is generated only for
  that hosts (useful for debugging).

  -U redirects both the output of -S and -H to the file /omd/sites/site1/var/check_mk/precompiled
  and also calls check_mk -C.

  -D, --dump dumps out the complete configuration and information
  about one, several or all hosts. It shows all services, hostgroups,
  contacts and other information about that host.

  -d does not work on clusters (such defined in main.mk) but only on
  real hosts.

  --check-discovery make check_mk behave as monitoring plugins that
  checks if an inventory would find new or vanished services for the host.
  If configured to do so, this will queue those hosts for automatic
  discover-marked-hosts

  --discover-marked-hosts run actual service discovery on all hosts that
  are known to have new/vanished services due to an earlier run of
  check-discovery. The results of this discovery may be activated
  automatically if that was discovered.

  --list-hosts called without argument lists all hosts. You may
  specify one or more host groups to restrict the output to hosts
  that are in at least one of those groups.

  --list-tag prints all hosts that have all of the specified tags
  at once.

  -M, --man shows documentation about a check type. If
  /usr/bin/less is available it is used as pager. Exit by pressing
  Q. Use -M without an argument to show a list of all manual pages.

  --backup saves all configuration and runtime data to a gzip
  compressed tar file. --restore *erases* the current configuration
  and data and replaces it with that from the backup file.

  --flush deletes all runtime data belonging to a host. This includes
  the inventorized checks, the state of performance counters,
  cached agent output, and logfiles. Precompiled host checks
  are not deleted.

  -P, --package brings you into packager mode. Packages are
  used to ship inofficial extensions of Check_MK. Call without
  arguments for a help on packaging.

  --localize brings you into localization mode. You can create
  and/or improve the localization of Check_MKs Multisite.  Call without
  arguments for a help on localization.

  --donate is for those who decided to help the Check_MK project
  by donating live host data. It tars the cached agent data of
  those host which are configured in main.mk:donation_hosts and sends
  them via email to donatehosts@mathias-kettner.de. The host data
  is then publicly available for others and can be used for setting
  up demo sites, implementing checks and so on.
  Do this only with test data from test hosts - not with productive
  data! By donating real-live host data you help others trying out
  Check_MK and developing checks by donating hosts. This is completely
  voluntary and turned off by default.

  --snmpwalk does a complete snmpwalk for the specified hosts both
  on the standard MIB and the enterprises MIB and stores the
  result in the directory /omd/sites/site1/var/check_mk/snmpwalks. Use the option --oid one or several
  times in order to specify alternative OIDs to walk. You need to
  specify numeric OIDs. If you want to keep the two standard OIDS
  .1.3.6.1.2.1  and .1.3.6.1.4.1 then use --extraoid for just adding
  additional OIDs to walk.

  --snmptranslate does not contact the host again, but reuses the hosts
  walk from the directory /omd/sites/site1/var/check_mk/snmpwalks.
  You can add further MIBs to /omd/sites/site1/local/share/check_mk/mibs

  --scan-parents uses traceroute in order to automatically detect
  hosts's parents. It creates the file conf.d/parents.mk which
  defines gateway hosts and parent declarations.

  -A, --bake-agents creates RPM/DEB/MSI packages with host-specific
  monitoring agents. If you add the option -f, --force then all
  agents are renewed, even if an uptodate version for a configuration
  already exists. Note: baking agents is only contained in the
  subscription version of Check_MK.

  --show-snmp-stats analyzes and shows a summary of the Inline SNMP
  statistics which might have been recorded on your system before.
  Note: This is only contained in the subscription version of Check_MK.

  --convert-rrds converts the internal structure of existing RRDs
  to the new structure as configured via the rulesets cmc_host_rrd_config
  and cmc_service_rrd_config. If you do not specify hosts, then all
  RRDs will be converted. Conversion just takes place if the configuration
  of the RRDs has changed. The option --split will activate conversion
  from exising RRDs in PNP storage type SINGLE to MULTIPLE.

  -i, --inventory does a HW/SW-Inventory for all, one or several
  hosts. If you add the option -f, --force then persisted sections
  will be used even if they are outdated.

```