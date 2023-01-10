use anchor_lang::prelude::*;
use crate::AddContender;

pub fn ix(ctx: Context<AddContender>, url: Pubkey) -> Result<()> {
    let contender = &mut ctx.accounts.contender;
    let leader_board = &ctx.accounts.leader_board;
    // check that race is still open
    if leader_board.open {
        contender.url = url;
        contender.authority = ctx.accounts.payer.key();
        contender.pda = contender.key();
    }
    Ok(())
}
