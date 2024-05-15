from ansible.plugins.inventory import (
    BaseInventoryPlugin,
    Constructable,
)

import csv

DOCUMENTATION = """
name: re_inventory_csv
plugin_type: inventory
short_description: CSV file inventory
description:
    - Use a CSV file as an inventory source
extends_documentation_fragment:
    - constructed
options:
    plugin:
        description: token that ensures this is a source file for the 'csv' plugin
        required: True
        choices: ['re_inventory_csv']
    compose:
        description: add an attribute to each host based on a conditional
        type: dict
    groups:
        description: build dynamic groups based on attribute
        type: dict
    keyed_groups:
        description: build dynamic groups based on csv columns
        type: list
    defaults:
        description: assign attributes to hosts when not in the CSV file
        type: dict
"""
EXAMPLES = """
## hosts.csv
    # Sample hosts csv file
    hostname,ip,mac,boot,apps,tags
    example-qmaster-1,10.10.10.1,11:11:11:11:11:11,disk,sge_qmaster,dns_server
    example-login-1,10.10.10.2,22:22:22:22:22:22,disk,sge_submit,
    example-compute-1,10.10.10.3,33:33:33:33:33:33,disk,sge_execution,

## hosts_csv.yml
    # Sample re_inventory_csv plugins
    plugin: re_inventory_csv
    source: "path/to/inventory.csv"

    # add an attribute to each host based on a conditional
    compose:
      fqdn: "hostname ~ domain"
    
    # build dynamic groups based on attribute
    groups:
      compute: "'-compute-' in hostname"
      login: "'-login-' in hostname"
    
    # build dynamic groups based on csv columns
    keyed_groups:
      - key: "hostname.split('-')[0] | lower"
        prefix: ""
        separator: ""
    
    # add an attribute to each host if it's not in the csv
    defaults:
      domain: ".example.com"
"""


class InventoryModule(BaseInventoryPlugin, Constructable):
    NAME = "re_inventory_csv"

    def verify_file(self, path):
        """ return true/false
        if this is possibly a valid file for this plugin to consume """
        valid = False
        if super(InventoryModule, self).verify_file(path):
            if path.endswith((
                    "re_inventory_csv.yaml",
                    "re_inventory_csv.yml"
            )):
                valid = True
        return valid

    def parse(self, inventory, loader, path, cache=True):
        super(InventoryModule, self).parse(inventory, loader, path, cache)

        config = self._read_config_data(path)
        strict = self.get_option("strict")

        with open(config["source"]) as csvfile:
            input_file = csv.DictReader(csvfile)
            for entry in input_file:
                host = entry["hostname"]
                hostvars = {}
                groups = []

                self.inventory.add_host(host)

                for k, v in entry.items():
                    if k not in ["apps", "tags"]:
                        hostvars[k] = v
                    if k in ["apps", "tags"]:
                        groups.extend(v.split())

                for group in groups:
                    self.inventory.add_group(group=group)
                    self.inventory.add_host(host=host, group=group)

                for k, v in config.get("defaults", {}).items():
                    if k not in hostvars:
                        hostvars[k] = v

                for k, v in hostvars.items():
                    self.inventory.set_variable(host, k, v)

                self._set_composite_vars(
                    self.get_option("compose"), hostvars, host, strict=strict
                )
                self._add_host_to_composed_groups(
                    self.get_option("groups"), hostvars, host, strict=strict
                )
                self._add_host_to_keyed_groups(
                    self.get_option("keyed_groups"),
                    hostvars,
                    host,
                    strict=strict,
                )
