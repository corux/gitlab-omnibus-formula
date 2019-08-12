{% from "gitlab-omnibus/map.jinja" import gitlab with context %}

gitsshd-noselinux:
  file.managed:
    - name: /etc/systemd/system/gitsshd.service
    - source: salt://gitlab-omnibus/files/gitsshd.service.jinja
    - template: jinja

  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: gitsshd-noselinux

  service.running:
    - name: gitsshd
    - enable: True
    - require:
      - file: gitsshd-noselinux
      - file: gitsshd-config

gitsshd-config:
  file.managed:
    - name: /etc/ssh/gitsshd_config
    - template: jinja
    - source: salt://gitlab-omnibus/files/gitsshd_config
    - user: root
    - group: root
    - mode: 600
    - defaults:
        config: {{ gitlab.gitsshd|json }}