# sge role
## Summary
SGE installation
## Variables
* sge_root  
  sge path, defaults `/opt/gridengine`
* sge_qmaster_port  
  sge qmaster port, defaults `6444`
* sge_execd_port  
  sge execd port, defaults `6445`
* sge_cluster_name  
  sge cluster name, defaults ``re-{{ REGION }}``
* cell_name  
  sge cell name, defaults `default`
* admin_user  
  sge admin username, defaults `sge`
* gid_range  
  sge GID-Range, defaults `20000-20200`
* **sge_master_hostname**  
  sge qmaster hostname, defaults `localhost`   
  important! sge_submit/sge_execution should set to head node
