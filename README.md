ActiveMQ Ansible Role  
=====================

Installs ActiveMQ 

Build Status:
-------------
Currently only supports Ansible lint, need to add distributions (work started in `.travis.yml`)

[![Build Status](https://travis-ci.org/shelleg/ansible-role-activemq.svg?branch=master)](https://travis-ci.org/shelleg/ansible-role-activemq)

Requirements
------------
JAVA Oracle

Role Variables
--------------
Default installation mode for Rhel/Centos
amq_install_mode: tarball

User & Group activemq runs under:
amq_user:   activemq
amq_group:  activemq
amq_home_dir:  /var/lib/activemq
amq_log_dir: /var/log/activemq

Installation directory:
amq_install_dir: /opt
amq_run_dir: "/opt/{{ amq_user }}"

Default version:
amq_version_major: "5"
amq_version_minor: "13"
amq_version_patch: "3"
amq_version: "{{ amq_version_major }}.{{ amq_version_minor }}.{{
amq_version_patch }}"

Download url - this can be overwritten with your corporate url prefix:
amq_url_prefix: "http://archive.apache.org/dist/activemq/"
amq_url: "{{ amq_url_prefix }}/{{ amq_version }}/apache-activemq-{{
amq_version }}-bin.tar.gz"


Dependencies
------------
Requires Java in order to run.
Personally I do not believe in depedencies from meta/main.yml
considering this looks too much like black magic ...

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:
``` shell

---
- hosts: localhost
  remote_user: root
  roles:
    - java
    - ansible-role-activemq
```

License
-------

GPLv3

Author Information
------------------

Haggai Philip Zagury <hagzag@tikalk.com> part of
[Shellg](https://github.com/shelleg/shelleg) project.
see also [Shellg Docs](http://shelleg.github.io/shellegDoc/)
