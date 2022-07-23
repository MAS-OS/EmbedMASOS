/* Initial beliefs and rules */

/* Initial goals */
!start.

/* Plans */

+!start <-
	.print("Iniciando SMA Embarcado");
	!connect.

+!connect <-
	.print("Iniciando conexão com a SkyNet");
	.connectCN("skynet.turing.pro.br",5500,"4168ef73-db44-48e3-a36e-231d3ef4155a");
	.print("30");
	.wait(10000);
	.print("20");
	.wait(10000);
	.print("10");
	.wait(5000);
	.print("5");
	!disconnect.

+!disconnect <-
	.print("Encerrando conexão com a SkyNet");
	.disconnectCN;
	!connect.
	
+waiting_for_transfer[source(X)] <-
    .print("Transfer ready for ",X);
	.sendOut(X,tell,embeddedReady);
    -waiting_for_transfer[source(X)].
