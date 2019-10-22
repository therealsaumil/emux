# ARM-X Firmware Emulation Framework

by Saumil Shah [@therealsaumil][saumil]

[saumil]: https://twitter.com/therealsaumil

October 2019

![ARMX](docs/armx-banner.png "ARM-X")

The ARM-X Firmware Emulation Framework is a collection of scripts, kernels and filesystems to be used with [QEMU][qemu] to emulate ARM/Linux IoT devices.  ARM-X is aimed to facilitate IoT research by virtualising as much of the physical device as possible. It is the closest we can get to an actual IoT VM.

[qemu]: https://www.qemu.org/

Devices successfully emulated with ARM-X so far:

* D-Link DIR-880L Wi-Fi Router
* Netgear Nighthawk R6250 Wi-Fi Router
* Netgear Nighthawk R6400 Wi-Fi Router
* Trivision NC227WF Wireless IP Camera
* Cisco RV130 Wi-Fi Router

Precursors of ARM-X have been used in Saumil Shah's popular [ARM IoT Exploit Laboratory][armexploitlab] training classes where students have found four 0-day vulnerabilities in various ARM/Linux IoT devices.

[armexploitlab]: https://ringzer0.training/arm-iot-exploitlab.html

## ARM-X Architecture and Operations

ARM-X is a collection of scripts, kernels and filesystems residing in the `/armx` directory. It uses `qemu-system-arm` to boot up a virtual ARM/Linux environment. The `/armx` directory is exported over NFS to also make the contents available within the QEMU guest.

The host system running `qemu-system-arm` is assigned the IP address `192.168.100.1` and the QEMU guest is assigned `192.168.100.2` via `tap0` interface.

![Architecture](docs/armx-architecture.png)

The `/armx` directory is organised as follows:

![Directory Structure](docs/armx-dirstructure.png)

* `devices`: This file contains device definitions, one per line.
* `run/`: This folder contains scripts necessary to parse the device configuration, preload nvram contents and eventually invoke the userland processes of the device being emulated.
* `run/launcher`: The main script. `launcher` parses the `devices` file and displays a menu of registered devices. Selecting one of the devices will in turn invoke `qemu-system-arm` with the pre-defined QEMU options, corresponding Linux kernel and extracted root file system registered with the device.
* `template/`: Sample configuration and layout for a new device. Make a copy of the template when beginning to emulate a new IoT device.

Each emulated device contains the following files/directories:

* `config`: Contains the device's name and description, ASLR settings, location of its root file system and commands to issue after the kernel has booted up and transferred control to the userland.
* `nvram.ini`: Contents of the device's non volatile memory, used for storing configuration settings. Contents of `nvram.ini` are preloaded into the emulated nvram before invoking the userland init scripts.
* `kernel/`: Contains a Linux kernel compiled (mostly via Buildroot) to closely match the properties of the emulated device such as kernel version, CPU support, VM_SPLIT, supported peripherals, etc.
* `rootfs/`: Populated with the uncompressed file system extracted from the device's firmware.
* `run-init`: Script invoked by the launcher.

The diagram below describes each stage of ARM-X:

![ARM-X Operations](docs/armx-operations.png)

1. Invoke `/armx/run/launcher`. This will display a menu as shown below. In this example, we select the Trivision TRI227WF Wireless IP Camera.

<img src="docs/01-armx-launcher.png" width="600">

2. Selecting one of the devices will launch it under QEMU. The kernel which is included in the `kernel/` directory of the Trivision IP Camera's device configuration, is booted in `qemu-system-arm` and uses a pre-built Buildroot filesystem, which is referred to as `hostfs.ext2`. Host and guest IP addresses are assigned to `192.168.100.1` and `192.168.100.2` respectively.

<img src="docs/02-armx-kernel-boot-up.png" width="600">

3. `hostfs.ext2` contains several scripts and tools useful for running and dynamic analysis of the emulated device. The init scripts in `hostfs.ext2` mount the `/armx` directory over NFS. Thus, the contents of `/armx` are shared by both the host and the QEMU guest.

4. To kick off the rest of the device startup, connect to the QEMU guest using SSH `ssh root@192.168.100.2`. This brings up a menu as shown below:

<img src="docs/03-armx-trivision-init.png" width="600">

5. Selecting the option to launch the userland init scripts of the device results in `run-init` being invoked from the corresponding device configuration directory within `/armx`. First, the contents of `nvram.ini` are loaded into the kernel's emulated nvram driver. Next, a `chroot` jail is created using the `rootfs` of the device. Lastly, the registered initialisation commands are invoked in the newly `chroot`ed `rootfs`, bringing up the device's services and init scripts.

<img src="docs/04-armx-trivision-started.png" width="600">

6. Once the device has fully "booted up" in ARM-X, it is available for testing and analysis. The image below shows the administration interface of the IP Camera loaded in a browser:

<img src="docs/06-armx-trivision-browser.png" width="600">

### Release Presentation

ARM-X was released at [HITB+Cyberweek][HITB] on October 16 2019. Here are the slides from the talk at HITB+Cyberweek:

[HITB]: https://cyberweek.ae/speaker/saumil-shah/

<iframe src="https://www.slideshare.net/slideshow/embed_code/key/9FqUwLVZaoLaxO" width="800" height="600" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #003c62; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/saumilshah/introducing-armx" title="Introducing ARM-X" target="_blank">Introducing ARM-X</a> </strong> from <strong><a href="https://www.slideshare.net/saumilshah" target="_blank">Saumil Shah</a></strong> </div>

### TODO

* Clean up the documentation

### END

ARM-X is licensed under the Mozilla Public License v2.0 (MPLv2).

v0.9	22-October-2019, Preview Release


