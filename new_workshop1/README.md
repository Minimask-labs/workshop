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
curl -L https://get.leo-lang.org/install | sh
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
