# dns role
## Summary
Build Domain Nameserver
## Variables
* dns_zones  
  zone configuration
  ```yaml
    dns_zones:
      - name: local
        type: forward
        dns_zone_forwarders:
          - 192.168.1.140
          - 192.168.2.140
      - name: nfs1.example.private
        type: forward
        dns_zone_forwarders:
          - 192.168.1.1
  ```
* dns_allow_recursion  
  allowed recursion clients
* dns_options_allow_query  
  allowed query clients
## Other
