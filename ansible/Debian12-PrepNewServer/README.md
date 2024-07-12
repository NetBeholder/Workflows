# Ansible playbook dedicated for configuring some typical basic OS settings (for RHEL-based like Rocky Linux):

## Settings:

1. Create users from both SystemUsers and NormalUsers lists of general_settings['Users'] with ed25519 keys and some LC_x settings.
2. Configure network settings:
    1. Fullfill /etc/network/interfaces from net_config['interfaces']
    2. DNS-related settings from net_config['DNS'] and net_config['Names']
    3. Time settings from general_settings['Time']
3. Install locales from general_settings['RegionalSettings']['Locales']
4. Install some packages:
    - sudo
    - resolvconf
    - git
    - curl
    - htop
    - pwgen
    - neovim
    - lf
    - bind9-dnsutils
    - debian-goodies
    - cifs-utils
    - samba-client
    - psmisc
    - tree
## List of defined vars
Settings are grouped into blocks and can be skipped using flags.
```yaml
    flags:
      create_system_users_flag: true
      create_normal_users_flag: true
      configure_dns_settings_flag: true
      configure_time_settings_flag: true
      configure_system_locales_flag: true
```
Both net_config['interfaces'] and net_config['DNS'] contains data for setting up network interfaces, DNS, hostname. The number of interfaces is limited only by common sense and the OS usage scenario. There should be only one gateway.
```yaml
    net_config:
      interfaces:
        # any combination
        - name: enp2s0
          ip_settings: auto
        - name: enp3s0
          ip_settings:
            address: 192.168.16.100/24
            gateway: 192.168.16.1
            # not used
                    #dns-nameserver:
                    #  - 8.8.8.8
                    #  - 8.8.4.4
                    #dns-search:
                    #  - lol-kek.lol
        - name: enp4s0
          ip_settings:
            address: 192.168.17.100/24
      DNS:
        Servers:
          - 8.8.8.8
          - 8.8.4.4
        # Search:
        #          - lol-kek.lol
        #          - example.com
        Names:
          hostname: debsrv
          domain: lol-kek.lol
```

general_settings['Time'] used for configuring NTP settings of host and includes time zone info, hwclock and sources
```yaml
    general_settings:
      Time:
        TZ: "Europe/Moscow"
        hwclock: "UTC" # local|UTC
        sources:
          - 0.ru.pool.ntp.org
          - 1.ru.pool.ntp.org
          - 2.ru.pool.ntp.org
          - 3.ru.pool.ntp.org
```

general_settings['RegionalSettings'] contains info about system locales and lc params for created users.
```yaml
      RegionalSettings:
        Locales:
          - ru_RU.UTF-8
          - en_US.UTF-8
        lc:
          us:
            lc_params:
              - export LC_ALL=en_US.UTF8
          ru:
            lc_params:
              - export LC_TIME="ru_RU.UTF8"
              - '#export LC_LANG="ru_RU.UTF-8"'
              - '#export LC_CTYPE="ru_RU.UTF-8"'
              - export LC_NUMERIC="ru_RU.UTF-8"
              - export LC_TIME=ru_RU.UTF8
              - export LC_COLLATE="ru_RU.UTF-8"
              - export LC_MONETARY="ru_RU.UTF-8"
              - '#export LC_MESSAGES="ru_RU.UTF-8"'
              - export LC_PAPER="ru_RU.UTF-8"
              - export LC_NAME="ru_RU.UTF-8"
              - export LC_ADDRESS="ru_RU.UTF-8"
              - export LC_TELEPHONE="ru_RU.UTF-8"
              - export LC_MEASUREMENT="ru_RU.UTF-8"
              - export LC_IDENTIFICATION="ru_RU.UTF-8"
              - '#export LC_ALL='
```

general_settings[Users] contains 2 lists of created users - Users['SystemUsers'] and Users['NormalUsers'].
The first list is for all entities that cannot be considered living people (monitoring agents, user for Ansible connection, etc.)
The second list, in turn, is intended for creating user accounts.

```yaml
      Users:
        SystemUsers:
          - name: automata
            password: P@ssw0rd
            groups: sudo
            #shell: /sbin/nologin
            #shell: /bin/bash
            create_home: true
        NormalUsers:
          - name: petya
            lc: us
            groups: sudo
          - name: vasya
            lc: ru
            groups: sudo
```

All sensitive data *should be* protected in production. Please remember to use [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html) for passwords. The examples here are not using vault for better readability.:

## Run playbook

```
ansible-playbook PrepareServer.yml --ask-vault-pass --extra-vars '@passwd.yaml' -vv
```
The playbook can be executed multiple times against the same nodes. Perhaps someday I hope it will be completely idempotent
