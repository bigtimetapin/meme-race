use anchor_lang::prelude::*;
use crate::pda::contender::Contender;
use crate::pda::leader::Leader;

mod pda;
mod ix;

declare_id!("EGkSrbRq86xw8EFdUtE5zaK7SvSPKQYnpUQWUeGPPX9H");

#[program]
pub mod meme_race {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        ix::initialize::ix(ctx)
    }
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(init,
    seeds = [
    pda::leader::SEED.as_bytes()
    ], bump,
    payer = payer,
    space = pda::leader::SIZE
    )]
    pub leader: Account<'info, Leader>,
    #[account(init,
    seeds = [
    pda::contender::SEED.as_bytes()
    ], bump,
    payer = payer,
    space = pda::contender::SIZE
    )]
    pub contender: Account<'info, Contender>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // system program
    pub system_program: Program<'info, System>,
}
