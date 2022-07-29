/* Initial beliefs and rules */
//abroad(yes).
value(50).
/* Initial goals */
!start.
//!conf.
/* Plans */
+!start: abroad(no)[source(agentComm)] <-
	.print("I am inside - starting my task");
	!conf.
	
+!start: abroad(yes)[source(agentComm)] <-
	.print("Waiting for transference");
	.wait(5000);
	-abroad(yes);
	.send(agentComm, askOne, abroad(Status), Reply);
	-+Reply;
	!start.

+!start <-
	.send(agentComm, askOne, abroad(Status), Reply);
	-+Reply;
	!start.
	
//************************************************************
+!conf: abroad(no)<-
	.print("Conecting with resource 01");
	.port(ttyACM0);
	.percepts(open);
	!decide.
	
+!decide:lightSensor(no) <-
	.print("No light - waiting");
	!decide.
	
+!decide:lightSensor(yes) <-
	!atua.
	
+!decide <-
	.print("Error!").

///************************************************************//

+!atua: lightSensor(no)  <-
	.act(stopRightNow);
	.print("Stopping light off");
	!decide.

+!atua: lightSensor(yes) <-
	//.print("tem luz e está andando");
	!rota.


+!rota: obstFront(X) & value(Y) & obstLeft(L) & X > Y & L<= Y <-
	.act(turnRight);
	.print("Frente Livre e Direita Com obstáculo L=",L);
	!decide.
	
+!rota: obstFront(X) & value(Y) & obstRight(R) & X > Y  &  R <= Y <-
	.act(turnLeft);
	.print("Frente Livre e Esquerda Com obstáculo R=",R);
	!decide.


+!rota: obstFront(X) & value(Y) & X > Y <-
	.act(goAhead);
	.print("Seguindo em Frente X=",X);
	!decide.

+!rota: obstFront(X) & value(Y) & X <= Y & obstRight(R) & obstLeft(L) & R > L <-
	.act(turnLeft);
	.act(turnLeft);
	.print("Esquerda R=",R,"L=",L);
	!decide.
	
+!rota: obstFront(X) & value(Y) & X <= Y & obstRight(R) & obstLeft(L) & R <= L <-
	.act(turnRight);
	.act(turnRight);
	.print("Direita R=",R,"L=",L);
	!decide.
