# ganglia role
## Summary
ganglia monitor
## Variables
* ganglia_config_web  
  Allow ip to access ganglia web
  ```
    allow:
      - ip: 127.0.0.1
        mask: 32
      - ip: 10.0.0.0
        mask: 8
  ```
* is_gmetad_server  
  True, gmetad server role
* is_gmond_proxy  
  True, gmond server role
* gmetad_server_hostname  
  gmetad server hostname，used for iface.pyconf getting ethernet card
* gmetad settings 
  gmetad(Ganglia Meta Daemon) that collects and aggregates metrics data collected by gmond
  - ganglia_config_gmetad
    ```yaml
    ganglia_config_gmetad:
      grid_name: grid_{{ REGION }} #GRID name,include multiple data sources 
      data_sources:
        'sge-master':
          servers:
            - 'demo-head-1:8649' 
        'sge-login':
          servers:
            - 'demo-login-1:8661'
        'sge-compute':
          servers:
            - 'demo-compute-0-1:8662'
    ```
* gmond settings 
  gmond(Ganglia Monitoring Daemon) that collects and sends indicators
  - ganglia_config_gmond
    ```yaml
    ganglia_config_gmond:
      data_sources:
        name: 'sge-compute'
        port: 8662
        servers:
          - 'demo-compute-0-1' 
      globals:
        mute: 'no' #If yes, gmond will not send any data and needs to be set to no to send data
        deaf: 'yes' #If yes, gmond will not receive any data and will need to set the gmond proxy server to no
        host_dmax: 432000 #gmond will refresh the host if host_dmax does not receive a host message within seconds
        acl_allow:
          - ip: 127.0.0.1
            mask: 32
          - ip: 10.0.0.0
            mask: 8
    ```
