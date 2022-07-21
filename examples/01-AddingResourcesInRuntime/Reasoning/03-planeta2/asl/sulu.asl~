// Agente A
/* Initial beliefs and rules */
abroad(yes).
/* Initial goals */
!start.

/* Plans */
+!start: abroad(no) <-
  	.print("Computer, Lieutenant Commander Spock, First Officer");
	.print("Spock está na nave");
	!play.
	
+!start: abroad(yes) <-
	.print("Spock Aguardando transporte  - abroad(yes)");
	.wait(5000);
	-abroad(yes);
	.send(kirk, askOne, abroad(Status), Reply);
	+Reply;
	!start.

/*+!start: inside <-
	-+abroad(no);
	!start.
	*/
    
+!play <-
	.print("estou na nave e usando o arduino");
	.port(ttyACM0);
    .percepts(open);
    .print("ligando led");
    .act(turnOnLight);
    .wait(3000);
    .print("desligando led");
    .act(turnOffLight);
    .wait(5000);
    !start.   

