# Getting Started

There are just two cookbooks in that repository, and one of them is **errbit**. This cookbook installs Errbit along with any prerequisites. 
`Debian-11` and `Ubuntu-22.04` installation instructions are provided by this cookbook.

# Usage

You must be in the `cookbooks/errbit` folder in order to perform the `kitchen test`. Additionally, you must include your static IPs in **kitchen.yml** according to your system's IP ranges.

```yml
driver:
    network:
    - ["private_network", {ip: "{YOUR_PRIVATE_IP}"}]
```

Following completion of all tasks, the test will run for **~35m**. You can create virtual machines (VMs) with errbit installed by using the command "kitchen converge," which gives you the option to access them using the URL `http://VM_IP:3333`.