# dnsmasq.pp - configure a small dns resolver and dhcp server
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.


class dnsmasq {
	package { dnsmasq:
		ensure => installed,
		notify => Service[dnsmasq],
	}
	# TODO: configure per-firewall settings
	file { 
		"/etc/dnsmasq.d":
			ensure => directory, checksum => mtime,
			mode => 0755, owner => root, group => root,
			notify => Service[dnsmasq];
		"/etc/dnsmasq.d/puppet":
			content => template("dnsmasq/dnsmasq.conf"),
			mode => 0644, owner => root, group => root,
			notify => Service[dnsmasq];
	}
	line {
		dir_include:
			file => "/etc/dnsmasq.conf",
			line => "conf-dir=/etc/dnsmasq.d",
			require => File["/etc/dnsmasq.conf"],
			notify => Service[dnsmasq],
	}

	file { "/etc/dnsmasq.conf": checksum => md5, require => Package["dnsmasq"] }
	service { dnsmasq:
		ensure => running,
		enable => true,
		pattern => "/usr/sbin/dnsmasq",
		subscribe => [ File["/etc/dnsmasq.conf"], File["/etc/hosts"] ]
	}
}
