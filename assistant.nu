#!/usr/bin/env nu

const mount_path = "/mnt"
const user_home = "/home/" + user_name
const user_age_file = $user_home + "/.config/age/home.key"

def machine_name [] {
}

alias user_name = whoami

def machinedir [machine_name: string] {
	print $"Ensure directory for ($machine_name)"
	mkdir $"./machines/($machine_name)"
}

def prepare [machine_name: string] {
	machinedir $machine_name
	print "Creating templatefiles from silvio-pc as example"
	# TODO use nix template
	cp --no-clobber "./machines/silvio-pc/default.nix" $"./machines/($machine_name)/default.nix"
	cp --no-clobber "./machines/silvio-pc/bootloader.nix" $"./machines/($machine_name)/bootloader.nix"
	cp --no-clobber "./machines/silvio-pc/disko.nix" $"./machines/($machine_name)/disko.nix"
}

def disco-create [machine_name: string] {
	print $"Creating partitions according to ./machines/($machine_name)/disko.nix"
	sudo nix run github:nix-community/disko -- $"./machines/($machine_name)/disko.nix" -m create
}

export def disco-mount [machine_name: string] {
	print $"Mounting new partitions at ($mount_path)"
	sudo nix run github:nix-community/disko -- $"./machines/($machine_name)/disko.nix" -m mount
}

def generate-config [machine_name: string] {
	disco-mount $machine_name
	print "Ensure hardware-specific config"
	nixos-generate-config --no-filesystems --dir $"./machines/($machine_name)"
	rm $"machines/($machine_name)/configuration.nix"
}

def wait-enter [] {
	mut user_input = (input listen)
	while (not (($user_input.type == "key") and ($user_input.key_type == "other")  and ($user_input.code == "enter"))) {
		$user_input = (input listen)
	}
}

export def install-steps [machine_name: string=""] {
	let machine_name = if ($machine_name != "") {$machine_name} else {
		print "Enter machine name"
		input
	}
	prepare $machine_name
	let machine_dir = $"./machines/($machine_name)"
	print $"Now adapt the files in ($machine_dir)"
	print "Then continue with ENTER"
	wait-enter
	print $"Adding ($machine_dir) to git"
	git add $machine_dir
	print $"Will now FORMAT all disks according to ($machine_dir)/disko.nix"
	print "!!ALL DATA ON THOSE DISKS WILL BE LOST!!"
	print "OK? Answer with yes in capital letters."
	let u = input
	if ($u != "YES") { print Aborting.; return}
	disco-create $machine_name
	generate-config $machine_name
	print $"Adding ($machine_dir) to git"
	git add $machine_dir
	print $"Please remove all duplicate disk mounts from ($machine_dir)/configuration.nix"
	print "Continue with ENTER"
	wait-enter
	install-nixos $machine_name
}

export def install-nixos [machine_name: string] {
	sudo nixos-install --flake $".#($machine_name)" --no-root-password
}

def system-gen-sops [] {
	# TODO
}

def system-install [] {
	nixos-install
	system-gen-sops
}

def user-copy [machine_name: string, user_name: string] {
	disco-mount $machine_name
	sudo nix copy --to $mount_path $".#homeConfigurations.(user_name).activationPackage" --no-check-sigs
}

def user-gen-sops [age_file: string, --force] {
	if ($force or ($age_file | path exists)) {
		mkdir ($age_file | path dirname)
		age-keygen 2>/dev/null | save -f $age_file
		echo $"Wrote \(new\) private key to ($age_file)"
	}
	echo $"Now add the public key (open $age_file | age-keygen -y) to .sops.yaml"
}

def user-clone [machine_name: string] {
	disco-mount $machine_name
	git clone . {{user_home}}/nixos
	git -C $"($user_home)/nixos" remote rename origin installer
	git -C $"($user_home)/nixos" remote add origin (git remote get-url origin)
}

def user-install [machine_name: string, user_name: string] {
	disco-mount $machine_name
	user-copy $machine_name $user_name
	user-clone $machine_name
	user-gen-sops ($mount_path + $user_age_file)
}

def local-user-rotate-sops [] {
	user-gen-sops $user_age_file --force
}

def install [machine_name: string, user_name: string] {
	nixos-install $machine_name
	user-install $machine_name $user_name
}

def passwd [user: string] {
	let pw = (mkpasswd)
	let pwfile = "system/modules/users/secrets.yaml"
	#yq -s '.[0] * .[1]' <(sops -d "$pwfile") <(cat <<< "{{user}}: $pw") | sops -e --input-type json /dev/stdin
	sops --set $'["($user)"] "($pw)"' $pwfile #exposes the hashed password in the process table
}

def u2fkey-add [] {
	print "Please touch the device..."
	pamu2fcfg -o "pam://nixos-silvio" | $"($in)\n" | save --append system/modules/security/u2f_keys
}

def repair-store [] {
	sudo nix-store --repair --verify --check-contents
}
