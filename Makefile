PREFIX ?= /usr/local
SYSTEMD_DIR ?= /etc/systemd/system
WG_TOOLS_REPO = https://git.zx2c4.com/wireguard-tools
WG_TOOLS_DIR = wireguard-tools
SCRIPT_SRC = $(WG_TOOLS_DIR)/contrib/reresolve-dns/reresolve-dns.sh
SCRIPT_DEST = $(PREFIX)/bin/reresolve-dns.sh

all:
	@echo "Run 'make install' to install the service and script."

clone:
	@if [ -d "$(WG_TOOLS_DIR)/.git" ]; then \
		cd $(WG_TOOLS_DIR) && git pull; \
	else \
		git clone --depth=1 $(WG_TOOLS_REPO) $(WG_TOOLS_DIR); \
	fi

install: clone
	install -D -m644 -C wg-resrolve-dns.service $(SYSTEMD_DIR)/wg-resrolve-dns.service
	install -D -m644 -C wg-resrolve-dns.timer $(SYSTEMD_DIR)/wg-resrolve-dns.timer
	install -D -m755 -C $(SCRIPT_SRC) $(SCRIPT_DEST)
	@if [ -n "$(shell find $(SYSTEMD_DIR) -name 'wg-resrolve-dns.*' -newer /proc/uptime)" ]; then \
		systemctl daemon-reload; \
	fi
	@echo "Installation complete. Enable the timer with: sudo systemctl enable --now wg-resrolve-dns.timer"

uninstall:
	rm -f $(SYSTEMD_DIR)/wg-resrolve-dns.service
	rm -f $(SYSTEMD_DIR)/wg-resrolve-dns.timer
	rm -f $(SCRIPT_DEST)
	@echo "Uninstallation complete. Disable the timer with: sudo systemctl disable --now wg-resrolve-dns.timer"

clean:
	rm -rf $(WG_TOOLS_DIR)
	@echo "Cleanup complete."
