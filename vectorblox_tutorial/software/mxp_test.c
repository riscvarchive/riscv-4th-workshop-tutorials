#include "printf.h"
#include "vbx.h"
#include "main.h"

//For HDL simulation, run shorter tests, don't print full output
#define SIMULATION        0
#define TEST_SCRATCHPAD   1
#define TEST_INSTRUCTIONS 1
#define TEST_ACC          1
#define TEST_ACC_WORD     1
#define TEST_2D           1

#define TEST_INSTR_MUL     1
#define TEST_INSTR_MULHI   1
#define TEST_INSTR_MULFXP  1
#define TEST_INSTR_SHL     1
#define TEST_INSTR_SHR     1
#define TEST_INSTR_CMV_LTZ 1

#if SIMULATION
#define TEST_LENGTH 128 
#else //SIMULATION
#define TEST_LENGTH ((MXP_DATA_SPAN/4)/sizeof(vbx_uhalf_t))
#endif //SIMULATION

int mxp_test(){
	int i;
	unsigned int local_errors = 0;
	unsigned int errors = 0;
	unsigned int start_time;
	unsigned int end_time;

	//VectorBlox_MXP_Initialize();

	//vbx_uhalf_t *v_data = (vbx_uhalf_t *)MXP_SCRATCHPAD_BASE;
	vbx_uhalf_t *v_data = (vbx_uhalf_t *)vbx_sp_malloc( TEST_LENGTH * sizeof(vbx_uhalf_t) );

#if TEST_SCRATCHPAD
	local_errors = 0;
	printf("\r\nTesting MXP Scratchpad...\r\n");

	start_time = get_time();
	for(i = 0; i < TEST_LENGTH; i++){
		v_data[i] = ~i;
	}
	end_time = get_time();

	printf("Scratchpad writing took 0x%X cycles.\r\n", end_time-start_time);

	printf("Verifying...\r\n");
	for(i = 0; i < TEST_LENGTH; i++){
		if(v_data[i] != (vbx_uhalf_t)(~i)){
			printf("Error at 0x%X expected 0x%X got 0x%X\r\n", i, (vbx_uhalf_t)(~i), v_data[i]);
			local_errors++;
		}
	}
	printf("0x%X errors\r\n", local_errors);
	errors += local_errors;
#endif //TEST_SCRATCHPAD


#if TEST_INSTRUCTIONS
	local_errors = 0;
	printf("\r\nTesting MXP Instruction Dispatch...\r\n");

#if TEST_INSTR_MUL
	local_errors = 0;
	printf("\r\nTesting MUL...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VOR,  v_data, 0, NULL);
	vbx(VVHU, VMUL, v_data, v_data, v_data);
	vbx_sync();
	end_time = get_time();

	printf("MUL took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	for(i = 0; i < TEST_LENGTH; i++){
		vbx_uhalf_t emulated_result = i * i;
		if(v_data[i] != emulated_result){
			printf("Error at 0x");
			printf("%X", i);
			printf(" expected 0x");
			printf("%X", emulated_result);
			printf(" got 0x");
			printf("%X", v_data[i]);
			printf("\r\n");
			local_errors++;
		}
	}
	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_INSTR_MUL

#if TEST_INSTR_MULHI
	local_errors = 0;
	printf("\r\nTesting MULHI...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VMULHI, v_data, 0x5556, NULL);
	vbx_sync();
	end_time = get_time();

	printf("MULHI took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	for(i = 0; i < TEST_LENGTH; i++){
		vbx_uhalf_t emulated_result = ((vbx_uword_t)(i) * 0x5556) >> 16;
		if(v_data[i] != emulated_result){
			printf("Error at 0x");
			printf("%X", i);
			printf(" expected 0x");
			printf("%X", emulated_result);
			printf(" got 0x");
			printf("%X", v_data[i]);
			printf("\r\n");
			local_errors++;
		}
	}
	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_INSTR_MULHI

#if TEST_INSTR_MULFXP
	local_errors = 0;
	printf("\r\nTesting MULFXP...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEH, VMULFXP, (vbx_half_t *)v_data, 0xFFC0, NULL);
	vbx_sync();
	end_time = get_time();

	printf("MULFXP took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	for(i = 0; i < TEST_LENGTH; i++){
		vbx_uhalf_t emulated_result = ((vbx_uword_t)(i) * 0xFFFFFFC0) >> MXP_HALF_FXP_BITS;
		if(v_data[i] != emulated_result){
			printf("Error at 0x");
			printf("%X", i);
			printf(" expected 0x");
			printf("%X", emulated_result);
			printf(" got 0x");
			printf("%X", v_data[i]);
			printf("\r\n");
			local_errors++;
		}
	}
	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;

#endif //TEST_INSTR_MULFXP

#if TEST_INSTR_SHL
	local_errors = 0;
	printf("\r\nTesting SHL...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VSHL, v_data, 3, NULL);
	vbx_sync();
	end_time = get_time();

	printf("SHL took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	for(i = 0; i < TEST_LENGTH; i++){
		vbx_uhalf_t emulated_result = i << 3;
		if(v_data[i] != emulated_result){
			printf("Error at 0x");
			printf("%X", i);
			printf(" expected 0x");
			printf("%X", emulated_result);
			printf(" got 0x");
			printf("%X", v_data[i]);
			printf("\r\n");
			local_errors++;
		}
	}
	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_INSTR_SHL

#if TEST_INSTR_SHR
	local_errors = 0;
	printf("\r\nTesting SHR...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VSHR, v_data, 1, NULL);
	vbx_sync();
	end_time = get_time();

	printf("SHR took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	for(i = 0; i < TEST_LENGTH; i++){
		vbx_uhalf_t emulated_result = i >> 1;
		if(v_data[i] != emulated_result){
			printf("Error at 0x");
			printf("%X", i);
			printf(" expected 0x");
			printf("%X", emulated_result);
			printf(" got 0x");
			printf("%X", v_data[i]);
			printf("\r\n");
			local_errors++;
		}
	}
	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_INSTR_SHR

#if TEST_INSTR_CMV_LTZ
	local_errors = 0;
	printf("\r\nTesting CMV_LTZ...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VSUB,     v_data, 7, NULL);
	vbx(SVHU, VCMV_LTZ, v_data, 1, v_data);
	vbx_sync();
	end_time = get_time();

	printf("CMV_LTZ took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	for(i = 0; i < TEST_LENGTH; i++){
		vbx_uhalf_t emulated_result = ((7 - i) < 0) ? 1 : (7 - i);
		if(v_data[i] != emulated_result){
			printf("Error at 0x");
			printf("%X", i);
			printf(" expected 0x");
			printf("%X", emulated_result);
			printf(" got 0x");
			printf("%X", v_data[i]);
			printf("\r\n");
			local_errors++;
		}
	}
	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_INSTR_CMV_LTZ

#endif //TEST_INSTRUCTIONS


#if TEST_ACC
	local_errors = 0;
	printf("\r\nTesting ACC...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VSHL,      v_data, 13,     NULL);
	vbx_acc(VVHU, VADD, v_data, v_data, v_data);
	vbx_sync();
	end_time = get_time();

	printf("ACC took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	vbx_uhalf_t emulated_acc = 0;
	for(i = 0; i < TEST_LENGTH; i++){
		emulated_acc += (((i << 13) & 0xFFFF) + ((i << 13) & 0xFFFF)) & 0xFFFF;
	}
	if(v_data[0] != emulated_acc){
		printf("Error: expected 0x");
		printf("%X", emulated_acc);
		printf(" got 0x");
		printf("%X", v_data[0]);
		printf("\r\n");
		local_errors++;
	}

	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_ACC


#if TEST_ACC_WORD
	local_errors = 0;
	printf("\r\nTesting ACC_WORD...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VSHL,      v_data, 13,     NULL);
	vbx_acc(VVHWU, VADD, (vbx_uword_t *)v_data, v_data, v_data);
	vbx_sync();
	end_time = get_time();

	printf("ACC (word) took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	vbx_uword_t emulated_acc_word = 0;
	for(i = 0; i < TEST_LENGTH; i++){
		emulated_acc_word += (((i << 13) & 0xFFFF) + ((i << 13) & 0xFFFF)) & 0xFFFF;
	}
	vbx_uword_t *v_data_uword =	(vbx_uword_t *)(v_data);
	if(v_data_uword[0] != emulated_acc_word){
		printf("Error: expected 0x");
		printf("%lX", emulated_acc_word);
		printf(" got 0x");
		printf("%lX", v_data_uword[0]);
		printf("\r\n");
		local_errors++;
	}

	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_ACC_WORD


#if TEST_2D
	local_errors = 0;
	printf("\r\nTesting 2D...\r\n");

	start_time = get_time();
	vbx_set_vl(TEST_LENGTH);
	vbx(SEHU, VOR, v_data, 0, NULL);
	vbx_set_2D(TEST_LENGTH >> 2, 2*sizeof(vbx_uhalf_t), 3*sizeof(vbx_uhalf_t), 4*sizeof(vbx_uhalf_t));
	vbx_set_vl(1);
	vbx_2D(VVHU, VADD, v_data, v_data, v_data);
	vbx_sync();
	end_time = get_time();

	printf("2D took 0x");
	printf("%X", end_time-start_time);
	printf(" cycles.\r\n");

	for(i = 0; i < TEST_LENGTH >> 1; i++){
		vbx_uhalf_t emulated_result = (i & 1) ? i : (((i >> 1) * 3) + ((i >> 1) * 4));
		if(v_data[i] != emulated_result){
			printf("Error at 0x");
			printf("%X", i);
			printf(" expected 0x");
			printf("%X", emulated_result);
			printf(" got 0x");
			printf("%X", v_data[i]);
			printf("\r\n");
			local_errors++;
		}
	}
	printf("0x");
	printf("%X", local_errors);
	printf(" errors\r\n");
	errors += local_errors;
#endif //TEST_2D

	if(errors){
		printf("MXP test failed with 0x");
		printf("%X", errors);
		printf(" errors\r\n");
	} else {
		printf("MXP test passed!\r\n");
	}
	vbx_sp_free();

	return errors;
}
