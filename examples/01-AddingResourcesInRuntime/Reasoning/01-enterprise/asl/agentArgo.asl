/* Initial beliefs and rules */
abroad(yes)[source(agentComm)].
value(50)[source(self)].

/* Initial goals */
!start.

/* Plans */
+!start : abroad(no)[source(agentComm)] <- .print("agentArgo está na nave - Iniciando controle do hardware"); !conf.
+!start : abroad(yes)[source(agentComm)] <- .print("AgentArgo aguardando transporte"); .wait(5000); -abroad(yes); .send(agentComm,askOne,abroad(Status),Reply); +Reply; !start.
+!start <- .send(agentComm,askOne,abroad(Status),Reply); +Reply; !start.
+!conf : abroad(no) <- .print("Iniciando a comunicação com o Arduino"); .port(ttyACM0); .percepts(open); !decide.
+!decide : lightSensor(no) <- .print("SemLuz-aguardando"); !decide.
+!decide : lightSensor(yes) <- !atua.
+!decide <- .print("Erro ao comunicar com o hardware").
+!atua : lightSensor(no) <- .act(stopRightNow); .print("Parando a execução - Fim da Luz"); !decide.
+!atua : lightSensor(yes) <- !rota.
+!rota : (obstFront(X) & (value(Y) & (obstLeft(L) & ((X > Y) & (L <= Y))))) <- .act(turnRight); .print("Frente Livre e Direita Com obstáculo L=",L); !decide.
+!rota : (obstFront(X) & (value(Y) & (obstRight(R) & ((X > Y) & (R <= Y))))) <- .act(turnLeft); .print("Frente Livre e Esquerda Com obstáculo R=",R); !decide.
+!rota : (obstFront(X) & (value(Y) & (X > Y))) <- .act(goAhead); .print("Seguindo em Frente X=",X); !decide.
+!rota : (obstFront(X) & (value(Y) & ((X <= Y) & (obstRight(R) & (obstLeft(L) & (R > L)))))) <- .act(turnLeft); .act(turnLeft); .print("Esquerda R=",R,"L=",L); !decide.
+!rota : (obstFront(X) & (value(Y) & ((X <= Y) & (obstRight(R) & (obstLeft(L) & (R <= L)))))) <- .act(turnRight); .act(turnRight); .print("Direita R=",R,"L=",L); !decide.

