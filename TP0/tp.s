	.file	1 "tp.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"Usage:\n"
	.ascii	"   \ttp0 -h\n"
	.ascii	"   \ttp0 -v\n"
	.ascii	"   \ttp0 [options]\n"
	.ascii	"Options:\n"
	.ascii	"   \t-v, --version    \tPrint version and quit.\n"
	.ascii	"   \t-h, --help       \tPrint help and quit.\n"
	.ascii	"   \t-i, --input      \tPath to input file.\n"
	.ascii	"   \t-o, --output     \tPath to output file.\n"
	.ascii	"Examples:\n"
	.ascii	"   \ttp0 -i ~/input -o ~/output\n\000"
	.text
	.align	2
	.globl	print_help
	.ent	print_help
print_help:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,$LC0
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	print_help
	.size	print_help, .-print_help
	.rdata
	.align	2
$LC1:
	.ascii	"tp0 [Guerrero - Schapira - De Rosa] 0.5\n\000"
	.text
	.align	2
	.globl	print_version
	.ent	print_version
print_version:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,$LC1
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	print_version
	.size	print_version, .-print_version
	.align	2
	.globl	strrev
	.ent	strrev
strrev:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	lw	$v0,56($fp)
	beq	$v0,$zero,$L32
	lw	$v0,56($fp)
	lb	$v0,0($v0)
	bne	$v0,$zero,$L31
$L32:
	lw	$v0,56($fp)
	sw	$v0,32($fp)
	b	$L30
$L31:
	lw	$v0,56($fp)
	sw	$v0,24($fp)
	lw	$a0,56($fp)
	la	$t9,strlen
	jal	$ra,$t9
	move	$v1,$v0
	lw	$v0,56($fp)
	addu	$v0,$v1,$v0
	addu	$v0,$v0,-1
	sw	$v0,28($fp)
$L33:
	lw	$v0,28($fp)
	lw	$v1,24($fp)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L36
	b	$L34
$L36:
	lw	$a1,24($fp)
	lw	$v0,24($fp)
	lw	$v1,28($fp)
	lbu	$a0,0($v0)
	lbu	$v0,0($v1)
	xor	$v0,$a0,$v0
	sb	$v0,0($a1)
	lw	$a1,28($fp)
	lw	$v0,28($fp)
	lw	$v1,24($fp)
	lbu	$a0,0($v0)
	lbu	$v0,0($v1)
	xor	$v0,$a0,$v0
	sb	$v0,0($a1)
	lw	$a1,24($fp)
	lw	$v0,24($fp)
	lw	$v1,28($fp)
	lbu	$a0,0($v0)
	lbu	$v0,0($v1)
	xor	$v0,$a0,$v0
	sb	$v0,0($a1)
	lw	$v0,24($fp)
	addu	$v0,$v0,1
	sw	$v0,24($fp)
	lw	$v0,28($fp)
	addu	$v0,$v0,-1
	sw	$v0,28($fp)
	b	$L33
$L34:
	lw	$v0,56($fp)
	sw	$v0,32($fp)
