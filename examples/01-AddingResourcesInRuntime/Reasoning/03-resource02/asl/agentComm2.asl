// Agent agentComm in project resource01
/* Initial beliefs and rules */
embeddedAgent("4168ef73-db44-48e3-a36e-231d3ef4155a").
abroad(yes).

/* Initial goals */
!start.

/* Plans */
+!start : abroad(yes) <-
	.print("Connecting to ContextNet Server!");
	.connectCN("skynet.turing.pro.br",5500,"089d4f17-3753-43ee-b0c3-fdf1f10024e8");
	!send.

+!start : abroad(no)  <-
	.print("Nothing to do!").
	
+!send : abroad(yes) & embeddedReady[source(X)] <-
    .print("Transporter ready!");
    -embeddedReady[source(X)];
    +ready;
    !send.

+!send : abroad(yes) & ready & embeddedAgent(UUID) <-
    -ready;
	-abroad(yes);
	+abroad(no);
	.moveOut(UUID, inquilinism).
    
+!send : abroad(yes) & embeddedAgent(UUID)<-
	.print("AgentComm2 trying communication with EmbeddedAgent...");
	.sendOut(UUID, tell, waiting_for_transfer);
	.wait(2500);
	!send.
