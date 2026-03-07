/* ========================================================================== *
 *  __FILE__ - v0.1.0 - __DESC__                               - by __USER__  *
 * ========================================================================== *
 *                                                                            *
 *   A single-header library providing __DESC__.                              *
 *                                                                            *
 *   This file is part of the **ape.tools** collection:                       *
 *       https://github.com/numen-0/ape.tools                                 *
 *                                                                            *
 * - Usage ------------------------------------------------------------------ *
 *                                                                            *
 *   #define __MODULE___IMPLEMENTATION                                        *
 *   #include "__FILE__"                                                      *
 *                                                                            *
 *   > Note: Documentation is provided at the end of this file.               *
 *                                                                            *
 * - License ---------------------------------------------------------------- *
 *                                                                            *
 *   This software is licensed under the MIT License.                         *
 *   See the end of the file for detailed license information.                *
 *                                                                            *
 * ========================================================================== */

#ifndef __MODULE___H //////////////////////////////////////////////////////////
#    define __MODULE___H
#    ifdef __cplusplus
extern "C" {
#    endif

//* include *****************************************************************//

//* sanity check ************************************************************//

#    if 1
#        error "error"
#    endif // !1

//* macros ******************************************************************//

//* setup *******************************************************************//

#        ifndef __MODULE___LINK
#            define __MODULE___LINK static inline
#        endif // !__MODULE___LINK

//* types *******************************************************************//

//* interface ***************************************************************//

//***************************************************************************//

#    ifdef __MODULE___IMPLEMENTATION //////////////////////////////////////////

//* include *****************************************************************//

//* helper macros ***********************************************************//

#    ifdef __MODULE___DEBUG
#        ifndef __MODULE____ASSERT
#            include <assert.h>
#            define __MODULE____ASSERT(cond) assert(cond)
#        endif // !__MODULE____ASSERT
#    else
#        ifndef __MODULE____ASSERT
#            define __MODULE____ASSERT(cond) ((void)0)
#        endif // !__MODULE____ASSERT
#    endif     // !__MODULE___DEBUG

#    ifndef __MODULE____STATIC_ASSERT
#        define __MODULE____STATIC_ASSERT(cond, msg) \
            typedef char __MODULE_____STATIC_ASSERT_##msg[(cond) ? 1 : -1]
#    endif // !__MODULE____STATIC_ASSERT

#    ifndef __MODULE____TODO
#        include <assert.h>
#        define __MODULE____TODO() assert(false && "TODO")
#    endif // !__MODULE____TODO
#    ifndef __MODULE____UNREACHABLE
#        include <assert.h>
#        define __MODULE____UNREACHABLE() assert(false && "UNREACHABLE")
#    endif // !__MODULE____UNREACHABLE

#    ifndef __MODULE____ALLOC
#        include <stdlib.h>
#        define __MODULE____ALLOC(size) malloc(size)
#    endif // !__MODULE____ALLOC
#    ifndef __MODULE____FREE
#        include <stdlib.h>
#        define __MODULE____FREE(ptr) free(ptr)
#    endif // !__MODULE____FREE
#    ifndef __MODULE____REALLOC
#        include <stdlib.h>
#        define __MODULE____REALLOC(ptr, size) realloc(ptr, size)
#    endif // !__MODULE___REALLLOC

//* implementation **********************************************************//

//***************************************************************************//

#    endif // !__MODULE___IMPLEMENTATION //////////////////////////////////////

// CLEANUP ////////////////////////////////////////////////////////////////////
// !CLEANUP ///////////////////////////////////////////////////////////////////

#    ifdef __MODULE___STRIP_PREFIX ////////////////////////////////////////////

#    endif // !__MODULE___STRIP_PREFIX ////////////////////////////////////////

#    ifdef __cplusplus
}
#    endif
#endif // !__MODULE___H ///////////////////////////////////////////////////////

