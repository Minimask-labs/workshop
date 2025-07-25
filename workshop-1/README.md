# Introduction
This workshop introduces Aleo and Leo programming by demonstrating how to mint and transfer tokens on the Aleo blockchain.

### We will cover:

- How to define a Token record.

- How to mint new tokens.

- How to transfer tokens between accounts.

- How to interact with Aleo Credits (the native token).

### This guide is designed for beginners in Leo programming.

# Installation Guide
Before running the program, you need to set up the Leo environment.

Step 1: Install Leo
Install Rust (required for Leo):

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
Install Leo CLI:

```bash
go to 
https://github.com/ProvableHQ/leo.git
```

Step 2: Create a New Leo Project

```bash
leo new workshop_token
cd workshop_token
```

Step 3: Replace main.leo with the Workshop Code

Copy the provided code into main.leo.

Step 4: Build & Run

```bash
leo build
leo run mint <address> <amount>
```

# Understanding the Program

### Token Record Structure
```bash
record Token {
    owner: address,  // Who owns the token
    amount: u64,    // How many tokens they have
}
```
- A record is like a wallet that stores token ownership and balance.

- u64 means an unsigned 64-bit integer (no negative numbers)

### mint Function - Creating New Tokens
```bash
transition mint(owner: address, amount: u64) -> Token {
    return Token {
        owner: owner,
        amount: amount,
    };
}
```
- Purpose: Creates a new Token record assigned to owner with amount.

- Usage:

```bash
leo run mint aleo1xyz... 100u64
(Mints 100 tokens for aleo1xyz...)
```

### transfer Function - Sending Tokens
```bash
transition transfer(token: Token, to: address, amount: u64) -> (Token, Token) {
    let difference: u64 = token.amount - amount;
    let remaining: Token = Token { owner: token.owner, amount: difference };
    let transferred: Token = Token { owner: to, amount: amount };
    return (remaining, transferred);
}
```
- Purpose: Splits a Token into two:

- remaining: Leftover tokens for the sender.

- transferred: Sent to to address.

- Checks: Automatically fails if amount > token.amount (prevents overdraft).

- Usage:

```bash
leo run transfer <input_token> <receiver_address> <amount>
```

### transfer_aleo Function - Sending Aleo Credits
```bash
async transition transfer_aleo(to: address, amount: u64) -> (Future) {
    let caller: address = self.caller;
    let transfer_future: Future = credits.aleo/transfer_public(to, amount);
    return finalize_transfer_aleo(transfer_future);
}
```
- Purpose: Transfers Aleo’s native token (credits) to another address.

### How it works:

- Gets the caller (sender).

- Calls Aleo’s built-in transfer_public (moves credits).

- Returns a Future (asynchronous operation).

- Usage:

```bash
leo run transfer_aleo <receiver_address> <amount>
```

# Step-by-Step Execution
## Example Workflow

- Mint 100 tokens for Alice:

```bash
leo run mint aleo1alice... 100u64
Output:

{
  owner: aleo1alice...,
  amount: 100u64
}
```
- Transfer 30 tokens to Bob:

```bash
leo run transfer <Alice_token> aleo1bob... 30u64
Output:

{
  remaining: { owner: aleo1alice..., amount: 70u64 },
  transferred: { owner: aleo1bob..., amount: 30u64 }
}
```
- Send 5 Aleo Credits to Bob:

```bash
leo run transfer_aleo aleo1bob... 5u64
```

# Conclusion
## What We Learned

## ✅ How to mint custom tokens in Leo.

## ✅ How to transfer tokens securely.

## ✅ How to interact with Aleo Credits.
