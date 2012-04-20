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

\section{Problem 4 -- Find the largest palindrome made from the product of
two 3-digit numbers}
\subsection{Description}
A palindromic number reads the same both ways. The largest palindrome made
from the product of two 2-digit numbers is $9009=91\times99$.

Find the largest palindrome made from the product of two 3-digit numbers.

\subsection{Solution}
First of all, we need a function to verify if a number is palindrome.
With |isPalindrome| we simply convert the number to a string and compare
the string with its reverse.

Note that this function applies not only to numbers but to types
that implements the |Show| typeclass.

\begin{code}
isPalindrome    :: Show a => a -> Bool
isPalindrome x  =  x' == reverse x' where x' = show x
\end{code}

The simple solution to the problem uses Haskell list comprehension.
We enumerate all the products of two 3-digit numbers, filter the palindromes,
and extract the largest one.

\begin{code}
solution  :: Integer
solution  =  maximum  [x*y | x <- [100..999], y <- [100..999]
                      , isPalindrome (x*y)]
\end{code}

We can improve this solution, noting that the combination of the same terms
is considered two times, e.g. |x=123,y=456| and |x=456,y=123|.
We can filter the potential palindromes to only include the products
where the first term is more than or equal to the second term.

\begin{code}
solution'  :: Integer
solution'  =  maximum  [x*y | x <- [100..999], y <- [100..999]
                       , x >= y
                       , isPalindrome (x*y)]
\end{code}

Moreover, if we express the palindromes as a six terms multi-variable polynomial,
after some simplifications we find out that all the palindromes of 6-digit
are divisible by 11.
\begin{align*}
P&=100000x+10000y+1000z+100z+10y+x\\
P&=100001x+10010y+1100z\\
P&=11(9091x+910y+100z)
\end{align*}
We can filter the potential palindromes to only include the products
where at least one of the terms is divisible by 11.

\begin{code}
solution''  :: Integer
solution''  =  maximum  [x*y | x <- [100..999], y <- [100..999]
                        , x >= y
                        , x `mod` 11 == 0 || y `mod` 11 == 0
                        , isPalindrome (x*y)]
\end{code}

But, if we want to find an efficient solution, we have to change method.
Counting downwards from 999, we can find the solution earlier.

The |euler4| function recurses on a list of decreasing numerical terms
and, with the current term fixed as the first term, executes an inner recursion
using the rest of the list as the source for second terms.
The resulting product is verified to find out if it is a palindrome.
The result of the inner recursion is compared with the candidate palindrome
to choose the largest one.

The |euler4| function uses two optimization techniques:
\begin{itemize}
\item it exits from the inner recursion when it finds the first palindrome:
given that the first term of the product is fixed, it could not find a larger
palindrome
\item it exits from the outer recursion when the candidate palindrome is larger
than the square of the first term: given that the subsequent terms are smaller,
it could not find a larger palindrome
\end{itemize}

\begin{code}
euler4               :: (Ord a, Num a) => [a] -> a -> a
euler4 []         p  =  p
euler4 ns@(x:xs)  p  |  x*x < p    =  p
                     |  otherwise  =  euler4 xs $ max p $ maxPalindrome ns
                     where
                       maxPalindrome []        =  0
                       maxPalindrome (x':xs')  |  isPalindrome m  =  m
                                               |  otherwise       =  maxPalindrome xs'
                                               where
                                                 m = x * x'
\end{code}

We find the solution calling |euler4| with a list from 999 to 100 and with 0 as
the candidate palindrome.

\begin{code}
solution'''  :: Integer
solution'''  =  euler4 [999,998..100] 0
\end{code}

Note that |euler4| could be used to find the largest palindrome made from
the product of number with more than 3-digit, e.g. |euler4 [9999,9998..1000] 0|.
