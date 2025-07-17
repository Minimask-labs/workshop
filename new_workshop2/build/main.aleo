program new_workshop2.aleo;

struct Vote:
    id as u32;
    description as field;
    likes as u32;
    dislikes as u32;

mapping votes:
    key as u32.public;
    value as Vote.public;

mapping has_voted:
    key as address.public;
    value as boolean.public;

function add_id:
    input r0 as u32.public;
    input r1 as field.public;
    async add_id r0 r1 self.caller into r2;
    output r2 as new_workshop2.aleo/add_id.future;

finalize add_id:
    input r0 as u32.public;
    input r1 as field.public;
    input r2 as address.public;
    is.eq r2 aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px into r3;
    assert.eq r3 true;
    contains votes[r0] into r4;
    not r4 into r5;
    assert.eq r5 true;
    cast r0 r1 0u32 0u32 into r6 as Vote;
    get.or_use votes[r0] r6 into r7;
    set r7 into votes[r0];

function delete_id:
    input r0 as u32.public;
    input r1 as field.public;
    async delete_id r0 r1 self.caller into r2;
    output r2 as new_workshop2.aleo/delete_id.future;

finalize delete_id:
    input r0 as u32.public;
    input r1 as field.public;
    input r2 as address.public;
    is.eq r2 aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px into r3;
    assert.eq r3 true;
    contains votes[r0] into r4;
    not r4 into r5;
    assert.eq r5 true;
    cast r0 r1 0u32 0u32 into r6 as Vote;
    get.or_use votes[r0] r6 into r7;
    remove votes[r0];

function like_id:
    input r0 as u32.public;
    async like_id r0 self.caller into r1;
    output r1 as new_workshop2.aleo/like_id.future;

finalize like_id:
    input r0 as u32.public;
    input r1 as address.public;
    contains votes[r0] into r2;
    assert.eq r2 true;
    get.or_use has_voted[r1] false into r3;
    not r3 into r4;
    assert.eq r4 true;
    cast r0 123field 0u32 0u32 into r5 as Vote;
    get.or_use votes[r0] r5 into r6;
    add r6.likes 1u32 into r7;
    cast r6.id r6.description r7 r6.dislikes into r8 as Vote;
    set r8 into votes[r0];
    set true into has_voted[r1];

function dislike_game:
    input r0 as u32.public;
    async dislike_game r0 self.caller into r1;
    output r1 as new_workshop2.aleo/dislike_game.future;

finalize dislike_game:
    input r0 as u32.public;
    input r1 as address.public;
    contains votes[r0] into r2;
    assert.eq r2 true;
    get.or_use has_voted[r1] false into r3;
    not r3 into r4;
    assert.eq r4 true;
    cast r0 123field 0u32 0u32 into r5 as Vote;
    get.or_use votes[r0] r5 into r6;
    add r6.dislikes 1u32 into r7;
    cast r6.id r6.description r6.likes r7 into r8 as Vote;
    set r8 into votes[r0];
    set true into has_voted[r1];

function get_vote:
    input r0 as u32.public;
    async get_vote r0 into r1;
    output r1 as new_workshop2.aleo/get_vote.future;

finalize get_vote:
    input r0 as u32.public;
    contains votes[r0] into r1;
    assert.eq r1 true;
    get votes[r0] into r2;

function check_vote:
    input r0 as address.public;
    input r1 as u32.public;
    async check_vote r0 r1 into r2;
    output r2 as new_workshop2.aleo/check_vote.future;

finalize check_vote:
    input r0 as address.public;
    input r1 as u32.public;
    get.or_use has_voted[r0] false into r2;
