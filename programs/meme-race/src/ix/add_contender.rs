use anchor_lang::prelude::*;
use crate::AddContender;

pub fn ix(ctx: Context<AddContender>, url: Pubkey) -> Result<()> {
    let contender = &mut ctx.accounts.contender;
    contender.url = url;
    contender.authority = ctx.accounts.payer.key();
    Ok(())
}
