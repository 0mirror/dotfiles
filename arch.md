# Arch install help
	
## 1. Set the keyboard layout:
	ls /usr/share/kbd/keymaps/**/*.map.gz
	loadkeys de-latin1

## 2. Verify the boot mode:
	ls /sys/firmware/efi/efivars

## 3. Connect to the internet:
	ip link
	For wireless, make sure the wireless card is not blocked with rfkill.
	Wi-Fi—authenticate to the wireless network using iwctl.
	wifi-menu

## 4. Update the system clock:
	Use timedatectl to ensure the system clock is accurate
	timedatectl set-ntp true
	timedatectl status

## 5. Partition the disks:
	fdisk -l
	UEFI with GPT
	Mount point				Partition					Partition type			Suggested size
	/mnt/boot or /mnt/efi	/dev/efi_system_partition	EFI system partition	At least 260 MiB (550M)
	[SWAP]					/dev/swap_partition			Linux swap				More than 512 MiB (2G)
	/mnt					/dev/root_partition			Linux x86-64 root (/)	Remainder of the device

## 6. Format the partitions:
	EFI System, Linux swap, Linux filesystem
	mkfs.fat -F32 /dev/sda1(efi partition)
	mkswap /dev/sda2(swap partition)
	arch wiki --> mkfs.ext4 /dev/root_partition
	arch wiki --> mkswap /dev/swap_partition

## 7. Mount the file systems:
	mount /dev/root_partition /mnt
	swapon /dev/swap_partition

## 8. Select the mirrors:
	/etc/pacman.d/mirrorlist

## 9. Install essential packages:
	pacstrap /mnt base linux linux-firmware

## 10. Fstab:
	Generate an fstab file (use -U or -L to define by UUID or labels, respectively)
	genfstab -U /mnt >> /mnt/etc/fstab

## 11. Change root into the new system:
	arch-chroot /mnt

## 12. Time zone:
	ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
	Run hwclock to generate /etc/adjtime
	hwclock --systohc  (This command assumes the hardware clock is set to UTC)

## 13. Localization:
	Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8 and other needed locales. Generate the locales by running:
	locale-gen
	Create the locale.conf(5) file, and set the LANG variable accordingly
	/etc/locale.conf
	LANG=en_US.UTF-8

## 14. Network configuration:
	Create the hostname file
	/etc/hostname
	myhostname
	Add matching entries to hosts
	/etc/hosts
	127.0.0.1	localhost
	::1		localhost
	127.0.1.1	myhostname.localdomain	myhostname

## 15. Set the root password:
	passwd

## 16. Add users:
	useradd -m user1
	passwd user1
	usermod -aG wheel,audio,video,optical,storage user1

## 17. Install sudo:
	pacman -S sudo
	Edit sudoers file
	visudo
	EDITOR=nano visudo
	uncomment wheel group
	%wheel ALL=(ALL) ALL

## 18. Boot loader:
	pacman -S grub
	also because of efi we need:
	pacman -S efibootmgr dosfstools os-prober mtools
	mkdir /boot/EFI
	mount /dev/sda1 /boot/EFI
	grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
	grub-mkconfig -o /boot/grub/grub.cfg

## 19. Install before reboot:
	pacman -S networkmanager
	systemctl enable NetworkManager

## 20. Reboot:
	Exit the chroot environment by typing exit or pressing Ctrl+d
	Optionally manually unmount all the partitions with umount -R /mnt (or umount -l /mnt)
	this allows noticing any "busy" partitions, and finding the cause with fuser
	reboot

<br>

-------------------------------------------------------------
-------------------------------------------------------------
<br>

## Pacman 1

	alacritty
	dmenu
	feh
	firefox
	i3
	picom
	polybar
	xorg
	xorg-xinit		cp /etc/X11/xinit/xinitrc ~/.xinitrc
	vim

-------------------------------------------------------------

## Pacman 2

	MOC
	PulseAudio
	ranger
	htop 
	neofetch
	pcmanfm
	xorg-xrandr
	xorg-xbacklight
	LibreOffice
	zathura
	zathura-pdf-poppler
	VLC

-------------------------------------------------------------

## yay

	first pacman -S base-devel to be able to makepkg
	clone yay
	makepkg -si

-------------------------------------------------------------

## .bash_profile

	[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1

-------------------------------------------------------------

## .xinit

	picom &
	exec i3

<br>

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
<br>


## Fonts

- fonts

```
ttf-bitstream-vera
ttf-dejavu
otf-san-francisco-pro
```

```
sudo pacman -S adobe-source-sans-pro-fonts  ttf-anonymous-pro ttf-bitstream-vera ttf-dejavu ttf-droid ttf-gentium ttf-liberation ttf-ubuntu-font-family
```

- greek fonts

``` 
otf-gfs -- AUR
ttf-mgopen -- AUR
```

<br><br>

## Firefox right click selects first option

	about:config
	ui.context_menus.after_mouseup  true

### Spell check

	aspell-en
	enchant
	gst-libav
	gst-plugins-good
	hunspell-en
	icedtea-web
	languagetool
	libmythes
	mythes-en



pkgstats

jre8-openjdk
