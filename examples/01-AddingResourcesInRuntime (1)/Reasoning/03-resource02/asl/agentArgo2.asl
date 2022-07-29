/* Initial beliefs and rules */
value(50).
/* Initial goals */
!start.

/* Plans */
+!start: abroad(no)[source(agentComm2)] <-
	.print("AgentArgo2 inside! Starting my task!");
	!conf.
	
+!start: abroad(yes)[source(agentComm2)] <-
	.print("AgentArgo2 waiting for transference.");
	.wait(5000);
	-abroad(yes);
	.send(agentComm2, askOne, abroad(Status), Reply);
	-+Reply;
	!start.

+!start <-
	.send(agentComm2, askOne, abroad(Status), Reply);
	-+Reply;
	!start.
	
//************************************************************
+!conf: abroad(no)<-
	.print("Connecting with microcontroler");
	.port(ttyACM1);
	.percepts(open);
	!decide.
	
+!infoByArgo1<-
	.send(agentArgo, askOne, obstFront(Status), Reply);
	-+Reply.

+!decide: obstFront(X) & value(Y) & X > Y <-
	//-obstFront(X)[source(agentArgo)];
	.print("Nothing to do!",X);
	!infoByArgo1;
	!decide.

+!decide: obstFront(X) & value(Y) & X <= Y <-
	//-obstFront(X)[source(agentArgo)];
	.print("Acting buzzer!");
	.act(buzzer);
	!infoByArgo1;
	!decide.
	
+!decide <-
	.print("Waiting information about front obstacule.");
	!infoByArgo1;
	!decide.	
	