use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token};
use crate::pda::boss::Boss;
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

    pub fn contend(ctx: Context<Contend>, url: Pubkey) -> Result<()> {
        ix::contend::ix(ctx, url)
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
    #[account(
    owner = token_program.key()
    )]
    pub mint: Account<'info, Mint>,
    #[account(init,
    seeds = [
    pda::boss::SEED.as_bytes()
    ], bump,
    payer = payer,
    space = pda::boss::SIZE
    )]
    pub boss: Account<'info, Boss>,
    #[account()]
    pub two: SystemAccount<'info>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
    // system program
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Contend<'info> {
    #[account(init,
    seeds = [
    pda::contender::SEED.as_bytes(),
    payer.key().as_ref()
    ], bump,
    payer = payer,
    space = pda::contender::SIZE
    )]
    pub contender: Account<'info, Contender>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
    // system program
    pub system_program: Program<'info, System>,
}
