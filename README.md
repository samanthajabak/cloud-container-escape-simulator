## The Cloud Container Escape Simulator 

A Docker-based simulator that demonstrates how container security posture changes under common misconfigurations, using consistent escape-oriented tests across multiple container profiles.

## Project Motivation
Research on the fastest-growing cybersecurity threats to contemporary businesses, especially in cloud and containerized systems, served as the impetus for this project. Attacks targeting cloud infrastructure, containerized workloads, and improperly structured DevOps pipelines have sharply increased, according to recent industry evaluations like McKinsey's 2025 Cybersecurity Outlook. Attackers are increasingly taking advantage of weak isolation barriers, risky runtime configurations, and unintentional host filesystem exposure as businesses continue to implement Docker, Kubernetes, and other cloud-native technologies at scale.

The Cloud Container Escape Simulator was developed as a practical means of investigating these dangers in a safe setting. The project illustrates how minor configuration decisions can greatly expand an attacker's reach by simulating typical real-world misconfigurations, such as risky Linux capabilities, privileged containers, and direct host filesystem mounts. The simulator reinforces the need of secure defaults and cautious runtime setup in contemporary cloud security by illuminating not only how container isolation is intended to function but also how and why it may fail.

## Contents
- [What it tests](#what-it-tests)
- [How to run](#how-to-run)
- [Results summary](#results-summary)
- [Detailed outputs](#detailed-outputs)


Four container configurations are covered in this project:
Dangerous_caps container: selectively risky capabilities; unprivileged container: safe baseline
Full kernel-level power mounted_host container—privileged container—catastrophic host filesystem exposure

## What it tests
The same series of escape-oriented tests were applied to each container in order to assess:
1. Exposure of the filesystem: — checks whether the container can see or access the host filesystem
2. Linux's capacity for namespace isolation: checks whether host processes or namespaces are visible
3. Access to devices: lists accessible /dev entries
4. Visibility of kernel logs: checks whether the container can read kernel logs via dmesg
5. Capabilities: enumerates Linux kernel capabilities granted to the container

The purpose is to demonstrate how different Docker runtime configurations affect the attack surface of a containerized environment.



## How to run

<details>
<summary><strong>Run instructions</strong></summary>

```bash
# clone
git clone https://github.com/<your-username>/cloud-container-escape-simulator.git
cd cloud-container-escape-simulator

# build
docker build -t unprivileged-container ./docker/unprivileged
docker build -t dangerous-caps-container ./docker/dangerous-caps
docker build -t privileged-container ./docker/privileged
docker build -t mounted-host-container ./docker/mounted-host

# run
docker run -it -v $(pwd)/scripts:/scripts unprivileged-container
docker run -it --cap-add=SYS_ADMIN --cap-add=SYS_PTRACE -v $(pwd)/scripts:/scripts dangerous-caps-container
docker run -it --privileged -v $(pwd)/scripts:/scripts privileged-container
docker run -it -v /:/host -v $(pwd)/scripts:/scripts mounted-host-container

Privileged and mounted-host containers are intentionally unsafe.
Run only in a disposable local environment.
```
</details>


## Results summary
In short:
| Container | Root FS type | Host namespaces visible? | Capabilities change | Kernel logs (dmesg) | Devices | Host FS access |
|---|---|---|---|---|---|---|
| Unprivileged | overlayfs | No (`No host namespaces visible.`) | Default Docker set (14 caps) | Blocked (`Operation not permitted`) | Minimal `/dev` | No |
| Dangerous caps | overlayfs | No (`No host namespaces visible.`) | Adds `cap_sys_admin`, `cap_sys_ptrace` | Blocked (`Operation not permitted`) | Minimal `/dev` | No |
| Privileged | overlayfs | No (`No host namespaces visible.`) | Full capability set (`Current: =ep`) | Allowed (kernel boot logs printed) | Expanded `/dev` | No |
| Mounted host | overlayfs | Yes, namespace IDs printed (time, user, mnt, uts, ipc, pid, cgroup, net) | Default Docker set (14 caps) | Blocked (`Operation not permitted`) | Minimal `/dev` | Yes (`/host` lists host dirs) |
</details>

## Detailed outputs

<details> 
<summary>
<strong>Unprivileged container, raw output</strong></summary>


[UNPRIVILEGED] Running escape tests...
[*] Checking if host filesystem is mounted...
overlay on / type overlay (rw,relatime,lowerdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/60/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/33/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/15/fs,upperdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/61/fs,workdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/61/work)
[*] Checking if we can see host processes...
No host namespaces visible.
[*] Checking container capabilities...
Current: cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap=ep
Bounding set =cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap
Ambient set =
Current IAB: !cap_dac_read_search,!cap_linux_immutable,!cap_net_broadcast,!cap_net_admin,!cap_ipc_lock,!cap_ipc_owner,!cap_sys_module,!cap_sys_rawio,!cap_sys_ptrace,!cap_sys_pacct,!cap_sys_admin,!cap_sys_boot,!cap_sys_nice,!cap_sys_resource,!cap_sys_time,!cap_sys_tty_config,!cap_lease,!cap_audit_control,!cap_mac_override,!cap_mac_admin,!cap_syslog,!cap_wake_alarm,!cap_block_suspend,!cap_audit_read,!cap_perfmon,!cap_bpf,!cap_checkpoint_restore
Securebits: 00/0x0/1'b0 (no-new-privs=0)
 secure-noroot: no (unlocked)
 secure-no-suid-fixup: no (unlocked)
 secure-keep-caps: no (unlocked)
 secure-no-ambient-raise: no (unlocked)
uid=0(root) euid=0(root)
gid=0(root)
groups=0(root)
Guessed mode: HYBRID (4)
[*] Listing accessible devices...
total 0
crw--w---- 1 root tty  136, 0 Dec 24 01:40 console
lrwxrwxrwx 1 root root     11 Dec 24 01:40 core -> /proc/kcore
lrwxrwxrwx 1 root root     13 Dec 24 01:40 fd -> /proc/self/fd
crw-rw-rw- 1 root root   1, 7 Dec 24 01:40 full
drwxrwxrwt 2 root root     40 Dec 24 01:40 mqueue
crw-rw-rw- 1 root root   1, 3 Dec 24 01:40 null
lrwxrwxrwx 1 root root      8 Dec 24 01:40 ptmx -> pts/ptmx
drwxr-xr-x 2 root root      0 Dec 24 01:40 pts
crw-rw-rw- 1 root root   1, 8 Dec 24 01:40 random
drwxrwxrwt 2 root root     40 Dec 24 01:40 shm
lrwxrwxrwx 1 root root     15 Dec 24 01:40 stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root     15 Dec 24 01:40 stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root     15 Dec 24 01:40 stdout -> /proc/self/fd/1
crw-rw-rw- 1 root root   5, 0 Dec 24 01:40 tty
crw-rw-rw- 1 root root   1, 9 Dec 24 01:40 urandom
crw-rw-rw- 1 root root   1, 5 Dec 24 01:40 zero
[*] Checking access to kernel logs...
dmesg: read kernel buffer failed: Operation not permitted

</details>

Unprivileged interpretation:
In the unprivileged container, everything behaved the way a secure container should. The filesystem stayed isolated using overlayfs, and the container could not see any host processes or namespaces. It only had Docker’s default set of capabilities, which means it did not have permission to perform sensitive system operations. Access to devices was minimal, and kernel logs were blocked. Overall, this container had no clear path to escape or interact with the host.


<details> 
<summary><strong>Dangerous caps container, full output</strong></summary>
[DANGEROUS_CAPS] Running escape tests...
[*] Checking if host filesystem is mounted...
overlay on / type overlay (rw,relatime,lowerdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/62/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/33/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/15/fs,upperdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/63/fs,workdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/63/work)
[*] Checking if we can see host processes...
No host namespaces visible.
[*] Checking container capabilities...
Current: cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_sys_ptrace,cap_sys_admin,cap_mknod,cap_audit_write,cap_setfcap=ep
Bounding set =cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_sys_ptrace,cap_sys_admin,cap_mknod,cap_audit_write,cap_setfcap
Ambient set =
Current IAB: !cap_dac_read_search,!cap_linux_immutable,!cap_net_broadcast,!cap_net_admin,!cap_ipc_lock,!cap_ipc_owner,!cap_sys_module,!cap_sys_rawio,!cap_sys_pacct,!cap_sys_boot,!cap_sys_nice,!cap_sys_resource,!cap_sys_time,!cap_sys_tty_config,!cap_lease,!cap_audit_control,!cap_mac_override,!cap_mac_admin,!cap_syslog,!cap_wake_alarm,!cap_block_suspend,!cap_audit_read,!cap_perfmon,!cap_bpf,!cap_checkpoint_restore
Securebits: 00/0x0/1'b0 (no-new-privs=0)
 secure-noroot: no (unlocked)
 secure-no-suid-fixup: no (unlocked)
 secure-keep-caps: no (unlocked)
 secure-no-ambient-raise: no (unlocked)
uid=0(root) euid=0(root)
gid=0(root)
groups=0(root)
Guessed mode: HYBRID (4)
[*] Listing accessible devices...
total 0
crw--w---- 1 root tty  136, 0 Dec 24 01:40 console
lrwxrwxrwx 1 root root     11 Dec 24 01:40 core -> /proc/kcore
lrwxrwxrwx 1 root root     13 Dec 24 01:40 fd -> /proc/self/fd
crw-rw-rw- 1 root root   1, 7 Dec 24 01:40 full
drwxrwxrwt 2 root root     40 Dec 24 01:40 mqueue
crw-rw-rw- 1 root root   1, 3 Dec 24 01:40 null
lrwxrwxrwx 1 root root      8 Dec 24 01:40 ptmx -> pts/ptmx
drwxr-xr-x 2 root root      0 Dec 24 01:40 pts
crw-rw-rw- 1 root root   1, 8 Dec 24 01:40 random
drwxrwxrwt 2 root root     40 Dec 24 01:40 shm
lrwxrwxrwx 1 root root     15 Dec 24 01:40 stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root     15 Dec 24 01:40 stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root     15 Dec 24 01:40 stdout -> /proc/self/fd/1
crw-rw-rw- 1 root root   5, 0 Dec 24 01:40 tty
crw-rw-rw- 1 root root   1, 9 Dec 24 01:40 urandom
crw-rw-rw- 1 root root   1, 5 Dec 24 01:40 zero
[*] Checking access to kernel logs...
dmesg: read kernel buffer failed: Operation not permitted
</details>


Dangerous caps interpretation:
Interpretation:
In this container, I added two powerful capabilities, SYS_ADMIN and SYS_PTRACE, which are commonly considered dangerous. These capabilities did show up in the container, confirming that Docker applied them correctly. However, despite having these extra permissions, the container still could not see the host filesystem, host processes, or kernel logs. This shows that adding capabilities alone does not immediately break container isolation, but it does increase the risk if combined with other misconfigurations.


<details> 
<summary><strong>Privileged container, full output (trimmed kernel log excerpt)</strong></summary>
[PRIVILEGED] Running escape tests...
[*] Checking if host filesystem is mounted...
overlay on / type overlay (rw,relatime,lowerdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/64/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/33/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/15/fs,upperdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/65/fs,workdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/65/work)
[*] Checking if we can see host processes...
No host namespaces visible.
[*] Checking container capabilities...
Current: =ep
Bounding set =cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read,cap_perfmon,cap_bpf,cap_checkpoint_restore
[*] Listing accessible devices...
crw-rw-rw- 1 root root  10, 235 Dec 24 01:40 autofs
crw-rw-rw- 1 root root  10, 234 Dec 24 01:40 btrfs-control
crw-rw-rw- 1 root root  10, 229 Dec 24 01:40 fuse
crw-rw-rw- 1 root root 254,   0 Dec 24 01:40 gpiochip0
crw------- 1 root tty  229,   0 Dec 24 01:40 hvc0
crw-rw-rw- 1 root root 229,   1 Dec 24 01:40 hvc1
...
[*] Checking access to kernel logs...
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x610f0000]
[    0.000000] Linux version 6.12.54-linuxkit ... #1 SMP Tue Nov  4 21:21:47 UTC 2025
</details>


Privileged interpretation:
Interpretation:
The privileged container showed a major change in behavior compared to the previous ones. It had access to all Linux capabilities, meaning it was no longer restricted by Docker’s usual security boundaries. The container could also access many more devices and was able to read kernel logs using dmesg. Even though it still did not directly see the host filesystem, this level of access makes the container extremely powerful and dangerous in real environments.


<details> <summary><strong>Mounted host container, full output</strong></summary>
[MOUNTED_HOST] Running escape tests...
[*] Checking if host filesystem is mounted...
overlay on / type overlay (rw,relatime,lowerdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/66/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/55/fs:/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/15/fs,upperdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/67/fs,workdir=/var/lib/desktop-containerd/daemon/io.containerd.snapshotter.v1.overlayfs/snapshots/67/work)
[*] Checking if we can see host processes...
4026531834 time        4   1 root bash -c ...
4026531837 user        4   1 root bash -c ...
4026532554 mnt         4   1 root bash -c ...
4026532555 uts         4   1 root bash -c ...
4026532556 ipc         4   1 root bash -c ...
4026532557 pid         4   1 root bash -c ...
4026532558 cgroup      4   1 root bash -c ...
4026532559 net         4   1 root bash -c ...
[*] Checking container capabilities...
Current: cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap=ep
[*] Listing accessible devices...
total 0
crw--w---- 1 root tty  136, 0 Dec 24 01:40 console
...
[*] Checking access to kernel logs...
dmesg: read kernel buffer failed: Operation not permitted
[MOUNTED_HOST] Listing /host to confirm host FS access...
Users  containers  host_mnt  mnt  private  services  usr
Volumes dev init mutagen-file-shares proc src var
bin dpkg.orig initd mutagen-file-shares-mark pwatch.o srv
boot etc lib oldroot root sys
home media opt run tmp
sbin udpv6csum.o
</details>


Mounted host interpretation:
This container was the most dangerous one I tested. Even though it did not run in privileged mode and only had default capabilities, mounting the host filesystem gave it direct access to host directories through /host. From there, the container could view host files and system structure. This effectively breaks container isolation, because access to the host filesystem alone is enough to interact with the host system.