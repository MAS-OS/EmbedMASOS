// Agent agent01 in project hello.mas2j

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello world.");
	.wait(1000);
	!start.

