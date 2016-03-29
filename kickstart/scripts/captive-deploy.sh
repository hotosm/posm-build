#!/bin/bash

deploy_captive_ubuntu() {
  expand etc/dnsmasq-captive.conf "/etc/dnsmasq.d/99-captive.conf"

  apt-get install --no-install-recommends -y nginx
  expand etc/nginx-captive.conf /etc/nginx/sites-available/captive
  rm -f /etc/nginx/sites-enabled/default
  ln -s -f ../sites-available/captive /etc/nginx/sites-enabled/

  # disable port forwarding
  test -f /etc/network/if-down.d/disable_port_forwarding && IFACE=$posm_wan_netif /etc/network/if-down.d/disable_port_forwarding

  # remove hook scripts
  rm -f /etc/network/if-up.d/enable_port_forwarding
  rm -f /etc/network/if-down.d/disable_port_forwarding

  service dnsmasq restart
  service nginx restart
}

deploy captive