$L30:
	lw	$v0,32($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	strrev
	.size	strrev, .-strrev
	.align	2
	.globl	es_capicua
	.ent	es_capicua
es_capicua:
	.frame	$fp,272,$ra		# vars= 232, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,272
	.cprestore 16
	sw	$ra,264($sp)
	sw	$fp,260($sp)
	sw	$gp,256($sp)
	move	$fp,$sp
	sw	$a0,272($fp)
	lw	$a0,272($fp)
	la	$t9,strlen
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	slt	$v0,$v0,2
	beq	$v0,$zero,$L38
	sw	$zero,248($fp)
	b	$L37
$L38:
	addu	$v0,$fp,32
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,100			# 0x64
	la	$t9,memset
	jal	$ra,$t9
	sw	$zero,136($fp)
$L39:
	lw	$v0,136($fp)
	lw	$v1,24($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L42
	b	$L40
$L42:
	addu	$v1,$fp,32
	lw	$v0,136($fp)
	addu	$a0,$v1,$v0
	lw	$v1,272($fp)
	lw	$v0,136($fp)
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sll	$v1,$v0,1
	lw	$v0,_tolower_tab_
	addu	$v0,$v1,$v0
	addu	$v0,$v0,2
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,136($fp)
	addu	$v0,$v0,1
	sw	$v0,136($fp)
	b	$L39
$L40:
	addu	$v0,$fp,144
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,100			# 0x64
	la	$t9,memset
	jal	$ra,$t9
	addu	$v0,$fp,144
	addu	$v1,$fp,32
	move	$a0,$v0
	move	$a1,$v1
	la	$t9,strcpy
	jal	$ra,$t9
	addu	$v0,$fp,144
	move	$a0,$v0
	la	$t9,strrev
	jal	$ra,$t9
	addu	$v0,$fp,32
	addu	$v1,$fp,144
	move	$a0,$v0
	move	$a1,$v1
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L43
	addu	$v0,$fp,32
	move	$a0,$v0
	la	$t9,strlen
	jal	$ra,$t9
	sltu	$v0,$v0,2
	bne	$v0,$zero,$L43
	li	$v0,1			# 0x1
	sw	$v0,248($fp)
	b	$L37
$L43:
	sw	$zero,248($fp)
$L37:
	lw	$v0,248($fp)
	move	$sp,$fp
	lw	$ra,264($sp)
	lw	$fp,260($sp)
	addu	$sp,$sp,272
	j	$ra
	.end	es_capicua
	.size	es_capicua, .-es_capicua
	.align	2
	.globl	palabras_en_linea
	.ent	palabras_en_linea
palabras_en_linea:
	.frame	$fp,176,$ra		# vars= 136, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,176
	.cprestore 16
	sw	$ra,168($sp)
	sw	$fp,164($sp)
	sw	$gp,160($sp)
	move	$fp,$sp
	sw	$a0,176($fp)
	sw	$a1,180($fp)
	lw	$a0,176($fp)
	la	$t9,strlen
	jal	$ra,$t9
	sw	$v0,24($fp)
	sw	$zero,28($fp)
	sw	$zero,32($fp)
	sw	$zero,36($fp)
	sw	$zero,144($fp)
$L45:
	lw	$v0,144($fp)
	lw	$v1,24($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L48
	b	$L46
$L48:
	lw	$v1,176($fp)
	lw	$v0,144($fp)
	addu	$v0,$v1,$v0
	lb	$v0,0($v0)
	sw	$v0,152($fp)
	lw	$v0,152($fp)
	slt	$v0,$v0,48
	bne	$v0,$zero,$L49
	lw	$v0,152($fp)
	slt	$v0,$v0,58
	beq	$v0,$zero,$L49
	b	$L47
$L49:
	lw	$v0,152($fp)
	slt	$v0,$v0,65
	bne	$v0,$zero,$L52
	lw	$v0,152($fp)
	slt	$v0,$v0,91
	bne	$v0,$zero,$L47
$L52:
	lw	$v0,152($fp)
	slt	$v0,$v0,97
	bne	$v0,$zero,$L50
	lw	$v0,152($fp)
	slt	$v0,$v0,123
	bne	$v0,$zero,$L47
$L50:
	lw	$v1,152($fp)
	li	$v0,95			# 0x5f
	beq	$v1,$v0,$L47
	lw	$v1,152($fp)
	li	$v0,45			# 0x2d
	beq	$v1,$v0,$L47
	addu	$v0,$fp,40
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,100			# 0x64
	la	$t9,memset
	jal	$ra,$t9
	sw	$zero,148($fp)
$L55:
	lw	$v1,144($fp)
	lw	$v0,28($fp)
	subu	$v1,$v1,$v0
	lw	$v0,148($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L58
	b	$L56
$L58:
	addu	$v1,$fp,40
	lw	$v0,148($fp)
	addu	$a0,$v1,$v0
	lw	$v1,28($fp)
	lw	$v0,148($fp)
	addu	$v1,$v1,$v0
	lw	$v0,176($fp)
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,148($fp)
	addu	$v0,$v0,1
	sw	$v0,148($fp)
	b	$L55
$L56:
	addu	$v0,$fp,40
	move	$a0,$v0
	la	$t9,es_capicua
	jal	$ra,$t9
	beq	$v0,$zero,$L59
	sw	$zero,148($fp)
$L60:
	lw	$v1,144($fp)
	lw	$v0,28($fp)
	subu	$v1,$v1,$v0
	lw	$v0,148($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L63
	b	$L61
$L63:
	lw	$v1,180($fp)
	lw	$v0,32($fp)
	addu	$a0,$v1,$v0
	addu	$v1,$fp,40
	lw	$v0,148($fp)
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,32($fp)
	addu	$v0,$v0,1
	sw	$v0,32($fp)
	lw	$v0,148($fp)
	addu	$v0,$v0,1
	sw	$v0,148($fp)
	b	$L60
$L61:
	lw	$v1,180($fp)
	lw	$v0,32($fp)
	addu	$v1,$v1,$v0
	li	$v0,10			# 0xa
	sb	$v0,0($v1)
	lw	$v0,32($fp)
	addu	$v0,$v0,1
	sw	$v0,32($fp)
	lw	$v0,36($fp)
	addu	$v0,$v0,1
	sw	$v0,36($fp)
$L59:
	lw	$v0,144($fp)
	addu	$v0,$v0,1
	sw	$v0,28($fp)
$L47:
	lw	$v0,144($fp)
	addu	$v0,$v0,1
	sw	$v0,144($fp)
	b	$L45
$L46:
	lw	$v0,36($fp)
	move	$sp,$fp
	lw	$ra,168($sp)
	lw	$fp,164($sp)
	addu	$sp,$sp,176
	j	$ra
	.end	palabras_en_linea
	.size	palabras_en_linea, .-palabras_en_linea
	.rdata
	.align	2
$LC2:
	.ascii	"\n\000"
	.align	2
$LC3:
	.ascii	"salir\000"
	.text
	.align	2
	.globl	check_continuar
	.ent	check_continuar
check_continuar:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	lw	$a0,48($fp)
	la	$a1,$LC2
	la	$t9,strtok
	jal	$ra,$t9
	lw	$a0,48($fp)
	la	$a1,$LC3
	la	$t9,strcmp
	jal	$ra,$t9
	beq	$v0,$zero,$L65
	li	$v0,1			# 0x1
	sw	$v0,24($fp)
	b	$L64
$L65:
	sw	$zero,24($fp)
$L64:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	check_continuar
	.size	check_continuar, .-check_continuar
	.rdata
	.align	2
$LC4:
	.ascii	"help\000"
	.align	2
$LC5:
	.ascii	"version\000"
	.align	2
$LC6:
	.ascii	"input\000"
	.align	2
$LC7:
	.ascii	"output\000"
	.data
	.align	2
	.type	long_options.0, @object
	.size	long_options.0, 80
long_options.0:
	.word	$LC4
	.word	0
	.word	0
	.word	104
	.word	$LC5
	.word	0
	.word	0
	.word	118
	.word	$LC6
	.word	1
	.word	0
	.word	105
	.word	$LC7
	.word	1
	.word	0
	.word	111
	.word	0
	.word	0
	.word	0
	.word	0
	.rdata
	.align	2
$LC8:
	.ascii	"hvc:i:o:\000"
	.align	2
$LC9:
	.ascii	"option %s\000"
	.align	2
$LC10:
	.ascii	" with arg %s\000"
	.align	2
$LC11:
	.ascii	"non-option ARGV-elements: \000"
	.align	2
$LC12:
	.ascii	"%s \000"
	.align	2
$LC13:
	.ascii	"r\000"
	.align	2
$LC14:
	.ascii	"w\000"
	.align	2
$LC15:
	.ascii	"Ingrese la oracion a evaluar:\n\000"
	.align	2
$LC16:
	.ascii	"Palabras capicua:\n"
	.ascii	"%s\000"
	.align	2
$LC17:
	.ascii	"\302\277Desea salir?['salir' para cortar la ejecucion]\n"
	.ascii	"\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,4184,$ra		# vars= 4136, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,4184
	.cprestore 24
	sw	$ra,4176($sp)
	sw	$fp,4172($sp)
	sw	$gp,4168($sp)
	move	$fp,$sp
	sw	$a0,4184($fp)
	sw	$a1,4188($fp)
	sw	$zero,32($fp)
	sw	$zero,36($fp)
$L67:
	sw	$zero,44($fp)
	addu	$v0,$fp,44
	sw	$v0,16($sp)
	lw	$a0,4184($fp)
	lw	$a1,4188($fp)
	la	$a2,$LC8
	la	$a3,long_options.0
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,40($fp)
	lw	$v1,40($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L70
	b	$L68
$L70:
	lw	$v0,40($fp)
	sw	$v0,4160($fp)
	li	$v0,105			# 0x69
	lw	$v1,4160($fp)
	beq	$v1,$v0,$L77
	lw	$v1,4160($fp)
	slt	$v0,$v1,106
	beq	$v0,$zero,$L82
	li	$v0,104			# 0x68
	lw	$v1,4160($fp)
	beq	$v1,$v0,$L75
	lw	$v0,4160($fp)
	beq	$v0,$zero,$L72
	li	$v0,63			# 0x3f
	lw	$v1,4160($fp)
	beq	$v1,$v0,$L67
	b	$L80
$L82:
	li	$v0,111			# 0x6f
	lw	$v1,4160($fp)
	beq	$v1,$v0,$L78
	li	$v0,118			# 0x76
	lw	$v1,4160($fp)
	beq	$v1,$v0,$L76
	b	$L80
$L72:
	lw	$v0,44($fp)
	sll	$v1,$v0,4
	la	$v0,long_options.0+8
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	beq	$v0,$zero,$L73
	b	$L67
$L73:
	lw	$v0,44($fp)
	sll	$v1,$v0,4
	la	$v0,long_options.0
	addu	$v0,$v1,$v0
	la	$a0,$LC9
	lw	$a1,0($v0)
	la	$t9,printf
	jal	$ra,$t9
	lw	$v0,optarg
	beq	$v0,$zero,$L74
	la	$a0,$LC10
	lw	$a1,optarg
	la	$t9,printf
	jal	$ra,$t9
$L74:
	la	$a0,$LC2
	la	$t9,printf
	jal	$ra,$t9
	b	$L67
$L75:
	la	$t9,print_help
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L76:
	la	$t9,print_version
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L77:
	lw	$v0,optarg
	sw	$v0,36($fp)
	b	$L67
$L78:
	lw	$v0,optarg
	sw	$v0,32($fp)
	b	$L67
$L80:
	la	$t9,abort
	jal	$ra,$t9
$L68:
	lw	$v0,optind
	lw	$v1,4184($fp)
	slt	$v0,$v0,$v1
	beq	$v0,$zero,$L83
	la	$a0,$LC11
	la	$t9,printf
	jal	$ra,$t9
$L84:
	lw	$v0,optind
	lw	$v1,4184($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L86
	b	$L85
$L86:
	la	$a1,optind
	lw	$v1,0($a1)
	move	$v0,$v1
	sll	$a0,$v0,2
	lw	$v0,4188($fp)
	addu	$v0,$a0,$v0
	addu	$v1,$v1,1
	sw	$v1,0($a1)
	la	$a0,$LC12
	lw	$a1,0($v0)
	la	$t9,printf
	jal	$ra,$t9
	b	$L84
$L85:
	li	$a0,10			# 0xa
	la	$a1,__sF+88
	la	$t9,__sputc
	jal	$ra,$t9
$L83:
	lw	$a0,36($fp)
	la	$a1,$LC13
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,2096($fp)
	lw	$a0,32($fp)
	la	$a1,$LC14
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,2100($fp)
	lw	$v0,2096($fp)
	bne	$v0,$zero,$L87
	li	$v0,1			# 0x1
	sb	$v0,2104($fp)
$L88:
	lbu	$v0,2104($fp)
	bne	$v0,$zero,$L90
	b	$L93
$L90:
	addu	$v0,$fp,1072
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,1024			# 0x400
	la	$t9,memset
	jal	$ra,$t9
	addu	$v0,$fp,48
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,1024			# 0x400
	la	$t9,memset
	jal	$ra,$t9
	la	$a0,$LC15
	la	$t9,printf
	jal	$ra,$t9
	addu	$v0,$fp,48
	move	$a0,$v0
	li	$a1,1024			# 0x400
	la	$a2,__sF
	la	$t9,fgets
	jal	$ra,$t9
	addu	$v0,$fp,48
	addu	$v1,$fp,1072
	move	$a0,$v0
	move	$a1,$v1
	la	$t9,palabras_en_linea
	jal	$ra,$t9
	lw	$v0,2100($fp)
	bne	$v0,$zero,$L91
	addu	$v0,$fp,1072
	la	$a0,$LC16
	move	$a1,$v0
	la	$t9,printf
	jal	$ra,$t9
	b	$L92
$L91:
	addu	$v0,$fp,1072
	move	$a0,$v0
	lw	$a1,2100($fp)
	la	$t9,fputs
	jal	$ra,$t9
$L92:
	la	$a0,$LC17
	la	$t9,printf
	jal	$ra,$t9
	addu	$v0,$fp,48
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,1024			# 0x400
	la	$t9,memset
	jal	$ra,$t9
	addu	$v0,$fp,48
	move	$a0,$v0
	li	$a1,1024			# 0x400
	la	$a2,__sF
	la	$t9,fgets
	jal	$ra,$t9
	addu	$v0,$fp,48
	move	$a0,$v0
	la	$t9,check_continuar
	jal	$ra,$t9
	sb	$v0,2104($fp)
	b	$L88
$L87:
	addu	$v0,$fp,1072
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,1024			# 0x400
	la	$t9,memset
	jal	$ra,$t9
$L94:
	lw	$v0,2096($fp)
	lhu	$v0,12($v0)
	srl	$v0,$v0,5
	andi	$v0,$v0,0x1
	beq	$v0,$zero,$L96
	b	$L95
$L96:
	addu	$v0,$fp,2112
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,1024			# 0x400
	la	$t9,memset
	jal	$ra,$t9
	addu	$v0,$fp,2112
	move	$a0,$v0
	li	$a1,1024			# 0x400
	lw	$a2,2096($fp)
	la	$t9,fgets
	jal	$ra,$t9
	lb	$v0,2112($fp)
	bne	$v0,$zero,$L97
	b	$L94
$L97:
	addu	$v0,$fp,3136
	move	$a0,$v0
	move	$a1,$zero
	li	$a2,1024			# 0x400
	la	$t9,memset
	jal	$ra,$t9
	addu	$v0,$fp,2112
	addu	$v1,$fp,3136
	move	$a0,$v0
	move	$a1,$v1
	la	$t9,palabras_en_linea
	jal	$ra,$t9
	addu	$v0,$fp,1072
	addu	$v1,$fp,3136
	move	$a0,$v0
	move	$a1,$v1
	la	$t9,strcat
	jal	$ra,$t9
	b	$L94
$L95:
	lw	$a0,2096($fp)
	la	$t9,fclose
	jal	$ra,$t9
	lw	$v0,2100($fp)
	bne	$v0,$zero,$L98
	addu	$v0,$fp,1072
	la	$a0,$LC16
	move	$a1,$v0
	la	$t9,printf
	jal	$ra,$t9
	b	$L93
$L98:
	addu	$v0,$fp,1072
	move	$a0,$v0
	lw	$a1,2100($fp)
	la	$t9,fputs
	jal	$ra,$t9
$L93:
	lw	$v0,2100($fp)
	beq	$v0,$zero,$L100
	lw	$a0,2100($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L100:
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,4176($sp)
	lw	$fp,4172($sp)
	addu	$sp,$sp,4184
	j	$ra
	.end	main
	.size	main, .-main
	.align	2
	.ent	__sputc
__sputc:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	sw	$a1,52($fp)
	lw	$v1,52($fp)
	lw	$v0,52($fp)
	lw	$v0,8($v0)
	addu	$v0,$v0,-1
	sw	$v0,8($v1)
	bgez	$v0,$L3
	lw	$v0,52($fp)
	lw	$v1,52($fp)
	lw	$a0,8($v0)
	lw	$v0,24($v1)
	slt	$v0,$a0,$v0
	bne	$v0,$zero,$L2
	lb	$v1,48($fp)
	li	$v0,10			# 0xa
	bne	$v1,$v0,$L3
	b	$L2
$L3:
	lw	$a1,52($fp)
	lw	$v1,0($a1)
	lbu	$a0,48($fp)
	move	$v0,$v1
	sb	$a0,0($v0)
	andi	$v0,$a0,0x00ff
	addu	$v1,$v1,1
	sw	$v1,0($a1)
	sw	$v0,24($fp)
	b	$L1
$L2:
	lw	$a0,48($fp)
	lw	$a1,52($fp)
	la	$t9,__swbuf
	jal	$ra,$t9
	sw	$v0,24($fp)
$L1:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	__sputc
	.size	__sputc, .-__sputc
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
