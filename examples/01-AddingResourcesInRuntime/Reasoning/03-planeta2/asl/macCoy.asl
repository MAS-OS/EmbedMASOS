// Agent agenteRemetente in project smaRemetente
scott("07ba9e4a-d539-4a0e-8c14-4ac336476858").
abroad(yes).

/* Initial beliefs and rules */
!conf.

/* Initial goals */

/* Plans */
+!conf : abroad(yes) <-
	.connectCN("skynet.turing.pro.br",5500,"41ff1712-b2f0-416d-8232-fef834651e99");
	!start.

+!conf : abroad(no)  <-
	.print("aboard=no").
	
+!start : abroad(yes) & energizing[source(X)] <-
    .print("Transporter ready!");
    -energizing[source(X)];
    +ready;
    !start.

+!start : abroad(yes) & ready & scott(UUID) <-
    -ready;
	-abroad(yes);
	+abroad(no);
	.moveOut(UUID, inquilinism).
    
+!start : abroad(yes) & scott(UUID)<-
	.print("MacCoy to Scotty...");
	.sendOut(UUID, tell, beam_us_up_scotty);
	.wait(2500);
	!start.
	
+!start : abroad(no) <-
    .print("Computer, MacCoy").

-!start <-
	.print("nada").
