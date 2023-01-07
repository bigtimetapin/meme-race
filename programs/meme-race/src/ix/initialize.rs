use anchor_lang::prelude::*;
use crate::Initialize;

pub fn ix(
    ctx: Context<Initialize>,
) -> Result<()> {
    // grab accounts
    let boss = &mut ctx.accounts.boss;
    let leader = &mut ctx.accounts.leader;
    // init boss
    boss.mint = ctx.accounts.mint.key();
    boss.one = ctx.accounts.payer.key();
    boss.two = ctx.accounts.two.key();
    // init leader board
    leader.open = true;
    leader.authority = ctx.accounts.payer.key();
    Ok(())
}
