machine_name := env_var_or_default('machine_name', `hostname`)
mount_path := "/mnt"
user_name := `id -un`
user_home := "/home/" + user_name
user_age_file := user_home + "/.config/age/home.key"

machinedir:
	@echo "Ensure directory for {{machine_name}}"
	mkdir -p ./system/machines/{{machine_name}}

prepare: machinedir
	@echo "Creating templatefiles from silvio-pc as example"
	-cp --no-clobber ./system/machines/{silvio-pc,{{machine_name}}}/default.nix
	-cp --no-clobber ./system/machines/{silvio-pc,{{machine_name}}}/bootloader.nix
	-cp --no-clobber ./system/machines/{silvio-pc,{{machine_name}}}/disko.nix
	-cp --no-clobber ./system/machines/{silvio-pc,{{machine_name}}}/impermanence.nix
	@echo "Now adapt the files in ./system/machines/{{machine_name}}"
	@echo "Then continue with \`just install\`"

disco-create:
	@echo "Creating partitions according to ./system/machines/{{machine_name}}/disko.nix"
	sudo disko -- ./system/machines/{{machine_name}}/disko.nix -m create

disco-mount:
	@echo "Mounting new partitions at {{mount_path}}"
	sudo disko -- ./system/machines/{{machine_name}}/disko.nix -m mount

generate-config: disco-mount
	@echo "Ensure hardware-specific config"
	nixos-generate-config --no-filesystems --dir ./system/machines/$machine_name
	rm system/machines/{{machine_name}}/configuration.nix

nixos-install: generate-config
	sudo nixos-install --flake ./system\#{{machine_name}}

system-gen-sops:
	# TODO

system-install: nixos-install system-gen-sops

user-copy: disco-mount
	sudo nix copy --to "{{mount_path}}" ./user'#homeConfigurations.'"{{user_name}}"'.activationPackage' --no-check-sigs

user-gen-sops age_file force:
	#!/usr/bin/env bash
	if [ "{{force}}" == true ] || [ -n {{age_file}} ]; then
		mkdir -p "$(dirname {{age_file}})"
		age-keygen 2>/dev/null > {{age_file}}
		echo "Wrote (new) private key to {{age_file}}"
	fi
	echo "Now add the public key $(cat {{age_file}} | age-keygen -y) to .sops.yaml"

user-clone: disco-mount
	git clone . {{user_home}}/nixos
	git -C {{user_home}}/nixos remote rename origin installer
	git -C {{user_home}}/nixos remote add origin "$(git remote get-url origin)"

user-install: disco-mount user-copy user-clone (user-gen-sops (mount_path + user_age_file) "false")
local-user-rotate-sops: (user-gen-sops user_age_file "true")

install: nixos-install user-install

passwd user:
	#!/usr/bin/env bash
	pw=$(mkpasswd)
	pwfile="system/modules/users/secrets.yaml"
	#yq -s '.[0] * .[1]' <(sops -d "$pwfile") <(cat <<< "{{user}}: $pw") | sops -e --input-type json /dev/stdin
	sops --set '["{{user}}"] "'"$pw"'"' "$pwfile" #exposes the hashed password in the process table

yubikey-add:
	@echo "Please touch the device..."
	cat <(pamu2fcfg -o "pam://nixos-silvio") <(printf '\n') >> system/modules/yubikey/u2f_keys
