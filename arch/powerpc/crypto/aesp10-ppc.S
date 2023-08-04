#include <asm/ppc_asm.h>
.machine	"any"

.abiversion	2
.text

.align	7
	rcon	:
.byte	0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01
.byte	0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x1b
.byte	0x0c,0x0f,0x0e,0x0d,0x0c,0x0f,0x0e,0x0d,0x0c,0x0f,0x0e,0x0d,0x0c,0x0f,0x0e,0x0d
.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
.Lconsts	:
	mflr	0
	bcl	20,31,$+4
	mflr	6
	addi	6,6,-0x48
	mtlr	0
	blr	
.long	0
.byte	0,12,0x14,0,0,0,0,0
.byte	65,69,83,32,102,111,114,32,80,111,119,101,114,73,83,65,32,50,46,48,55,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
.align	2

_GLOBAL(aes_p10_set_encrypt_key)
.Lset_encrypt_key	:
	mflr	11
	std	11,16(1)

	li	6,-1
	cmpldi	3,0
	beq-	.Lenc_key_abort
	cmpldi	5,0
	beq-	.Lenc_key_abort
	li	6,-2
	cmpwi	4,128
	blt-	.Lenc_key_abort
	cmpwi	4,256
	bgt-	.Lenc_key_abort
	andi.	0,4,0x3f
	bne-	.Lenc_key_abort

	lis	0,0xfff0
	li	12,-1
	or	0,0,0

	bl	.Lconsts
	mtlr	11

	neg	9,3
	lvx	1,0,3
	addi	3,3,15
	lvsr	3,0,9
	li	8,0x20
	cmpwi	4,192
	lvx	2,0,3
	vspltisb	5,0x0f
	lvx	4,0,6
	vxor	3,3,5
	lvx	5,8,6
	addi	6,6,0x10
	vperm	1,1,2,3
	li	7,8
	vxor	0,0,0
	mtctr	7

	lvsl	8,0,5
	vspltisb	9,-1
	lvx	10,0,5
	vperm	9,9,0,8

	blt	.Loop128
	addi	3,3,8
	beq	.L192
	addi	3,3,8
	b	.L256

.align	4
.Loop128	:
	vperm	3,1,1,5
	vsldoi	6,0,1,12
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	.long	0x10632509
	stvx	7,0,5
	addi	5,5,16

	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vadduwm	4,4,4
	vxor	1,1,3
	bdnz	.Loop128

	lvx	4,0,6

	vperm	3,1,1,5
	vsldoi	6,0,1,12
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	.long	0x10632509
	stvx	7,0,5
	addi	5,5,16

	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vadduwm	4,4,4
	vxor	1,1,3

	vperm	3,1,1,5
	vsldoi	6,0,1,12
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	.long	0x10632509
	stvx	7,0,5
	addi	5,5,16

	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vxor	1,1,3
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	stvx	7,0,5

	addi	3,5,15
	addi	5,5,0x50

	li	8,10
	b	.Ldone

.align	4
.L192	:
	lvx	6,0,3
	li	7,4
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	stvx	7,0,5
	addi	5,5,16
	vperm	2,2,6,3
	vspltisb	3,8
	mtctr	7
	vsububm	5,5,3

.Loop192	:
	vperm	3,2,2,5
	vsldoi	6,0,1,12
	.long	0x10632509

	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6

	vsldoi	7,0,2,8
	vspltw	6,1,3
	vxor	6,6,2
	vsldoi	2,0,2,12
	vadduwm	4,4,4
	vxor	2,2,6
	vxor	1,1,3
	vxor	2,2,3
	vsldoi	7,7,1,8

	vperm	3,2,2,5
	vsldoi	6,0,1,12
	vperm	11,7,7,8
	vsel	7,10,11,9
	vor	10,11,11
	.long	0x10632509
	stvx	7,0,5
	addi	5,5,16

	vsldoi	7,1,2,8
	vxor	1,1,6
	vsldoi	6,0,6,12
	vperm	11,7,7,8
	vsel	7,10,11,9
	vor	10,11,11
	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	stvx	7,0,5
	addi	5,5,16

	vspltw	6,1,3
	vxor	6,6,2
	vsldoi	2,0,2,12
	vadduwm	4,4,4
	vxor	2,2,6
	vxor	1,1,3
	vxor	2,2,3
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	stvx	7,0,5
	addi	3,5,15
	addi	5,5,16
	bdnz	.Loop192

	li	8,12
	addi	5,5,0x20
	b	.Ldone

.align	4
.L256	:
	lvx	6,0,3
	li	7,7
	li	8,14
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	stvx	7,0,5
	addi	5,5,16
	vperm	2,2,6,3
	mtctr	7

.Loop256	:
	vperm	3,2,2,5
	vsldoi	6,0,1,12
	vperm	11,2,2,8
	vsel	7,10,11,9
	vor	10,11,11
	.long	0x10632509
	stvx	7,0,5
	addi	5,5,16

	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vsldoi	6,0,6,12
	vxor	1,1,6
	vadduwm	4,4,4
	vxor	1,1,3
	vperm	11,1,1,8
	vsel	7,10,11,9
	vor	10,11,11
	stvx	7,0,5
	addi	3,5,15
	addi	5,5,16
	bdz	.Ldone

	vspltw	3,1,3
	vsldoi	6,0,2,12
	.long	0x106305C8

	vxor	2,2,6
	vsldoi	6,0,6,12
	vxor	2,2,6
	vsldoi	6,0,6,12
	vxor	2,2,6

	vxor	2,2,3
	b	.Loop256

