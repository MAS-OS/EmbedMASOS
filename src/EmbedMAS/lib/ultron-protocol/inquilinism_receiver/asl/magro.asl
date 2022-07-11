/* Initial beliefs and rules */
ready[source(self)].

/* Initial goals */
!start.

/* Plans */
+!start : (souRemetente & energizing) <- .print("Transporter ready!"); -energizing[source(scott)]; +ready; !start.
+!start : (souRemetente & ready) <- -souRemetente; .moveOut("788b2b22-baa6-4c61-b1bb-01cff1f5f878",inquilinism).
+!start : souRemetente <- .print("Magro to Scotty..."); .sendOut("788b2b22-baa6-4c61-b1bb-01cff1f5f878",tell,beam_us_up_scotty); .wait(2000); !start.
+!start <- .print("Computer, Commander James T. Kirk, Enterprise's Captain"); .wait(2000); !start.

