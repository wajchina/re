#!/bin/bash 

# refer https://gist.github.com/mslacken/4dbef54e55069b51178721cdf1c0107f

# Copyright (C) 2019 by Christian Goll <cgoll@suse.de>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.

# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
export SLURMD=/usr/sbin/slurmd
export SLURMCONF=/etc/slurm/slurm.conf
export GRESCONF=/etc/slurm/gres.conf
export NOW=$(date +%Y%m%d%H%M)
export MUNGEKEYCMD=/usr/sbin/create-munge-key
export MUNGEKEYFILE=/etc/munge/munge.key
if [ -e $MUNGEKEYFILE ] ; then
	echo "$MUNGEKEYFILE is exist"
else
	$MUNGEKEYCMD && echo "$MUNGEKEYFILE is generated"
fi

if [ -e $SLURMCONF ] ; then
	cp $SLURMCONF $SLURMCONF.$NOW
fi
if [ -e $GRESCONF ] ; then
	cp $GRESCONF $GRESCONF.$NOW
fi

cat > $SLURMCONF <<EOF
# instant slurm file, automatically generated
ClusterName=$(cat /etc/machine-id)
ControlMachine=localhost
SlurmdUser=root
SlurmctldPort=6817
SlurmdPort=6818
StateSaveLocation=/var/lib/slurm
SlurmdSpoolDir=/var/spool/slurm
SwitchType=switch/none
MpiDefault=none
SlurmctldPidFile=/var/run/slurm/slurmctld.pid
SlurmdPidFile=/var/run/slurm/slurmd.pid
ProctrackType=proctrack/pgid
SlurmctldTimeout=300
SlurmdTimeout=300
InactiveLimit=0
MinJobAge=300
KillWait=30
Waittime=0
SchedulerType=sched/builtin
FastSchedule=1
SlurmctldDebug=3
SlurmctldLogFile=/var/log/slurmctld.log
SlurmdDebug=3
SlurmdLogFile=/var/log/slurmd.log
JobCompType=jobcomp/none
PropagateResourceLimitsExcept=MEMLOCK
PartitionName=normal Nodes=localhost Default=YES MaxTime=UNLIMITED State=UP
NodeName=localhost FOO $($SLURMD -C | grep -v UpTime | cut -f 2-32 -d ' ')
EOF

if [ -e /dev/nvidia0 ] ; then
gpucount=$(ls /dev/nvidia[0-9] | wc -l)
if [ $gpucount -eq 1 ] ; then
cat > $GRESCONF <<EOF
Name=gpu File=/dev/nvidia0
EOF
cat >> $SLURMCONF <<EOF
GresTypes=gpu
EOF
sed -i 's/FOO/GresType=gpu/' $SLURMCONF
elif [ $gpucount -gt 1 ] ; then
cat > $GRESCONF <<EOF
Name=gpu File=/dev/nvidia[0-$(($gpucount-1))]
EOF
cat >> $SLURMCONF <<EOF
GresTypes=gpu
EOF
sed -i 's/FOO/GresType=gpu/' $SLURMCONF
fi
else 
sed -i 's/FOO//' $SLURMCONF
fi 

cat <<EOF
# Wrote minimal instant slurm configuration to $SLURMCONF
# Orginal $SLURMCONF can be found under $SLURMCONF.$NOW
EOF
if [ -e $GRESCONF ] ; then
cat <<EOF
# Wrote $GRESCONF
EOF
fi
cat <<EOF

# WARNING: slurmd and slurmctl will run
# Now slurmd, slurmctld and munge can be started with:
systemctl start munge 
systemctl start slurmctld
systemctl start slurmd
# You may also have to enable node with
# scontrol update NodeName=localhost State=RESUME
EOF