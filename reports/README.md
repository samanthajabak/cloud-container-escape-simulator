The Cloud Container Escape Simulator is a security study that shows how various Docker runtime configurations affect a container's capacity to communicate with / or escape from its host environment.
Four container configurations are covered in this project:
Dangerous_caps container: selectively risky capabilities; unprivileged container: safe baseline
Full kernel-level power mounted_host container—privileged container—catastrophic host filesystem exposure


The same series of escape-oriented tests were applied to each container in order to assess:
1. Exposure of the filesystem: — checks whether the container can see or access the host filesystem
2. Linux's capacity for namespace isolation: checks whether host processes or namespaces are visible
3. Access to devices: lists accessible /dev entries
4. Visibility of kernel logs: checks whether the container can read kernel logs via dmesg
5. Capabilities: enumerates Linux kernel capabilities granted to the container

The purpose is to demonstrate how different Docker runtime configurations affect the attack surface of a containerized environment.
