program new_workshop2.aleo {

    // Struct to represent a vote information
    struct Vote {
        id: u32,
        description: field,
        likes: u32,
        dislikes: u32
    }

    const ADMIN: address = aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px;

    // ========== Storage Mappings ==========

    // Mapping of vote IDs to games
    mapping votes: u32 => Vote;

    // Mapping to track if a voter already voted on a game
    mapping has_voted: address => bool;

    // ========== Add Game ==========

    async transition add_id(
        public id: u32,
        public description: field
    ) -> (Future) {
        let caller: address = self.caller;

        return (finalize_add_id(id, description, caller));
    }

    async function finalize_add_id(
        id: u32,
        description: field,
        caller: address,
    ) {
        //Make sure only ADMIN address can call this
        assert(caller == ADMIN);

        // Ensure game doesn't already exist
        assert(!Mapping::contains(votes, id));
        
        let add: Vote = Mapping::get_or_use(votes, id, Vote {
            id: id,
            description: description,
            likes: 0u32,
            dislikes: 0u32
        });

        Mapping::set(votes, id, add);
    }



    // ========== DELETE Game ==========

    async transition delete_id(
        public id: u32,
        public description: field
    ) -> (Future) {
        let caller: address = self.caller;

        return (finalize_delete_id(id, description, caller));
    }

    async function finalize_delete_id(
        id: u32,
        description: field,
        caller: address,
    ) {
        //Make sure only ADMIN address can call this
        assert(caller == ADMIN);
        
        // Ensure vote doesn't already exist
        assert(!Mapping::contains(votes, id));
        
        let new_game: Vote = Mapping::get_or_use(votes, id, Vote {
            id: id,
            description: description,
            likes: 0u32,
            dislikes: 0u32
        });

        Mapping::remove(votes, id);
    }


    
    // ========== Like Vote ==========

    async transition like_id(public vote_id: u32) -> (Future) {
        let caller: address = self.caller;

        return (finalize_like_vote_id(vote_id, caller));
    }


    // ========== Finalize Voting (Like) ==========

    async function finalize_like_vote_id(
        vote_id: u32,
        voter: address,
    ) {
    
        // Ensure game exists
        assert(Mapping::contains(votes, vote_id));

        // Ensure voter hasn't voted on this game
        assert(!Mapping::get_or_use(has_voted, voter, false));

        let vote: Vote = Mapping::get_or_use(votes, vote_id, Vote {
            id: vote_id,
            description: 123field,
            likes: 0u32,
            dislikes: 0u32,       
        });

        //save updated game
        Mapping::set(votes, vote_id, Vote {
            id: vote.id,
            description: vote.description,
            likes: vote.likes + 1u32,
            dislikes: vote.dislikes
        });

        // Mark voter has voted
        Mapping::set(has_voted, voter, true);
    }



    // ========== Dislike Game ==========

    async transition dislike_game(public vote_id: u32) -> (Future) {
        let caller: address = self.caller;

        return (finalize_dislike_vote_game(vote_id, caller));
    }

    // ========== Finalize Voting (Dislike) ==========

    async function finalize_dislike_vote_game(
        vote_id: u32,
        voter: address
    ) {
        // Ensure vote exists
        assert(Mapping::contains(votes, vote_id));

        // Ensure voter hasn't voted on this vote id
        assert(!Mapping::get_or_use(has_voted, voter, false));

        let vote: Vote = Mapping::get_or_use(votes, vote_id, Vote {
            id: vote_id,
            description: 123field,
            likes: 0u32,
            dislikes: 0u32,       
        });

        //save updated game
        Mapping::set(votes, vote_id, Vote {
            id: vote.id,
            description: vote.description,
            likes: vote.likes,
            dislikes: vote.dislikes + 1u32
        });

        // Mark voter has voted
        Mapping::set(has_voted, voter, true);
    }

    // ========== View Functions ==========

    async transition get_vote(public vote_id: u32) -> Future {
        return finalize_get_vote(vote_id);
    }

    async function finalize_get_vote(vote_id: u32) {
        assert(Mapping::contains(votes, vote_id));
        let vote: Vote = Mapping::get(votes, vote_id);
    }

    async transition check_vote(public voter: address, public vote_id: u32) -> Future {
        return finalize_check_vote(voter, vote_id);
    }

    async function finalize_check_vote(voter: address, vote_id: u32) {
        let voted: bool = Mapping::get_or_use(has_voted, voter, false);
    }
}
