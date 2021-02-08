	.set noreorder
	.global start
	.ent    start

start:
#Store 0xa0010000 to register $29 and jump to it

    li      $29, 0xa0010000
    jr      $29
#    nop


   .end start
	.set reorder
