import credits.aleo;
program new_workshop1.aleo;

record Token:
    owner as address.private;
    amount as u64.private;

function mint:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as Token.record;
    output r2 as Token.record;

function transfer:
    input r0 as Token.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as Token.record;
    cast r1 r2 into r5 as Token.record;
    output r4 as Token.record;
    output r5 as Token.record;

function transfer_aleo:
    input r0 as address.private;
    input r1 as u64.private;
    call credits.aleo/transfer_public r0 r1 into r2;
    async transfer_aleo r2 into r3;
    output r3 as new_workshop1.aleo/transfer_aleo.future;

finalize transfer_aleo:
    input r0 as credits.aleo/transfer_public.future;
    await r0;
