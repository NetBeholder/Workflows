# Ansible playbook dedicated for configuring some typical basic OS settings (for RHEL-based like Rocky Linux):

## run playbook
```
ansible-playbook PrepareServer.yml --ask-vault-pass --extra-vars '@passwd.yaml' -vv
```

## Steps:

1. Add EPEL, both free and nonfree RPMfusion repos
2. Create user for remote management with key-based authentication
3. Set hostname and FQDN
4. Time settings (NTP Servers, timezone)
5. Regional settings (locale - en, but some LC_x vars can be defined for specific language in bashrc)
6. Network settings for main interface (static IPv4, mask, gw, DNS servers and search domains)
7. Loopback interface optionally can be set to managed by NetworkManager (and, as a result, by firewalld service too))
8. Install some packages:
- bash-completion
- curl
- wget
- htop
- git
- pwgen
- httpd-tools
- neovim
- nano
- bind-utils
- dnf-utils
- cifs-utils
- mtr
- psmisc
- mc
- tar
- unrar
- stow
- exa
- bat
- lf (no package is in repos: download to /opt/lf from github.com)

## List of defined vars (inventory, --extra-vars file).
See hosts.yml.example and passwd.yaml.example.
All sensitive data must be protected in production:
```Yaml
#for ssh connection with ansible-playbook. root was disabled during OS installation
ansible_user: rocky-admin
ansible_ssh_pass: P@ssw0rd
ansible_sudo_pass: P@ssw0rd

# user will be created for remote management
AnsibleUserName: rocky-ansible
AnsibleUserName_passwd: Pa$$w0rd

hostname: rocky9-srv
host_fqdn: rocky9-srv.ipa.lol-kek.lol

regional_settings: "ru"

ntp_servers:
  - '0.ru.pool.ntp.org iburst'
  - 1.ru.pool.ntp.org
  - 2.ru.pool.ntp.org
  - 3.ru.pool.ntp.org

timezone: "Europe/Moscow"

dns_servers:
  - 10.200.200.20
  - 10.200.200.21
search_lists:
  - ipa.lol-kek.lol
  - ad.lol-kek.lol
  - lol-kek.lol
```
