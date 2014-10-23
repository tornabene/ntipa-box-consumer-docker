#!/bin/sh
        # Provides: unoconvd
        # Required-Start: $network
        # Required-Stop: $network
        # Default-Start: 2 3 5
        # Default-Stop:
        # Description: unoconvd - Converting documents to PDF by unoconv
        ### END INIT INFO
        case "$1" in
    start)
        /usr/bin/unoconv --listener &
        ;;
    stop)
        killall soffice.bin
        ;;
    restart)
        killall soffice.bin
        sleep 1
        /usr/bin/unoconv --listener &
        ;;
        esac

