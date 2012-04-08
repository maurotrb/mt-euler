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

%options ghci

\section{Problem 1 -- Add all the natural numbers below one thousand that are multiples of 3 or 5}

\subsection{Description}
If we list all the natural numbers below 10 that are multiples of 3 or 5,
we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.

\subsection{Solution}
The simple way is to go through all numbers from 1 to 999 and test whether
they are divisible by 3 or by 5. In Haskell you could use list comprehension:
\begin{code}
solution  =  sum [n | n <- [1..999], n `mod` 3 == 0 || n `mod` 5 == 0]
\end{code}
Evaluating |solution| you get \eval{solution}.

Reading the solution notes from the project's site, we can see that the solution
could even be expressed as:
\begin{code}
solution'  =  sum [n | n <- [1..999], n `mod` 3 == 0]  +
              sum [n | n <- [1..999], n `mod` 5 == 0]  -
              sum [n | n <- [1..999], n `mod` 15 == 0]
\end{code}

Noting that:
\begin{align*}
3+6+9+12+15+\dots{}+999&=3\times(1+2+3+4+\dots{}+333)\\
5+10+15+\dots{}+995&=5\times(1+2+....+199)
\end{align*}
where $333=\frac{999}{3}$ and $199=\frac{995}{5}$
but also $\frac{999}{5}$ rounded down to the nearest integer.

And that from the expression for arithmetic series \citep{wiki:arithmeticprogression}:
\[S_n=\frac{n}{2}(a_1+a_n)\]
we can derive that:
\[1+2+3+\dots{}+p=\frac{p}{2}(1+p)\]

We could write an efficient solution:
\begin{code}
target = 999

sumDivisibleBy n = n * p * (1 + p) `div` 2
    where
      p = target `div` n

solution'' = sumDivisibleBy 3 + sumDivisibleBy 5 - sumDivisibleBy 15
\end{code}
