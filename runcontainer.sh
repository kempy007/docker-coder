#/bin/bash!

export DUID=`id -u`
export DGID=`id -g`

if [ $DUID -ge 10000 ]; then
	cat /etc/passwd | sed -e "s/^user:/builder:/" > /tmp/passwd
	echo "user:x:$DUID:$DGID::/home/user:/bin/bash" >> /tmp/passwd
	cat /tmp/passwd > /etc/passwd
	rm /tmp/passwd
fi

dumb-init code-server --bind-addr 0.0.0.0:8080 .