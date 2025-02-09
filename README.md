# WireGuard DNS Re-Resolver

This repository contains systemd service and timer files to periodically re-resolve DNS for WireGuard interfaces using `reresolve-dns.sh` from WireGuard tools.

## Installation

To install the service and timer, run:

```sh
make install
```

This will:
- Clone or update the WireGuard tools repository.
- Install `wg-resrolve-dns.service` and `wg-resrolve-dns.timer` to `/etc/systemd/system/`.
- Install `reresolve-dns.sh` to `/usr/local/bin/`.
- Reload systemd if necessary.
- Enable and start the timer.

## Adjusting Timings

The execution interval of the DNS re-resolver is defined in `wg-resrolve-dns.timer` under the `[Timer]` section:

```ini
[Timer]
OnBootSec=300s
OnUnitActiveSec=60s
```

- `OnBootSec=300s` ensures the script runs 300 seconds after system boot.
- `OnUnitActiveSec=60s` schedules the script to run every 60 seconds after the last execution.

To change the interval, edit `wg-resrolve-dns.timer` and adjust these values. Then reload systemd:

```sh
sudo systemctl daemon-reload
sudo systemctl restart wg-resrolve-dns.timer
```

## Uninstallation

To remove the installed files, run:

```sh
make uninstall
```

This will:
- Remove the systemd service and timer files.
- Remove `reresolve-dns.sh` from `/usr/local/bin/`.
- Disable and stop the timer.

## Cleanup

To remove the cloned WireGuard tools repository, run:

```sh
make clean
```

