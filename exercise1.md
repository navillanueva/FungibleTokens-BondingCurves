**Exercise 1**

_Why was ERC1363 introduced, and what issues are there with ERC777?_

Both ERC777 and ERC1363 attempt to solve many of the limitations around the UX that surge with the ERC20 (due to its simplicity).

The main features they were aiming to resolve were:

- double transaction in ERC20 ⇒ users having to approve an allowance for a token and then having to send it
- token spam ⇒ users receiving unwanted spam ERC20s into their wallets
- token contract misplacement ⇒ users accidentally sending tokens to contracts that don’t have payable functions, hence these tokens remaining locked in such contract forever (a good example is the USDC contract which 100k $ that can never be unlocked)

In different ways but addressing the same issues, ERC777 and ERC1363 both resolve these issues by:

- creating a hook that unifies the approve/transfer workflow into one single transaction
- allowing contracts and addresses to whitelist what tokens they can send/receive

The main issues behind ERC777, and hence why ERC1363 was created, is that it relies on ERC1820 and the transfer and receive functions hand over execution control to verify whether the token being traded is ERC777 compliant, therefore creating a reentrancy vulnerability without it being clear since the naming for the functions used is `tokensToSend`

This flaw in the naming convention created a general dislike for ERC777 since possibly new or unexperienced developers could easily create vulnerable code without implicitly knowing it.

This is why ERC1363 was created, implementing similar functionality to that of ERC777, but improving the naming of the functions, it follows that of ERC20, but adding the AndCall to the end, so developers and users can easily and readily see that the logic they will be using is handing over execution control (in this case to ERC165)

However, ERC1363 is still **reentrant** thus reentrancy guards must be always used.
