GCE deployment scripts and tools for TrinityX

In order to deploy TrinityX cluster into Google Compute Engine install ``terraform`` and add it to your ``PATH``.
Initiate Terraform:
```$ cd gce_tf
$ terraform init```
Create a service account and get the ``json`` file for GCE as described here: https://www.terraform.io/docs/providers/google/getting_started.html
Download this ``json`` file. Set the variables defined in ``vars.tf`` via environment variables:
``` $ export TF_VAR_zone="europe-west3-a" 
  $ export TF_VAR_region="europe-west3"
  $ export TF_VAR_credentials_file="<PATH_TO_JSON_FILE>"
  $ export TF_VAR_project="openhpc" #project name
  $ export TF_VAR_name_prefix="vkr" #prefix for resource names in GCE. The controller VM will be named in that case vkr_ctrl0```
Plan and apply so that VM, networks and FW rules are created.
``` $ terraform plan
   $ terraform apply```

After the deployment is done, return to main directory and setup ansible inventory:
``` $ cd ..
$ ./setup.sh```

And prepare controller's environment:
`` $ ansible-playbook install_trix.yml ``
After that ssh to controller:
`` $ ./ssh_ctrl.sh ``
And start TrinityX installation:
``` $ sudo su -
    # cd trix/
    # ansible-playbook controller.yml  ```
