# Number representation in digital electronics -- Part 1: Numerical bases

In this series of posts, we will look at the different ways that numbers are 
stored and processed in computers and other electronic devices. An important 
part of this is the use of *numeral systems*, such as the binary and hexadecimal 
numbers. Numeral systems (also called number systems) are methods and notation 
for expressing numbers in concrete form, including commonly used formats in the 
internal representation of numeric values in computer memory. 

### Numbers and numerals

> *"One could say that the difference between a number and its numeral is like 
the difference between a person and her name."* &mdash; Unknown source

Although we sometimes use the two terms interchangeably, there is a distinction 
between the concept of a number and a numeral. A *numeral* is a symbolic 
representation of a number. Numbers are abstract constructs, and numerals are 
the names and symbols which denote them. 

<img src="images/heh.png" style="width:200px" />

*In the ancient Egyptian hieroglyphic numeral system, the god <a href="https://en.wikipedia.org/wiki/Heh_(god)">Heh</a> symbolized one million.*

### Positional numeral systems

In our ordinary decimal system, known as the *Hindu-Arabic* numeral system, we 
write numbers as sequences, or strings, of *digits* -- a digit being one 
of the symbols 0, 1, 2, 3, 4, 5, 6, 7, 8 or 9. The decimal numbers are said to 
have a numerical base (or *radix*) ten. We can think of the base as the size of 
the alphabet from where we choose these individual digits. By constructing 
strings of length $$s$$ using characters from this alphabet, we are able to 
represent integers in the interval $$[0..10^s-1]$$. Conversely, any natural 
number can be decomposed into a [linear combination](http://mathworld.wolfram.com/LinearCombination.html) 
of integral powers of ten, multiplied by coefficients chosen in the range from 
zero to nine. For example, we can express the number 51,304 as the sum

$$ 
5 \cdot 10^4 + 1 \cdot 10^3 + 3 \cdot 10^2 + 0 \cdot 10^1 + 4 \cdot 10^0 = 51304
$$

Numeral systems of this kind are called *positional*. Each digit is assigned a 
weight, based on its position in the sequence. Another property, shared by all 
the numeral systems we will consider here, is that they have a 
*uniform base*, i.e., the same base is used in all positions of the string. 
Let $$n = d_q ... d_2 d_1 d_0$$ be an arbitrary natural number. In other words, 
$$d_i$$ is the digit at position $$i$$ in the decimal string representation of 
$$n$$. Then 

$$ 
n = d_q 10^q + \cdots + d_2 10^2 + d_1 10^1 + d_0. 
$$ 

More generally, for any radix $$b$$ we can find coefficients 
$$a_0, a_1, \dots, a_q$$, such that

$$
n = a_q b^q + \cdots + a_2 b^2 + a_1 b^1 + a_0 \text{ where } 0 \le a_i < b \text{ for all $ i $, and $ a_q \ne 0 $}.
$$

The length of this representation is $$q + 1$$, for some integer $$q \ge 0$$. 
To express $$q $$ in terms of $$n$$, first consider the real number $$x$$ such 
that $$b^x = n$$. Then $$x = \log_b n$$, and $$q$$ is the largest integer less 
than or equal to $$x$$. This mapping is known as the *floor* function and we 
write $$q = \lfloor\log_b n\rfloor$$. This means that if 

$$
n = \!\!\! \sum_{i=0}^{\lfloor\log_b n\rfloor} \!\!\! a_i b^i \; (0 \le a_i < b)
$$

then there is exactly one way in which we can choose these coefficients. 

### Counting the digits

In a program implementation -- even though we could use the logarithm directly 
to find the number of digits needed to represent a number -- a common approach 
is to simply divide the number by the radix, in a loop, until the quotient 
becomes zero. For example, in C:

    int num_digits (int n) {
        int i = 1;
        while ((n /= 10))
            ++i;
        return i;
    }

Note that this works for any base -- not only ten. Simply add a second 
parameter for the base, e.g., `(int n, int base)` and change the while 
statement to `while ((n /= base))`.

### The basis representation theorem

The fact that every natural number is uniquely identified in the way we have 
just described, is established by a result in number theory, known as the 
*basis representation theorem*. To prove this theorem, we first need the 
following lemma.

*Lemma 1.* The sum of a geometric series with $$n - 1$$ terms, common ratio 
$$r$$, and initial value $$1$$ is $$(r^n - 1)(r - 1)^{-1}$$. In symbols;

$$ 
\forall r \in \mathbb{R} \ (r \ne 1), n \in \mathbb{N} : (r - 1)(1 + r + r^2 + \dots + r^{n - 1}) = r^n - 1.
$$ 

*Proof.* Let $$S_n = 1 + r + r^2 + \dots + r^{n - 1}$$. Multiply by 
$$r$$ on both sides, so that

$$
  \begin{align}
    rS_n &= r(1 + r + r^2 + \dots + r^{n - 1}) \\
         &= r + r^2 + \dots + r^n.
  \end{align}
$$

Then $$ rS_n - S_n = S_n(r - 1) = (r + r^2 + \dots + r^n) - (1 + r + r^2 + \dots + r^{n - 1}) = r^n - 1. $$

We will now state the basis representation theorem in more formal terms.

*Theorem.* Given a base $$b$$, where $$b$$ is any integer greater than one, and 
a natural number $$n$$, there exists integers $$d_0, d_1, \dots, d_q \; (0 \le d_i < b)$$ 
such that $$n = d_q b^q + \cdots + d_2 b^2 + d_1 b^1 + d_0$$ and $$d_q \ne 0$$. 
We call this the representation of $$n$$ in base $$b$$. Furthermore, this 
representation is unique.

*Proof.* The proof has two parts. First we show that a representation exists 
for every $$n$$, and then that this representation must be unique.

#### Proof of existence

The argument is by induction on $$n$$ and the statement we would like to prove is 

$$
P(n) \equiv \forall b \in \mathbb{Z} \; (b > 1), \exists q \in \mathbb{Z} \; (q \ge 0), 
d_0, d_1, \dots, d_q \in \mathbb{Z} \; (0 \le d_i < b) \; \text{s.t.} \\
n = d_q b^q + \cdots + d_2 b^2 + d_1 b^1 + d_0 \; \text{and where} \; d_q \ne 0. 
$$

*Base case:* For $$n = 1$$, set $$q = 0$$ and $$d_0 = n = 1$$. Then, $$P(1)$$ holds.

*Induction hypothesis:* Assume $$P(k)$$ to be true.

*Inductive step:* We consider two cases.

* There exists at least one index $$i$$ such that $$d_i < b - 1$$. 
Let $$j$$ be the smallest such index. If $$j = 0$$, then $$d_0 + 1 \le b - 1$$ and therefore 
$$d_q b^q + \cdots + d_2 b^2 + d_1 b^1 + (d_0 + 1)$$ is a valid representation 
of $$k + 1$$. Otherwise, if $$j > 0$$, then

  $$
    \begin{align}
      k &= d_q b^q + \cdots + d_j b^j + (b - 1)b^{j - 1} + \cdots + (b - 1)b^2 + (b - 1)b + (b - 1) \\
        &= d_q b^q + \cdots + d_j b^j + (b - 1)(1 + b + b^2 + \cdots + b^{j - 1}) 
    \end{align}
  $$
  
  Then, by Lemma 1:

  $$
    \begin{align}
                   k &= d_q b^q + \cdots + d_j b^j + b^j - 1 \\
      \implies k + 1 &= d_q b^q + \cdots + d_j b^j + b^j \\
                     &= d_q b^q + \cdots + (d_j + 1) b^j 
    \end{align}
  $$

  Now, since we know that $$d_j + 1 \le b - 1$$, this is also a valid 
  representation of $$k + 1$$.

* In this case, $$d_i = b - 1$$ for all $$i$$. Then

  $$
    k = (b - 1)(1 + b + b^2 + \cdots + b^q).
  $$

  Once again, applying Lemma 1 tells us that

  $$
    \begin{align}
                   k &= b^{q + 1} - 1 \\
      \implies k + 1 &= b^{q + 1} 
    \end{align}
  $$

  and we have the representation we need. 
  
Since these cases are exhaustive, we find that $$P(k) \implies P(k + 1)$$, 
which proves existence for all $$n \ge 1$$. Note that it is also possible to 
represent $$0$$ in any base as itself.

#### Proof of uniqueness

To prove that $$d_q \dots d_2 d_1 d_0$$ is a unique representation of $$n$$ in 
base $$b$$, we will assume that there are two different representations of $$n$$, 
so that

$$
  \begin{align}
    n &= c_q b^q + \cdots + c_2 b^2 + c_1 b^1 + c_0 \\
      &= d_q b^q + \cdots + d_2 b^2 + d_1 b^1 + d_0 
  \end{align}
$$

and then try to derive a contradiction from this. 

If the above two representations differ, then there must be some smallest index 
$$j$$ for which $$c_j \ne d_j$$. We may then choose $$c_0, d_0, c_1, d_1, \dots$$ 
in such a way that $$c_j > d_j$$. For these two representations to denote the 
same number $$n$$, the difference of the two sums must be zero. We can therefore 
let $$\delta = \sum_{i = j + 1}^q (c_i - d_i)b^i$$, and write

$$
0 = \delta + (c_j - d_j)b^j = \displaystyle\frac{\delta}{b^j} + c_j - d_j = \!\!\! \sum_{i = j + 1}^q (c_i - d_i)b^{i - j} + c_j - d_j. 
$$

Then, since each term in $$\dfrac{\delta}{b^j}$$ is a factor of $$b$$, we find that

$$
0 = \frac{\delta}{b^j} + c_j - d_j \equiv c_j - d_j \; (\!\!\bmod b). 
$$

That is, $$c_j - d_j \in \{ zb \;|\; z \in \mathbb{Z} \}$$. 
But since $$0 \le c_j, d_j < b$$, it must be that $$c_j - d_j = 0$$, 
which contradicts our initial assumption that $$c_j \ne d_j$$. 
This concludes the proof.
$$\tag*{$\blacksquare$}$$

### Convert an integer to a string

To convert an integer to a string in some arbitrary base, we use an algorithm 
similar to the counting procedure described earlier. In this case, however, 
we need to pay attention to the remainder at each step, and write these values 
as characters to a buffer. 

We are really using [Euclid's division lemma](http://www.ask-math.com/euclids-division-lemma.html) 
here, which says that $$\forall n, m \in \mathbb{Z^+} \; \exists q, r \in \mathbb{Z} : n = mq + r,$$ 
where $$0 \le r \le m$$.

<img src="images/euclid.jpg">

As an example, here we show the process for converting the number 2958409950 
to base 16.

|------------+-------------+-----------+-------|
| Dividend   | Quotient    | Remainder | Digit |
| -----------|-------------|-----------|-------|
| 2958409950 | 184900621   | 14        | E     | 
|------------|-------------|-----------|-------|
| 184900621  | 11556288    | 13        | D     | 
|------------|-------------|-----------|-------|
| 11556288   | 722268      | 0         | 0     | 
|------------|-------------|-----------|-------|
| 722268     | 45141       | 12        | C     | 
|------------|-------------|-----------|-------|
| 45141      | 2821        | 5         | 5     | 
|------------|-------------|-----------|-------|
| 2821       | 176         | 5         | 5     | 
|------------|-------------|-----------|-------|
| 176        | 11          | 0         | 0     | 
|------------|-------------|-----------|-------|
| 11         | 0           | 11        | B     | 
|------------+-------------+-----------+-------|

In a program implementation, we need to reverse the result to get the digits 
in the expected order. This code is in x86 assembly (NASM syntax) for Linux.


    %define RADIX 16                   ; This can be any value between 2 and 16
    %define INPUT 2958409950

        section .data
    
    alphabet:    db "0123456789abcdef"
    
        section .bss
    
    output:      resb 33               ; Allocate the maximum number of digits 
                                       ; that a string can have, which is 32 in 
                                       ; base 2, plus an extra newline character
        section .text
    
        global _start
    _start:
        mov      ebx, RADIX
        mov      eax, INPUT
    
        lea      edi, [output]         
        lea      esi, [alphabet]
    
        push     edi                   ; Save output buffer address for later use
        xor      ecx, ecx              ; Use ecx as character counter
    
    loop:
        xor      edx, edx              ; Divide eax by radix. After executing
        div      ebx                   ; this instruction, edx will contain the 
                                       ; remainder 
    
        mov      dl, [esi + edx]       ; Write the character which corresponds to
        mov      [edi], dl             ; the remainder to buffer and then increment
        inc      edi                   ; address pointer
    
        inc      ecx                   ; Increment character counter
    
        or       eax, eax              ; Check if quotient is zero
        jnz      loop                  ; If not, repeat again
    
        pop      esi                   ; Restore output string address to esi
    
        mov BYTE [edi], 0x0a           ; Append a newline character
    
        inc      ecx
        push     ecx                   ; Store string length for later use
    
    reverse:                           ; Reverse the string
        dec      edi
        mov      al, [edi]
        mov      ah, [esi]
        mov      [edi], ah
        mov      [esi], al
        inc      esi
    
        cmp      esi, edi
        jl       reverse
    
        pop      edx                   ; Put character count in edx
    
        lea      ecx, [output] 
        mov      ebx, 1                ; file descriptor (stdout)
        mov      eax, 4                ; syscall 4 = sys_write
        int      0x80
    
        xor      ebx, ebx              ; exit status 0
        mov      eax, 1                ; syscall 1 = sys_exit
        int      0x80


*Tip:* Paste this code into an online code execution environment, 
for example <https://www.tutorialspoint.com/compile_assembly_online.php> to
see the result.

In the next part of this series, we will take a more detailed look at integer 
representation in the binary numeral system.
