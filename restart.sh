# Restart script linked in crontab to restart a Minecraft server.
# Created by asim0v
#
#!/bin/bash 

IDENT=GPack

    tmux send-keys -t $IDENT "say " $IDENT " server restarting in 5 minutes" C-m;
	sleep 4m;
	
	tmux send-keys -t $IDENT "say " $IDENT " server restarting in 1 minute" C-m;
	sleep 55s;

	tmux send-keys -t $IDENT "say " $IDENT " server now restarting" C-m;
	tmux send-keys -t $IDENT "stop" C-m;
