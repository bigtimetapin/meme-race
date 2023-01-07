use anchor_lang::prelude::*;
use crate::Contend;

pub fn ix(ctx: Context<Contend>, url: Pubkey) -> Result<()> {
    let contender = &mut ctx.accounts.contender;
    contender.url = url;
    contender.authority = ctx.accounts.payer.key();
    Ok(())
}
