%
% Project Euler. Solutions.
% (c) 2012 Mauro Taraborelli (MauroTaraborelli@gmail.com).
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%

\newpage

\section{Problem 3 -- Find the largest prime factor of a composite number}
\subsection{Description}
The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143?

\subsection{Solution}
We need a primes generator to find the prime factors of a number.
Instead of using a package from Hackage, I prefer to create a
generator from scratch.

I will use the sieve of Eratosthenes algorithm, as described by
\citet{o'neill09}.

The generator proposed in the article use a priority queue data structure.
A simple and effective priority queue, the |Pairing Heap|, is described
by \citet{wasserman10}.

Here is the code, adapted to the need of the sieve algorithm, and without
using the |Maybe| monad for min value extraction (for simplicity's sake).
\begin{code}
data PairingHeap a  =  Empty
                    |  PairNode a [PairingHeap a]
                       deriving (Show)

(+++)              :: Ord a => PairingHeap a -> PairingHeap a -> PairingHeap a
Empty  +++  heap   =  heap
heap   +++  Empty  =  heap
heap1@(PairNode x1 ts1)  +++  heap2@(PairNode x2 ts2)
    | x1 <= x2     =  PairNode x1 (heap2:ts1)
    | otherwise    =  PairNode x2 (heap1:ts2)

-- Construction
empty  :: PairingHeap a
empty  =  Empty

singleton    :: a -> PairingHeap a
singleton x  =  PairNode x []

-- Insertion
insert      :: Ord a => a -> PairingHeap a -> PairingHeap a
insert x q  =  (singleton x) +++ q

-- Priority Queue
minValue                 :: PairingHeap a ->  a
minValue Empty           =  error "Empty queue!"
minValue (PairNode x _)  =  x

deleteMin                  :: Ord a => PairingHeap a -> PairingHeap a
deleteMin Empty            =  error "Empty queue!"
deleteMin (PairNode _ ts)  =  meldChildren ts
    where
      meldChildren (t1:t2:ts)  =  t1 +++ t2 +++ meldChildren ts
      meldChildren [t]         =  t
      meldChildren []          =  Empty

deleteMinAndInsert      :: Ord a => a -> PairingHeap a -> PairingHeap a
deleteMinAndInsert x q  =  insert x $ deleteMin q
\end{code}

This |Pairing Heap| implementation doesn't support a key/value node.
So I define an |Iterator| data type to manage the key/value concept
necessary to the algorithm.
\begin{code}
-- Iterator
data Iterator = Iterator Integer [Integer]
    deriving (Show)

instance Eq Iterator where
    (Iterator x _) == (Iterator y _) = x == y

instance Ord Iterator where
    compare (Iterator x _) (Iterator y _) = compare x y
\end{code}

I even create a |Table| type alias and some utility functions to hide
the priority queue specific implementation from the algorithm.
\begin{code}
-- Table
type Table = PairingHeap Iterator

emptyTable  :: Table
emptyTable  =  empty

insertTable         :: Integer -> [Integer] -> Table -> Table
insertTable n is t  =  insert (Iterator n is) t

tableMinValue    :: Table -> Integer
tableMinValue t  =  n
    where
      (Iterator n _) = minValue t

tableMinValueIters    :: Table -> (Integer, [Integer])
tableMinValueIters t  =  (n, is)
    where
      (Iterator n is)  =  minValue t

tableDeleteMinAndInsert         :: Integer -> [Integer] -> Table -> Table
tableDeleteMinAndInsert n is t  =  deleteMinAndInsert (Iterator n is) t
\end{code}

With the priority queue completed, we can define the sieve algorithm:
\begin{itemize}
\item the |sieve| function filters the input sequence and find the primes incrementally
\item the |wheel| stream and the |spin| function allow to generate an input sequence
without the composites of the primes 2,3,5,7; this optimization makes the sieve seven
times faster than with a complete input sequence |[2..]|
\item the |primes| stream is created composing the sieve and the spinned wheel
\end{itemize}
\begin{code}
sieve         :: [Integer] -> [Integer]
sieve []      =  []
sieve (x:xs)  =  x : sieve' xs (insertprime x xs emptyTable)
    where
      insertprime p xs table  =  insertTable (p*p) (map (*p) xs) table
      sieve' [] table  =  []
      sieve' (x:xs) table
          | nextComposite <= x  =  sieve' xs (adjust table)
          | otherwise           =  x : sieve' xs (insertprime x xs table)
          where
            nextComposite  =  tableMinValue table
            adjust table
                | n <= x     =  adjust (tableDeleteMinAndInsert n' ns table)
                | otherwise  =  table
                where
                  (n, n':ns)  =  tableMinValueIters table

wheel2357 :: [Integer]
wheel2357 = 2:4:2:4:6:2:6:4:2:4:6:6:2:6:4:2:6:4:6:8:4:2:4:2:4
            :8:6:4:6:2:4:6:2:6:6:4:2:4:6:2:6:4:2:4:2:10:2:10:wheel2357

spin           :: [Integer] -> Integer -> [Integer]
spin (x:xs) n  =  n : spin xs (n+x)

primes  :: [Integer]
primes  =  2:3:5:7: sieve (spin wheel2357 11)
\end{code}

I use the primes generator to find the prime factors of an integer.
\begin{code}
primeFactors    :: Integer -> [Integer]
primeFactors n  =  factors n primes
    where
      factors 1 _                   =  []
      factors m (p:ps) | m < p*p    =  [m]
                       | r == 0     =  p : factors q (p:ps)
                       | otherwise  =  factors m ps
                       where (q,r)  =  quotRem m p
\end{code}

And, finally, the solution:
\begin{code}
solution = last $ primeFactors 600851475143
\end{code}
