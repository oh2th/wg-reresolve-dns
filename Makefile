PREFIX ?= /usr/local
SYSTEMD_DIR ?= /etc/systemd/system
WG_TOOLS_REPO = https://git.zx2c4.com/wireguard-tools
WG_TOOLS_DIR = wireguard-tools
SCRIPT_SRC = $(WG_TOOLS_DIR)/contrib/reresolve-dns/reresolve-dns.sh
SCRIPT_DEST = $(PREFIX)/bin/reresolve-dns.sh

all:
	@echo "Run 'make install' to install the service and script."

clone:
	git clone --depth=1 $(WG_TOOLS_REPO) $(WG_TOOLS_DIR) || (cd $(WG_TOOLS_DIR) && git pull)

install: clone
	install -Dm644 wg-resrolve-dns.service $(SYSTEMD_DIR)/wg-resrolve-dns.service
	install -Dm644 wg-resrolve-dns.timer $(SYSTEMD_DIR)/wg-resrolve-dns.timer
	install -Dm755 $(SCRIPT_SRC) $(SCRIPT_DEST)
	@echo "Installation complete. Enable the timer with: sudo systemctl enable --now wg-resrolve-dns.timer"

uninstall:
	rm -f $(SYSTEMD_DIR)/wg-resrolve-dns.service
	rm -f $(SYSTEMD_DIR)/wg-resrolve-dns.timer
	rm -f $(SCRIPT_DEST)
	@echo "Uninstallation complete. Disable the timer with: sudo systemctl disable --now wg-resrolve-dns.timer"

clean:
	rm -rf $(WG_TOOLS_DIR)
	@echo "Cleanup complete."
