## Adding new machines
1. Export the hostname of the new machine `export machine_name=...`
1. Run `just prepare`
1. Adapt files in /system/machines/{{machine_name}}
1. Run `just install`
