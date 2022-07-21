/* Initial beliefs and rules */
abroad(yes).
value(50).
/* Initial goals */
/*!start.*/
!conf.
/* Plans */
/*+!start: abroad(no) <-
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

+!start: inside <-
	-+abroad(no);
	!start.
*/
+!conf <-
	.print("Iniciando a comunicação com o Arduino");
	.port(ttyACM0);
	.percepts(open);
	!decide.
	
+!decide:lightSensor(no) <-
	.print("SemLuz-aguardando");
	!decide.
	
+!decide:lightSensor(yes) <-
	!atua.
	
+!decide <-
	.print("Erro ao comunicar com o hardware").




	
+!atua: lightSensor(no)  <-
	.act(stopRightNow);
	.print("Parando a execução - Fim da Luz");
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
