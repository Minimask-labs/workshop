// This example demonstrates an example of a minting and transferring a token in Leo.
// How to transfer tokens from your aleo account to another account

//import credits.aleo
import credits.aleo;

program new_workshop1.aleo {
    // The `Token` record datatype.
    record Token {
        // The token owner.
        owner: address,
        // The token amount.
        amount: u64,
    }

    // The `mint` function initializes a new record with the
    // specified number of tokens assigned to the specified receiver.
    transition mint(owner: address, amount: u64) -> Token {
        return Token {
            owner: owner,
            amount: amount,
        };
    }

    // The `transfer` function sends the specified number of tokens
    // to the receiver from the provided token record.
    transition transfer(token: Token, to: address, amount: u64) -> (Token, Token) {

        // Checks the given token record has sufficient balance.
        // This `sub` operation is safe, and the proof will fail
        // if an overflow occurs.
        // `difference` holds the change amount to be returned to sender.
        let difference: u64 = token.amount - amount;

        // Produce a token record with the change amount for the sender.
        let remaining: Token = Token {
            owner: token.owner,
            amount: difference,
        };

        // Produce a token record for the specified receiver.
        let transferred: Token = Token {
            owner: to,
            amount: amount,
        };

        // Output the sender's change record and the receiver's record.
        return (remaining, transferred);
    }

    //Aleo transfer token 
    async transition transfer_aleo(to: address, amount: u64) -> (Future) {
        // caller address
        let caller: address = self.caller;
        
        // Create futures for the transfers
        let transfer_future: Future = credits.aleo/transfer_public(to, amount);
        return finalize_transfer_aleo(transfer_future);
    }
    
    async function finalize_transfer_aleo(
        transfer_future: Future
    ) {
        // Complete both transfers
        transfer_future.await();
}

}
