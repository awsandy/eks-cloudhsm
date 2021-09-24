#! /bin/sh

        # start cloudhsm client as a daemon running in a background process
        echo -n "DEBUG (info) - CLOUDHSM-CLIENT-CHILD: startDaemon.sh - Starting CloudHSM client ... "
        /opt/cloudhsm/bin/cloudhsm_client /opt/cloudhsm/etc/cloudhsm_client.cfg &> /tmp/cloudhsm_client_start.log &

        # Tail Logs to stdout to keep container alive
        tail -f /tmp/cloudhsm_client_start.log
