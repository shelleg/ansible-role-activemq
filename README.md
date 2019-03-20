ActiveMQ Ansible Role  
=====================

Installs ActiveMQ

Build Status:
-------------
Currently only supports Ansible lint, need to add distributions (work started in `.travis.yml`)

[![Build Status](https://travis-ci.org/shelleg/ansible-role-activemq.svg?branch=master)](https://travis-ci.org/shelleg/ansible-role-activemq)

[![Code Climate](https://codeclimate.com/github/shelleg/ansible-role-activemq/badges/gpa.svg)](https://codeclimate.com/github/shelleg/ansible-role-activemq) [![Issue Count](https://codeclimate.com/github/shelleg/ansible-role-activemq/badges/issue_count.svg)](https://codeclimate.com/github/shelleg/ansible-role-activemq) [![Test Coverage](https://codeclimate.com/github/shelleg/ansible-role-activemq/badges/coverage.svg)](https://codeclimate.com/github/shelleg/ansible-role-activemq/coverage)

Requirements
------------
JAVA (i.e. openjdk 1.8 jre)

Role Variables
--------------
Default installation mode for Rhel/Centos:

* `amq_install_mode: tarball`

User & Group activemq runs under:
* `amq_user:   activemq`
* `amq_group:  activemq`
* `amq_home_dir:  /var/lib/{{ amq_user }}`
* `amq_log_dir: /var/log/{{ amq_user }}`

Installation directory:
* `amq_install_dir: /opt`
* `amq_run_dir: "{{ amq_install_dir }}/{{ amq_user }}"`

ActiveMQ configuration:
* `amq_conf_dir: "{{ amq_install_dir }}/activemq/conf"`

Default version:
* `amq_version_major: "5"`
* `amq_version_minor: "15"`
* `amq_version_patch: "8"`
* `amq_version: "{{ amq_version_major }}.{{ amq_version_minor }}.{{amq_version_patch }}"`

Download url - this can be overwritten with your corporate url prefix:
* `amq_url_prefix: "http://archive.apache.org/dist/activemq/"`
* `amq_url: "{{ amq_url_prefix }}/{{ amq_version }}/apache-activemq-{{amq_version }}-bin.tar.gz"`

Environment vars : you can override or add new environment variables. These variables are used loaded by systemd service file
```
amq_env_vars:
  ACTIVEMQ_USER: "{{ amq_user }}"
  ACTIVEMQ_BASE: "{{ amq_run_dir }}"
```

Custrom broker xml config template
* `amq_custom_xml_config: True`
* `amq_custom_xml_config_path: "activemq.xml.j2"`

Custom log4j.properties template
* `amq_custom_log4j_config: True`
* `amq_custom_log4j_config_path: "log4j.properties.j2"`

activemq.xml.j2 template variables
* `amq_broker_name: "{{ ansible_hostname }}"`
* `amq_admin_user: admin`
* `amq_admin_password: "{{ amq_admin_user }}"`
* `amq_authentication: false`

transport connectors in the activemq.xml.j2 template
* `amq_openwire_transport_connector_uri: "tcp://0.0.0.0:61616?maximumConnections=1000&amp;wireformat.maxFrameSize=104857600"`
* `amq_amqp_transport_connector_uri: "amqp://0.0.0.0:5672?maximumConnections=1000&amp;wireformat.maxFrameSize=104857600"`
* `amq_stomp_transport_connector_uri: "stomp://0.0.0.0:61713?transport.closeAsync=false"`
* `amq_stomp_and_nio_transport_connector_uri: "stomp+nio://0.0.0.0:61712?transport.closeAsync=false"`

active transport connectors in the activemq.xml.j2 template:
```
amq_transport_connectors:
   openwire: "{{ amq_openwire_transport_connector_uri }}"
   amqp : "{{ amq_amqp_transport_connector_uri }}"
   stomp : "{{ amq_stomp_transport_connector_uri }}"
   "stomp+nio" : "{{ amq_stomp_and_nio_transport_connector_uri }}"
```
Dependencies
------------
Requires Java in order to run.
Personally I do not believe in depedencies from meta/main.yml
considering this looks too much like black magic ...

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

Simple playbook:

``` shell

---
- hosts: localhost
  remote_user: root
  roles:
    - java
    - ansible-role-activemq
```

Little more advanced:

``` shell
---
- hosts: all
  become: yes
  vars:
    java_packages: java-1.8.0-openjdk
    amq_user: activemq
    amq_version_major: "5"
    amq_version_minor: "15"
    amq_version_patch: "8"

    amq_env_vars:
       ACTIVEMQ_PROCESS: "activemq"
       ACTIVEMQ_OPTS: "-Djava.net.preferIPv4Stack=true"
       ACTIVEMQ_OPTS_MEMORY: "-Xms512m -Xmx512m"
       ACTIVEMQ_PIDDIR: "/var/run/activemq"
       ACTIVEMQ_PIDFILE: "${ACTIVEMQ_PIDDIR}/activemq.pid"

    # just 1 connector not all defaults....
    amq_transport_connectors:
       openwire: "{{ amq_openwire_transport_connector_uri }}"


  tasks:
    - name: java
      include_role:
        name: geerlingguy.java

    - name: ActiveMQ
      include_role:
        name: activemq
        public: yes
    - debug:
        var: amq_run_dir
```
Changelog:
----------

* initial release - initial release support ubutnu 14/16.04 && centos 6/7
* [v1.0.0](https://github.com/shelleg/ansible-role-activemq/releases)          - Add support for systemd in centos7
* [v1.0.1](https://github.com/shelleg/ansible-role-activemq/releases)          - Add support for centos6 (no systemd)
* [vx.x.x]
 - renamed variables starting with activemq_ to amq_ to be more consistent with previous version(s)
 - changed activemq_instance_name to amq_broker_name to be more consistent with the .xml file.
 - added a custom log4j.properties template
 - added default username/password to activemq broker config
 - changed the build up of the amq_transport connectors in the activemq.xml.j2 template to be more flexible
 - bumped default versdion to 5.15.8
 - added custom log4j.properties


License
-------

[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

Author Information
------------------

Haggai Philip Zagury <hagzag@tikalk.com> part of
[Shellg](https://github.com/shelleg/shelleg) project.
see also [Shellg Docs](http://shelleg.github.io/shellegDoc/)
