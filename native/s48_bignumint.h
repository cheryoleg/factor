/* -*-C-*-

$Id$

Copyright (c) 1989-1992 Massachusetts Institute of Technology

This material was developed by the Scheme project at the Massachusetts
Institute of Technology, Department of Electrical Engineering and
Computer Science.  Permission to copy and modify this software, to
redistribute either the original software or a modified version, and
to use this software for any purpose is granted, subject to the
following restrictions and understandings.

1. Any copy made of this software must include this copyright notice
in full.

2. Users of this software agree to make their best efforts (a) to
return to the MIT Scheme project any improvements or extensions that
they make, so that these may be included in future releases; and (b)
to inform MIT of noteworthy uses of this software.

3. All materials developed as a consequence of the use of this
software shall duly acknowledge such use, in accordance with the usual
standards of acknowledging credit in academic research.

4. MIT has made no warrantee or representation that the operation of
this software will be error-free, and MIT is under no obligation to
provide any services, by way of maintenance, update, or otherwise.

5. In conjunction with products arising from the use of this material,
there shall be no use of the name of the Massachusetts Institute of
Technology nor of any adaptation thereof in any advertising,
promotional, or sales literature without prior written consent from
MIT in each case. */

/* Internal Interface to Bignum Code */
#undef BIGNUM_ZERO_P
#undef BIGNUM_NEGATIVE_P

/* The memory model is based on the following definitions, and on the
   definition of the type `bignum_type'.  The only other special
   definition is `CHAR_BIT', which is defined in the Ansi C header
   file "limits.h". */

typedef CELL bignum_digit_type;
typedef CELL bignum_length_type;

/* BIGNUM_ALLOCATE allocates a (length + 1)-element array of
   `bignum_digit_type'; deallocation is the responsibility of the
   user (in Factor, the garbage collector handles this). */
#define BIGNUM_ALLOCATE(length_in_digits) \
	allot_array(BIGNUM_TYPE,length_in_digits + 1)

/* BIGNUM_TO_POINTER casts a bignum object to a digit array pointer. */
#define BIGNUM_TO_POINTER(bignum) ((CELL*)AREF(bignum,0))

/* BIGNUM_REDUCE_LENGTH allows the memory system to reclaim some
   space when a bignum's length is reduced from its original value. */
#define BIGNUM_REDUCE_LENGTH(target, source, length)            \
     target = shrink_array(source, length + 1)
extern ARRAY* shrink_array(ARRAY* array, CELL capacity);

/* BIGNUM_DEALLOCATE is called when disposing of bignums which are
   created as intermediate temporaries; Scheme doesn't need this. */
#define BIGNUM_DEALLOCATE(bignum)

/* If BIGNUM_FORCE_NEW_RESULTS is defined, all bignum-valued operations
   return freshly-allocated results.  This is useful for some kinds of
   memory deallocation strategies. */
/* #define BIGNUM_FORCE_NEW_RESULTS */

/* BIGNUM_EXCEPTION is invoked to handle assertion violations. */
#define BIGNUM_EXCEPTION abort


#define BIGNUM_DIGIT_LENGTH (((sizeof (bignum_digit_type)) * CHAR_BIT) - 2)
#define BIGNUM_HALF_DIGIT_LENGTH (BIGNUM_DIGIT_LENGTH / 2)
#define BIGNUM_RADIX (((unsigned long) 1) << BIGNUM_DIGIT_LENGTH)
#define BIGNUM_RADIX_ROOT (((unsigned long) 1) << BIGNUM_HALF_DIGIT_LENGTH)
#define BIGNUM_DIGIT_MASK	 (BIGNUM_RADIX - 1)
#define BIGNUM_HALF_DIGIT_MASK	 (BIGNUM_RADIX_ROOT - 1)

#define BIGNUM_START_PTR(bignum)					\
  ((BIGNUM_TO_POINTER (bignum)) + 1)

#define BIGNUM_LENGTH(bignum) ((bignum)->capacity - 1)

#define BIGNUM_NEGATIVE_P(bignum) (get(AREF(bignum,0)) != 0)
#define BIGNUM_SET_NEGATIVE_P(bignum,neg) put(AREF(bignum,0),neg)

#define BIGNUM_ZERO_P(bignum)						\
  ((BIGNUM_LENGTH (bignum)) == 0)

#define BIGNUM_REF(bignum, index)					\
  (* ((BIGNUM_START_PTR (bignum)) + (index)))

#ifdef BIGNUM_FORCE_NEW_RESULTS
#define BIGNUM_MAYBE_COPY bignum_copy
#else
#define BIGNUM_MAYBE_COPY(bignum) bignum
#endif

/* These definitions are here to facilitate caching of the constants
   0, 1, and -1. */
#define BIGNUM_ZERO() bignum_zero
#define BIGNUM_ONE(neg_p) \
   (neg_p ? bignum_neg_one : bignum_pos_one)

#define BIGNUM_ONE_P(bignum,negative_p) ((bignum) == BIGNUM_ONE(negative_p))

#define HD_LOW(digit) ((digit) & BIGNUM_HALF_DIGIT_MASK)
#define HD_HIGH(digit) ((digit) >> BIGNUM_HALF_DIGIT_LENGTH)
#define HD_CONS(high, low) (((high) << BIGNUM_HALF_DIGIT_LENGTH) | (low))

#define BIGNUM_BITS_TO_DIGITS(n)					\
  (((n) + (BIGNUM_DIGIT_LENGTH - 1)) / BIGNUM_DIGIT_LENGTH)

#define BIGNUM_DIGITS_FOR_LONG						\
  (BIGNUM_BITS_TO_DIGITS ((sizeof (long)) * CHAR_BIT))

#ifndef BIGNUM_DISABLE_ASSERTION_CHECKS

#define BIGNUM_ASSERT(expression)					\
{									\
  if (! (expression))							\
    BIGNUM_EXCEPTION ();						\
}

#endif /* not BIGNUM_DISABLE_ASSERTION_CHECKS */
