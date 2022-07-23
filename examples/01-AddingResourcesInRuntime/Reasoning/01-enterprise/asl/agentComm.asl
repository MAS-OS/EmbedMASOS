/* Initial beliefs and rules */
abroad(no)[source(self)].
embeddedAgent("4168ef73-db44-48e3-a36e-231d3ef4155a")[source(self)].

/* Initial goals */
!start.

/* Plans */
+!start : abroad(yes) <- .print("Connecting to ContextNet Server!"); .connectCN("skynet.turing.pro.br",5500,"5cb7c831-4279-41f5-9353-ee23beda9bc7"); !send.
+!start : abroad(no) <- .print("Nothing to do!").
+!send : (abroad(yes) & embeddedReady[source(X)]) <- .print("Transporter ready!"); -embeddedReady[source(X)]; +ready; !send.
+!send : (abroad(yes) & (ready & embeddedAgent(UUID))) <- -ready; -abroad(yes); +abroad(no); .moveOut(UUID,inquilinism).
+!send : (abroad(yes) & embeddedAgent(UUID)) <- .print("AgentComm trying communication with EmbeddedAgent..."); .sendOut(UUID,tell,waiting_for_transfer); .wait(2500); !send.

