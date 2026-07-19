Prepare remote hosts to use Ansible:
```
ansible-playbook --tags init playbook.yml
```

Install dotfiles on target hosts:
```
ansible-playbook playbook.yml
```
