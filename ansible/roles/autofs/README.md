# autofs role
## Summary
Autofs configuration
- /etc/auto.master.d/00-{mount-point}.autofs
- /etc/auto.{mount-point}
## Variables
* slash_replace_char  
  character used to replace `/`, defaults:`-`
* nis_master_map   
  Include central master map if it can be found using nsswitch sources，default:auto.master
* autofs_maps
  + mountpoint  
    mount point, eg.`/nfs1`
  + options  
    mount options, eg.`--timeout=1200`
  + name  
    config file name, eg.`nfs1`
  + state  
    map state, eg.`state: absent`
  + directories
    - path  
      directory name, eg`*`or`pub`
    - options  
      options, eg. `rw`,`soft`
    - server  
      NFS server path，eg.`nfs1.example.private:/nfs1/&`
## Other
### reference
* https://linux.die.net/man/5/nfs
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-nfs
