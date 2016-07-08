//VBXCOPYRIGHTTAG

/**
 * @file
 * @defgroup VBX_API VBX API
 * @brief VBX API
 *
 * @ingroup VBXapi
 */
/**@{*/

#ifndef __VBX_API_H
#define __VBX_API_H
#include "vbx_macros.h"
#include "vbx_extern.h"

#ifdef __cplusplus
extern "C" {
#endif
// -----------------------------------------------------------
// DEVELOPER API SECTION
// -----------------------------------------------------------

void        _vbx_init( vbx_mxp_t *this_mxp );

// Scratchpad APIs

vbx_void_t *vbx_sp_malloc_nodebug(                      size_t num_bytes );
vbx_void_t *vbx_sp_malloc_debug( int LINE, const char *FNAME, size_t num_bytes );

void        vbx_sp_free_debug( int LINE, const char *FNAME );
void        vbx_sp_free_nodebug();

vbx_void_t *vbx_sp_get();

void        vbx_sp_set_nodebug(                      vbx_void_t *new_sp );
void        vbx_sp_set_debug( int LINE, const char *FNAME, vbx_void_t *new_sp );

int         vbx_sp_getused();
int         vbx_sp_getfree();

__attribute__((always_inline)) static inline
void vbx_mxp_is_initialized(vbx_mxp_t* this_mxp){
	//make sure that the mxp has been initialized
	assert( this_mxp && this_mxp->spstack);
}

/** Push current scratchpad address to stack
 *
 * Use with @ref vbx_sp_pop for partial freeing of scratchpad memory
 */

__attribute__((always_inline)) static inline void vbx_sp_push()
{
	// do it, but do not print pretty error messages
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();
	vbx_mxp_is_initialized(this_mxp);
#if (!VBX_STATIC_ALLOCATE_SP_STACK)
	if(this_mxp->spstack_top == this_mxp->spstack_max ) {
		void vbx_sp_push_realloc();
		vbx_sp_push_realloc();
	}
#endif
	this_mxp->spstack[ this_mxp->spstack_top++ ] = this_mxp->sp;
	assert(this_mxp->spstack_top < this_mxp->spstack_max);
}
/** Pop current scratchpad address to stack
 *
 * Use with @ref vbx_sp_push for partial freeing of scratchpad memory
 */
__attribute__((always_inline)) static inline void vbx_sp_pop()
{
	// do it, but do not print pretty error messages
	vbx_mxp_t *this_mxp = VBX_GET_THIS_MXP();
	vbx_mxp_is_initialized(this_mxp);
	assert(this_mxp->spstack_top > 0);
	this_mxp->sp = this_mxp->spstack[ --this_mxp->spstack_top ];

}


void   vbx_sp_pop_debug( int LINE, const char *FNAME );


// Memory APIs

/* void       *vbx_shared_alloca_nodebug( size_t num_bytes, void *p ); */
/* void       *vbx_shared_alloca_debug( int LINE,const  char *FNAME, size_t num_bytes, void *p ); */
/* void       *vbx_shared_malloc( size_t num_bytes ); */
/* void        vbx_shared_free( void *shared_ptr ); */

// MXP device APIs
vbx_mxp_t  *vbx_open( const char* name );

#ifdef __cplusplus
}
#endif

#endif // __VBX_API_H
/**@}*/
