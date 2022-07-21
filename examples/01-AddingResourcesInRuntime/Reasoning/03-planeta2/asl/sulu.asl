// Agente A
/* Initial beliefs and rules */
abroad(yes).
/* Initial goals */
!start.

/* Plans */
+!start: abroad(no) <-
  	.print("Sulu");
	.print("Sulu está na nave");
	!play.
	
+!start: abroad(yes) <-
	.print("Sulu Aguardando transporte  - abroad(yes)");
	.wait(5000);
	-abroad(yes);
	.send(macCoy, askOne, abroad(Status), Reply);
	+Reply;
	!start.

/*+!start: inside <-
	-+abroad(no);
	!start.
	*/
    
+!play <-
	.print("estou na nave e usando o arduino");
	.port(ttyACM1);
    .percepts(open);
    .print("ligando led");
    .act(turnOnLight);
    .wait(3000);
    .print("desligando led");
    .act(turnOffLight);
    .wait(5000);
    !start.   

