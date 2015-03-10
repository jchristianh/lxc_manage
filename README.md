lxc_manage Cookbook
===================
TODO: Lots


Requirements
------------
There are no outside requirements for this cookbook. You will only need a host
capable of utilizing LXC (Linux Containers)

e.g.
#### packages
- `lxc` - Linux Resource Containers
- `lxc-templates` - Templates for lxc

Attributes
----------
#### lxc_manage::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Optional</th>
  </tr>
  <tr>
    <td><tt>['lxc_container']['node']['NODE_NAME']['type']</tt></td>
    <td>String</td>
    <td>Name of LXC template</td>
    <td><tt>Required</tt></td>
  </tr>
  <tr>
    <td><tt>['lxc_container']['node']['NODE_NAME']['active']</tt></td>
    <td>Boolean</td>
    <td>Whether to create/destroy the node</td>
    <td><tt>Required</tt></td>
  </tr>
  <tr>
    <td><tt>['lxc_container']['node']['NODE_NAME']['run']</tt></td>
    <td>Boolean</td>
    <td>Whether to run or stop the node; Needs to be created first</td>
    <td><tt>Required</tt></td>
  </tr>
  <tr>
    <td><tt>['lxc_container']['node']['NODE_NAME']['lxc_version']</tt></td>
    <td>String</td>
    <td>Version of the LXC container (depdendant on template type)</td>
    <td><tt>Yes</tt></td>
  </tr>
  <tr>
    <td><tt>['lxc_container']['node']['NODE_NAME']['hwaddr']</tt></td>
    <td>String</td>
    <td>MAC Address of the node; Will be generated at run time</td>
    <td><tt>Yes</tt></td>
  </tr>
</table>

Usage
-----
#### lxc_manage::default
Include recipe in your node's run list, and run chef-client.

e.g.
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[lxc_manage]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:
  Chris Hammer (chris.hammer@gmail.com)
