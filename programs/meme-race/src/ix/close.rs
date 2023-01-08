use anchor_lang::prelude::*;
use crate::Close;

pub fn ix(ctx: Context<Close>) -> Result<()> {
    let leader = &mut ctx.accounts.leader_board;
    leader.open = false;
    Ok(())
}
