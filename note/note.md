```bash
Setting up SSH Host kimjayhyun.site: Waiting for port forwarding to be ready
```

```bash
[12:39:54.757] Waiting for ssh tunnel to be ready
[12:39:54.758] [Forwarding server port 12413] Got connection 0
[12:39:54.759] Tunneled port 37795 to local port 12413
[12:39:54.759] Resolved "ssh-remote+kimjayhyun.site" to "port 12413"
[12:39:54.765] Initizing new exec server for ssh-remote+kimjayhyun.site
[12:39:54.765] Resolving exec server at port 12413
[12:39:54.767] [Forwarding server port 12413] Got connection 1
[12:39:54.776] Failed to set up socket for dynamic port forward to remote port 37795: Socket closed. TCP port forwarding may be disabled, or the remote server may have crashed. See the VS Code Server log above for details.
[12:39:54.776] Failed to set up socket for dynamic port forward to remote port 37795: Socket closed. TCP port forwarding may be disabled, or the remote server may have crashed. See the VS Code Server log above for details.
[12:39:54.777] > 
[12:39:54.795] > channel 3: open failed: administratively prohibited: open failed
> channel 4: open failed: administratively prohibited: open failed
[12:39:54.796] ERROR: TCP port forwarding appears to be disabled on the remote host. Ensure that the sshd_config has `AllowTcpForwarding yes`. Contact your system administrator if needed.
[12:39:54.811] > 
```

```ini
# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

AllowAgentForwarding no
AllowTcpForwarding yes # 해당 부분 수정하였음
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none
```