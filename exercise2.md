**Exercise 2**

Why does the SafeERC20 program exist and when should it be used?

The SafeERC20 library exists in the Ethereum ecosystem to address issues related to the ERC20 standard, particularly the lack of a return value in the transfer and transferFrom functions that could indicate the success or failure of these operations. This can lead to confusion and potential loss of funds if a contract assumes a transfer was successful when it actually failed.

The ERC20 token standard is a common framework for implementing tokens on the Ethereum blockchain. However, early implementations of this standard sometimes omitted return values for the transfer and transferFrom methods, which should return a boolean indicating success. This oversight could cause contracts interacting with these tokens to mistakenly believe a transfer was successful when it was not, especially if the contract strictly follows the standard's guidelines that expect these return values.

To mitigate this risk, the SafeERC20 library wraps these ERC20 functions and adds checks to ensure that the operations were successful. It uses low-level calls in combination with require statements to enforce that the return value is true. If the ERC20 token does not return a value (due to being an older contract), the SafeERC20 library will still attempt to verify the success of the operation through other means, such as ensuring that the token balance has changed accordingly.

The SafeERC20 library should be used whenever a developer is interacting with ERC20 tokens from within smart contracts, particularly when calling the transfer and transferFrom functions. Using SafeERC20 ensures that your contract will behave correctly and safely, even if the ERC20 tokens you're interacting with have implemented the standard in an inconsistent manner. This is crucial for contracts that manage funds on behalf of users, as it helps prevent accidental losses due to failed token transfers.