/* ========================================================================== *
 *  README.md                                                                 *
 * ========================================================================== *
 *                                                                            *
 *  # __MODULE__ - __DESC__                                                   *
 *                                                                            *
 *  A single-header, STB-style C/C++ library providing __DESC__.              *
 *                                                                            *
 *  ## Usage                                                                  *
 *                                                                            *
 *  Include in a C/C++ file that requires it:                                 *
 *                                                                            *
 *  ```c                                                                      *
 *  #define __MODULE___IMPLEMENTATION                                         *
 *  #include "__FILE__"                                                       *
 *  ```                                                                       *
 *                                                                            *
 *  ## Configuration Flags                                                    *
 *                                                                            *
 *  - `__MODULE___DEBUG`: enables `__MODULE___ASSERT`.                        *
 *    > def: undef                                                            *
 *  - `__MODULE____ALLOC(size)`: used to alloc internally.                    *
 *    > def: expands to `malloc(size)` from `<stdlib.h>`                      *
 *  - `__MODULE____FREE(ptr)`: used to free internal pointers.                *
 *    > def: expands to `free(ptr)` from `<stdlib.h>`                         *
 *  - `__MODULE___STRIP_PREFIX`: strips `__MODULE___` prefix from all macros. *
 *    > def: undef                                                            *
 *  - `__MODULE___LINK`: function linkage.                                    *
 *    > def: static inline                                                    *
 *  - `__MODULE___X`: enables x.                                              *
 *    > def: false                                                            *
 *                                                                            *
 *  ## API Overview                                                           *
 *                                                                            *
 *  | functions                  | desc                                    |  *
 *  |:---------------------------|:----------------------------------------|  *
 *  | `...`                      | ...                                     |  *
 *                                                                            *
 *  | globals                    | desc                                    |  *
 *  |:---------------------------|:----------------------------------------|  *
 *  | `...`                      | ...                                     |  *
 *                                                                            *
 *  | macros                     | desc                                    |  *
 *  |:---------------------------|:----------------------------------------|  *
 *  | `...`                      | ...                                     |  *
 *                                                                            *
 *  > Note: Symbols are prefixed with `__MODULE___`, unless                   *
 *  > `__MODULE___STRIP_PREFIX` is defined.                                   *
 *                                                                            *
 *  ## Example                                                                *
 *                                                                            *
 *  ```c                                                                      *
 *  // TODO                                                                   *
 *  ```                                                                       *
 *                                                                            *
 *  ## Notes                                                                  *
 *                                                                            *
 *  - ...                                                                     *
 *                                                                            *
 *  ## Change Log                                                             *
 *                                                                            *
 *  - `v0.1` (YYYY-MM-DD)                                                     *
 *    - Initial verison                                                       *
 *    - Implemented: <>                                                       *
 *                                                                            *
 *  - `v0.2` (planned)                                                        *
 *    - Add: <>                                                               *
 *    - Fix: <>                                                               *
 *                                                                            *
 * ========================================================================== */

/* ========================================================================== *
 *  LICENSE                                                                   *
 * ========================================================================== *
 *                                                                            *
 *  MIT License - Copyright (c) `__YEAR__` `__USER__`                         *
 *                                                                            *
 *  Permission is hereby granted, free of charge, to any person obtaining a   *
 *  copy of this software and associated documentation files (the             *
 *  "Software"), to deal in the Software without restriction, including       *
 *  without limitation the rights to use, copy, modify, merge, publish,       *
 *  distribute, sublicense, and/or sell copies of the Software, and to        *
 *  permit persons to whom the Software is furnished to do so, subject to     *
 *  the following conditions:                                                 *
 *                                                                            *
 *  The above copyright notice and this permission notice shall be included   *
 *  in all copies or substantial portions of the Software. THE SOFTWARE IS    *
 *  PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,       *
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS   *
 *  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       *
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER    *
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING   *
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER       *
 *  DEALINGS IN THE SOFTWARE.                                                 *
 *                                                                            *
 * ========================================================================== */
