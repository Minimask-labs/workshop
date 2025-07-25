# Leo Programming Workshop: Voting System Explained
This guide breaks down a voting system implemented in Leo, explaining each component and function in detail. The program allows:

- Admins to add/remove vote items

- Users to like/dislike items

- Prevention of double-voting

- Viewing vote results

### Table of Contents
1. Data Structures

2. Core Functions

- Adding/Removing Vote Items

- Voting Mechanisms (Like/Dislike)

-  View Functions

3. Security & Access Control

4. How to Use This Program

# Data Structures
### Vote Struct
```bash
struct Vote {
    id: u32,            // Unique identifier
    description: field,  // Text description (stored as field)
    likes: u32,         // Number of likes
    dislikes: u32       // Number of dislikes
}
```
- Stores all information about a votable item.

### Mappings (Storage)
```bash
mapping votes: u32 => Vote;             // Tracks all votes by ID
mapping has_voted: address => bool;     // Prevents double-voting
```
- votes: Database of all vote items.

- has_voted: Records which addresses have voted.

### Admin Constant
```bash
const ADMIN: address = aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px; // Hardcoded admin address
```
- Only this address can add/remove vote items.

# Core Functions
### Adding a New Vote Item
### Transition (User Call)
```bash
async transition add_id(public id: u32, public description: field) -> Future {
    let caller = self.caller;
    return finalize_add_id(id, description, caller);
}
```
- Inputs: id (unique number), description (text)

- Process: Passes data to finalizer after checking caller.

### Finalizer (Logic)
```bash
async function finalize_add_id(id: u32, description: field, caller: address) {
    assert(caller == ADMIN); // Admin check
    assert(!Mapping::contains(votes, id)); // No duplicates
    
    let new_vote = Vote { id, description, likes: 0, dislikes: 0 };
    Mapping::set(votes, id, new_vote); // Store in mapping
}
```
- Checks:

1. Caller is admin

2. ID doesn't exist

- Action: Creates new vote entry.

### Removing a Vote Item
```bash
async transition delete_id(public id: u32) -> Future {
    let caller = self.caller;
    return finalize_delete_id(id, caller);
}
```
- Similar to add_id, but removes entries.

### Finalizer
```bash 
async function finalize_delete_id(id: u32, caller: address) {
    assert(caller == ADMIN);
    assert(Mapping::contains(votes, id)); // Must exist
    
    Mapping::remove(votes, id); // Delete entry
}
```
### Voting Mechanisms [Like a Vote Item]
```bash
async transition like_id(public vote_id: u32) -> Future {
    let caller = self.caller;
    return finalize_like_vote_id(vote_id, caller);
}

async function finalize_like_vote_id(vote_id: u32, voter: address) {
    assert(Mapping::contains(votes, vote_id));
    assert(!Mapping::get_or_use(has_voted, voter, false));
    
    let vote = Mapping::get(votes, vote_id);
    Mapping::set(votes, vote_id, Vote {
        ...vote,
        likes: vote.likes + 1 // Increment likes
    });
    
    Mapping::set(has_voted, voter, true); // Mark as voted
}
```
- Checks:

1. Vote exists

2. Voter hasn't already voted

- Action: Increments like count.

#### Dislike a Vote Item
- Mirrors the like function but increments dislikes.

### View Functions [Get Vote Details]
```bash
async transition get_vote(public vote_id: u32) -> Future {
    return finalize_get_vote(vote_id);
}

async function finalize_get_vote(vote_id: u32) {
    assert(Mapping::contains(votes, vote_id));
    let vote = Mapping::get(votes, vote_id);
    // Returns vote data to caller
}
```
### Check Voting Status
```bash
async transition check_vote(voter: address, vote_id: u32) -> Future {
    return finalize_check_vote(voter, vote_id);
}

async function finalize_check_vote(voter: address, vote_id: u32) {
    let voted = Mapping::get_or_use(has_voted, voter, false);
    // Returns true/false if address voted
}
```

# Security & Access Control
1. Admin-Only Actions:

- add_id, delete_id use assert(caller == ADMIN)

2. Anti-Cheating:

- has_voted mapping prevents duplicate votes

3. Input Validation:

- Checks for existing/non-existing IDs before operations

# How to Use This Program [Workflow Example]
- Admin Adds Vote Item:

```bash
leo run add_id 1u32 123456789field
```
- User Likes Item:

```bash
leo run like_id 1u32
```
- Check Results:
  
```bash
leo run get_vote 1u32
# Output: {id: 1u32, description: 123456789field, likes: 1u32, dislikes: 0u32}
```

# Key Commands
### Action	Command
✅ Add Vote -	`leo run add_id <ID> <FIELD>`

✅ Like - 	`leo run like_id <ID>`

✅ Dislike -	`leo run dislike_id <ID>`

✅ View Vote -	`leo run get_vote <ID>`

# Conclusion
### This program demonstrates:
✅ Secure voting with admin controls

✅ Prevention of duplicate votes

✅ On-chain storage with mappings

✅ Asynchronous transitions/finalizers

