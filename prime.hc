/*=============================================================================
*       prime.hc
*       timwking1
*       25-Apr 2025
*
*       Sieve of Eratosthenes in the HolyC language by Terry Davis
*       Implementation derived from provided pseudocode on: 
*       https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
*
=============================================================================*/
//Used for a variable array of booleans
class BitArray
{
  I64 size;
  Bool *bit;
};

/*=============================================================================
*   BitArray_Create
*       Allocates memory and returns a pointer to a bit array of given size
=============================================================================*/
BitArray *BitArray_Create(I64 size)
{
  BitArray *myArray = CAlloc(sizeof(BitArray));
  if (!myArray)
  {
    PrintErr("Memory allocation failed!\n");
    return NULL;
  }
  
  myArray->size = size;
  myArray->bit = CAlloc(size * sizeof(Bool));
  if (!myArray->bit)
  {
    PrintErr("Memory allocation for bits failed!\n");
    Free(myArray);
    return NULL;
  }

  //All bits (except 0 and 1) start as TRUE
  for (I64 i = 2; i < size; i++)
  {
    myArray->bit[i] = TRUE;
  }
  
  return myArray;
}

/*=============================================================================
*   BitArray_Destroy
*       Free an allocated bit array
=============================================================================*/
U0 BitArray_Destroy(BitArray *this)
{
  if (!this)
  {
    return;
  }

  if (this->bit)
  {
    Free(this->bit);
  }
  
  //No policemen here we are free to go
  Free(this);
}

/*=============================================================================
*   BitArray_Get
*       Return a value located at a given index in the bit array
=============================================================================*/
Bool BitArray_Get(BitArray *this, I64 index)
{
  //Validate parameters
  if (!this || index >= this->size)
  {
    return FALSE;
  }
  
  return this->bit[index];
}

/*=============================================================================
*   BitArray_Set
*       Set a value at a given index in the bit array
=============================================================================*/
U0 BitArray_Set(BitArray *this, I64 index, Bool value)
{
  //Validate parameters
  if (!this || index >= this->size)
  {
    return;
  }
  
  this->bit[index] = value;
}

/*=============================================================================
*   PrimeSieve
*       Calculates all prime numbers up to "n" using the Sieve of Eratosthenes
=============================================================================*/
U0 PrimeSieve(I64 n)
{
  //Set up a chosen bit array for the sieve
  BitArray *bitMap = BitArray_Create(n + 1);

  //It was revealed to me to begin the sieve at 2
  I64 sievePrime = 2;
  //The specified limit (sqrt of n)
  I64 q = Sqrt(n);
  
  for (I64 i = sievePrime; i <= q; i++)
  {
    if (BitArray_Get(bitMap, i) == TRUE)
    {
      //For j = i^2, i^2 + i, i^2 + 2i, etc...
      for (I64 j = i * i; j <= n; j += i)
      {
        BitArray_Set(bitMap, j, FALSE);
      }
    }
  }
  
  Print("\nCalculated primes...\n");
  for (I64 k = 2; k <= n; ++k)
  {
    Bool checkVal = BitArray_Get(bitMap, k);
    if (checkVal == TRUE)
    {
      //Print primes
      Print("%d ", k);
    }
  }
  
  BitArray_Destroy(bitMap);
}

/*=============================================================================
*   Main
*       Entry point for the program
=============================================================================*/
U0 Main()
{
  PrimeSieve(10000);
  Print("\n\nPress any key to continue...");
  GetChar();
}

Main;