.align	4
.Ldone	:
	lvx	2,0,3
	vsel	2,10,2,9
	stvx	2,0,3
	li	6,0
	or	12,12,12
	stw	8,0(5)

.Lenc_key_abort	:
	mr	3,6
	blr	
.long	0
.byte	0,12,0x14,1,0,0,3,0
.long	0
.size	aes_p10_set_encrypt_key,.-aes_p10_set_encrypt_key

_GLOBAL(aes_p10_set_decrypt_key)
	stdu	1,-64(1)
	mflr	10
	std	10,64+16(1)
	bl	.Lset_encrypt_key
	mtlr	10

	cmpwi	3,0
	bne-	.Ldec_key_abort

	slwi	7,8,4
	subi	3,5,240
	srwi	8,8,1
	add	5,3,7
	mtctr	8

.Ldeckey	:
	lwz	0, 0(3)
	lwz	6, 4(3)
	lwz	7, 8(3)
	lwz	8, 12(3)
	addi	3,3,16
	lwz	9, 0(5)
	lwz	10,4(5)
	lwz	11,8(5)
	lwz	12,12(5)
	stw	0, 0(5)
	stw	6, 4(5)
	stw	7, 8(5)
	stw	8, 12(5)
	subi	5,5,16
	stw	9, -16(3)
	stw	10,-12(3)
	stw	11,-8(3)
	stw	12,-4(3)
	bdnz	.Ldeckey

	xor	3,3,3
.Ldec_key_abort	:
	addi	1,1,64
	blr	
.long	0
.byte	0,12,4,1,0x80,0,3,0
.long	0
.size	aes_p10_set_decrypt_key,.-aes_p10_set_decrypt_key
_GLOBAL(aes_p10_encrypt)
	lwz	6,240(5)
	lis	0,0xfc00
	li	12,-1
	li	7,15
	or	0,0,0

	lvx	0,0,3
	neg	11,4
	lvx	1,7,3
	lvsl	2,0,3
	vspltisb	4,0x0f
	lvsr	3,0,11
	vxor	2,2,4
	li	7,16
	vperm	0,0,1,2
	lvx	1,0,5
	lvsr	5,0,5
	srwi	6,6,1
	lvx	2,7,5
	addi	7,7,16
	subi	6,6,1
	vperm	1,2,1,5

	vxor	0,0,1
	lvx	1,7,5
	addi	7,7,16
	mtctr	6

.Loop_enc	:
	vperm	2,1,2,5
	.long	0x10001508
	lvx	2,7,5
	addi	7,7,16
	vperm	1,2,1,5
	.long	0x10000D08
	lvx	1,7,5
	addi	7,7,16
	bdnz	.Loop_enc

	vperm	2,1,2,5
	.long	0x10001508
	lvx	2,7,5
	vperm	1,2,1,5
	.long	0x10000D09

	vspltisb	2,-1
	vxor	1,1,1
	li	7,15
	vperm	2,2,1,3
	vxor	3,3,4
	lvx	1,0,4
	vperm	0,0,0,3
	vsel	1,1,0,2
	lvx	4,7,4
	stvx	1,0,4
	vsel	0,0,4,2
	stvx	0,7,4

	or	12,12,12
	blr	
.long	0
.byte	0,12,0x14,0,0,0,3,0
.long	0
.size	aes_p10_encrypt,.-aes_p10_encrypt
_GLOBAL(aes_p10_decrypt)
	lwz	6,240(5)
	lis	0,0xfc00
	li	12,-1
	li	7,15
	or	0,0,0

	lvx	0,0,3
	neg	11,4
	lvx	1,7,3
	lvsl	2,0,3
	vspltisb	4,0x0f
	lvsr	3,0,11
	vxor	2,2,4
	li	7,16
	vperm	0,0,1,2
	lvx	1,0,5
	lvsr	5,0,5
	srwi	6,6,1
	lvx	2,7,5
	addi	7,7,16
	subi	6,6,1
	vperm	1,2,1,5

	vxor	0,0,1
	lvx	1,7,5
	addi	7,7,16
	mtctr	6

.Loop_dec	:
	vperm	2,1,2,5
	.long	0x10001548
	lvx	2,7,5
	addi	7,7,16
	vperm	1,2,1,5
	.long	0x10000D48
	lvx	1,7,5
	addi	7,7,16
	bdnz	.Loop_dec

	vperm	2,1,2,5
	.long	0x10001548
	lvx	2,7,5
	vperm	1,2,1,5
	.long	0x10000D49

	vspltisb	2,-1
	vxor	1,1,1
	li	7,15
	vperm	2,2,1,3
	vxor	3,3,4
	lvx	1,0,4
	vperm	0,0,0,3
	vsel	1,1,0,2
	lvx	4,7,4
	stvx	1,0,4
	vsel	0,0,4,2
	stvx	0,7,4

	or	12,12,12
	blr	
.long	0
.byte	0,12,0x14,0,0,0,3,0
.long	0
.size	aes_p10_decrypt,.-aes_p10_decrypt
