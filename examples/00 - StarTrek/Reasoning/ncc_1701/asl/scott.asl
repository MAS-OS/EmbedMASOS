/* Initial beliefs and rules */
souDestinatario.

/* Initial goals */
!start.

/* Plans */

+!start : true <-
	.print("Computer, Commander Montgomery Scott, Chief Engineering Office");
	.connectCN("skynet.turing.pro.br",5500,"07ba9e4a-d539-4a0e-8c14-4ac336476858").

+beam_us_up_scotty <-
    .print("Transporter ready!");
    .sendOut("41ff1712-b2f0-416d-8232-fef834651e77",tell,energizing);
    -beam_us_up_scotty[source(self)].

