#!/bin/sh

case $1 in

	#gen_disk disk_name 32G
	"gen_disk") 
		disk="$2.qcow2"
		if [ -f $disk ]; then
			echo "file alredy exists"
		else
			qemu-img create -f qcow2 $disk $3
		fi;;

	# boot_iso system.qcow2 isofile.iso
	"boot_iso") 
		taskset -c 0,2,4,6 \
			qemu-system-x86_64 -enable-kvm -cpu host \
			-m 10G -smp 4 \
			--bios /usr/share/edk2-ovmf/OVMF_CODE.fd \
			-hda $2 -boot d -cdrom $3 \
			-netdev user,id=net0,net=10.1.0.0/16,dhcpstart=10.1.0.2 \
			-device e1000,netdev=net0 -vga qxl -device AC97;;

	# boot_disk system.qcow2 
	"boot_disk") 
		taskset -c 0,2,4,6 \
			qemu-system-x86_64 -enable-kvm -cpu host \
			-m 10G -smp 4 \
			--bios /usr/share/edk2-ovmf/OVMF_CODE.fd \
			-hda $2 \
			-netdev user,id=net0,net=10.1.0.0/16,dhcpstart=10.1.0.2 \
			-device e1000,netdev=net0 -vga qxl -device AC97;;

	# boot_live isofile.iso
	"boot_live") 
		taskset -c 0,2,4,6 \
			qemu-system-x86_64 -enable-kvm -cpu host \
			-m 10G -smp 4 \
			--bios /usr/share/edk2-ovmf/OVMF_CODE.fd \
			-boot d -cdrom $2 \
			-netdev user,id=net0,net=10.1.0.0/16,dhcpstart=10.1.0.2 \
			-device virtio-net-pci,netdev=net0 -vga qxl -device AC97;;

	*)
		echo "usage:"
		echo -e "\t$0 gen_disk disk_name 32G"
		echo -e "\t$0 boot_iso system.qcow2 isofile.iso"
		echo -e "\t$0 boot_disk system.qcow2"
		echo -e "\t$0 boot_live isofile.iso";;
esac
