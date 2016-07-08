/* VECTORBLOX MXP SOFTWARE DEVELOPMENT KIT
 *
 * Copyright (C) 2012-2016 VectorBlox Computing Inc., Vancouver, British Columbia, Canada.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *     * Neither the name of VectorBlox Computing Inc. nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * This agreement shall be governed in all respects by the laws of the Province
 * of British Columbia and by the laws of Canada.
 *
 * This file is part of the VectorBlox MXP Software Development Kit.
 *
 */

/**@file*/

#include "vbx.h"
#include "printf.h"
//#include "vbx_port.h"
#include <stdlib.h>



// --------------------------------------------------------
// System-wide global variables

vbx_mxp_t *vbx_mxp_ptr;

// --------------------------------------------------------
// Local variables
#define sp_stack      (this_mxp->spstack)
#define sp_stack_top  (this_mxp->spstack_top)
#define sp_stack_max  (this_mxp->spstack_max)

// --------------------------------------------------------
// System-wide initialization

/** Initialize MXP processor
 *
 * param[out] this_mxp
 */
#define STACKSIZE  (VBX_STATIC_ALLOCATE_SP_STACK ?  VBX_STATIC_SP_STACK_SIZE:64)
static uint32_t *spstack[STACKSIZE];

void _vbx_init( vbx_mxp_t *this_mxp )
{
	// initialize the sp stack
	// max = depth of scratchpad
	this_mxp->spstack_max = STACKSIZE;
	this_mxp->spstack_top = 0;

	if( !this_mxp->spstack ) {
		int spstack_size = this_mxp->spstack_max * sizeof(vbx_void_t *);
		this_mxp->spstack = (vbx_void_t **)spstack;
		if ( !this_mxp->spstack ) {
			VBX_PRINTF("ERROR: failed to malloc %d bytes for spstack.\n", spstack_size);
			VBX_FATAL(__LINE__, __FILE__, -1);
		}
	}

	// Must be set before any MXP instructions can be issued!
	vbx_mxp_ptr = this_mxp;

	this_mxp->init = 1;
}


// --------------------------------------------------------
// Allocate and deallocate scratchpad memory.

vbx_void_t *vbx_sp_malloc( size_t num_bytes )
{
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();

	// check for valid argument values
	if( !this_mxp  ||  num_bytes==0 )
		return NULL;

	// add padding and allocate
	// pad to scratchpad width to reduce occurrence of false hazards
	size_t padded = VBX_PAD_UP( num_bytes, this_mxp->scratchpad_alignment_bytes );
	vbx_void_t *old_sp = this_mxp->sp;
	this_mxp->sp += padded;

	// scratchpad full
	if( this_mxp->sp > this_mxp->scratchpad_end ) {
		this_mxp->sp = old_sp;
		return NULL;
	}

	// success
	return old_sp;
}

void vbx_sp_free()
{
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();
	if( this_mxp )  {
		this_mxp->sp = this_mxp->scratchpad_addr;
		this_mxp->spstack_top = 0;
	}
}


// --------------------------------------------------------
// Scratchpad manipulation routines
int vbx_sp_getused()
{
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();
	int used = 0;
	if( this_mxp )
		used = (int)(this_mxp->sp - this_mxp->scratchpad_addr);
	return used;
}

int vbx_sp_getfree()
{
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();
	int free = 0;
	if( this_mxp )
		free = (int)(this_mxp->scratchpad_end - this_mxp->sp);
	return free;
}

vbx_void_t *vbx_sp_get()
{
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();
	return this_mxp ? this_mxp->sp : NULL;
}

void vbx_sp_set( vbx_void_t *new_sp )
{
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();
	if( this_mxp
	           && (this_mxp->scratchpad_addr <= new_sp && new_sp <= this_mxp->scratchpad_end)
	           && VBX_IS_ALIGNED(new_sp, 4) ) {
		this_mxp->sp = new_sp;
	}
}



size_t __old_vl__=0;
