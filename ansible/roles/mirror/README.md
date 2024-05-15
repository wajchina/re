# mirror role
## Summary
Build mirror by sonatype/nexus3
## Variables
* nexus_image  
  nexus docker image
* nexus_version  
  nexus docker image version
* nexus_container  
  nexus docker container name
* nexus_port  
  nexus docker expose port
* path_for_re_raw_file  
  re raw file path
* local_mirror_server  
  local mirror server ip
## Other
### First step after initialization
When nexus-server were ready,open nexus web url:
1. Set your password step by step using initialize password
    ```
    user: admin
    password: /opt/nexus3/admin.password
    ```
2. Set HTTP proxy
    ```
       System -> HTTP
                      -> HTTP proxy  -> HTTP proxy host， HTTP proxy port
                      -> HTTPS proxy -> HTTPS proxy host，HTTPS proxy port
    ```
