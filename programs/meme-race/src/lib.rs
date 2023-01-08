use anchor_lang::prelude::*;
use anchor_spl::associated_token::AssociatedToken;
use anchor_spl::token::{Mint, Token, TokenAccount};
use crate::pda::boss::Boss;
use crate::pda::contender::Contender;
use crate::pda::degen::Degen;
use crate::pda::leader_board::LeaderBoard;
use crate::pda::wager::Wager;
use crate::pda::wager_index::WagerIndex;

mod pda;
mod ix;

declare_id!("EGkSrbRq86xw8EFdUtE5zaK7SvSPKQYnpUQWUeGPPX9H");

#[program]
pub mod meme_race {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        ix::initialize::ix(ctx)
    }

    pub fn add_contender(ctx: Context<AddContender>, url: Pubkey) -> Result<()> {
        ix::add_contender::ix(ctx, url)
    }

    pub fn add_degen(ctx: Context<AddDegen>) -> Result<()> {
        ix::add_degen::ix(ctx)
    }

    pub fn place_wager(ctx: Context<PlaceWager>, wager: u64) -> Result<()> {
        ix::place_wager::ix(ctx, wager)
    }

    pub fn close(ctx: Context<Close>) -> Result<()> {
        ix::close::ix(ctx)
    }

    pub fn claim_from_pot(ctx: Context<ClaimFromPot>) -> Result<()> {
        ix::claim_from_pot::ix(ctx)
    }
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(init,
    seeds = [
    pda::leader_board::SEED.as_bytes()
    ], bump,
    payer = payer,
    space = pda::leader_board::SIZE
    )]
    pub leader_board: Account<'info, LeaderBoard>,
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
    #[account(init,
    associated_token::mint = mint,
    associated_token::authority = boss,
    payer = payer
    )]
    pub treasury: Account<'info, TokenAccount>,
    #[account()]
    pub two: SystemAccount<'info>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
    // associated token program
    pub associated_token_program: Program<'info, AssociatedToken>,
    // system program
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct AddContender<'info> {
    #[account(init,
    seeds = [
    pda::contender::SEED.as_bytes(),
    payer.key().as_ref()
    ], bump,
    payer = payer,
    space = pda::contender::SIZE
    )]
    pub contender: Account<'info, Contender>,
    #[account(
    seeds = [
    pda::leader_board::SEED.as_bytes()
    ], bump,
    )]
    pub leader_board: Account<'info, LeaderBoard>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // system program
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct AddDegen<'info> {
    #[account(init,
    seeds = [
    pda::degen::SEED.as_bytes(),
    payer.key().as_ref()
    ], bump,
    payer = payer,
    space = pda::degen::SIZE
    )]
    pub degen: Account<'info, Degen>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // system program
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct PlaceWager<'info> {
    #[account(mut)]
    pub contender: Box<Account<'info, Contender>>,
    #[account(init_if_needed,
    seeds = [
    pda::wager::SEED.as_bytes(),
    contender.key().as_ref(),
    payer.key().as_ref()
    ], bump,
    payer = payer,
    space = pda::wager::SIZE
    )]
    pub wager: Box<Account<'info, Wager>>,
    #[account(init_if_needed,
    seeds = [
    pda::wager_index::SEED.as_bytes(),
    payer.key().as_ref(),
    & [degen.total_wagers_placed + 1]
    ], bump,
    payer = payer,
    space = pda::wager_index::SIZE
    )]
    pub wager_index: Box<Account<'info, WagerIndex>>,
    #[account(mut,
    seeds = [
    pda::degen::SEED.as_bytes(),
    payer.key().as_ref()
    ], bump,
    )]
    pub degen: Box<Account<'info, Degen>>,
    #[account(mut,
    seeds = [
    pda::leader_board::SEED.as_bytes()
    ], bump,
    )]
    pub leader_board: Box<Account<'info, LeaderBoard>>,
    #[account(
    seeds = [
    pda::boss::SEED.as_bytes()
    ], bump,
    )]
    pub boss: Box<Account<'info, Boss>>,
    #[account(
    address = boss.mint,
    owner = token_program.key()
    )]
    pub mint: Account<'info, Mint>,
    #[account(init_if_needed,
    associated_token::mint = mint,
    associated_token::authority = payer,
    payer = payer
    )]
    pub ata: Account<'info, TokenAccount>,
    #[account(mut,
    associated_token::mint = mint,
    associated_token::authority = boss
    )]
    pub treasury: Account<'info, TokenAccount>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
    // associated token program
    pub associated_token_program: Program<'info, AssociatedToken>,
    // system program
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Close<'info> {
    #[account(mut,
    seeds = [
    pda::leader_board::SEED.as_bytes()
    ], bump,
    )]
    pub leader_board: Account<'info, LeaderBoard>,
    #[account(
    address = leader_board.authority
    )]
    pub authority: SystemAccount<'info>,
}

#[derive(Accounts)]
pub struct ClaimFromPot<'info> {
    #[account(
    address = leader_board.leader.pda
    )]
    pub winner: Account<'info, Contender>,
    #[account(
    seeds = [
    pda::wager::SEED.as_bytes(),
    winner.key().as_ref(),
    claimer.key().as_ref()
    ], bump,
    )]
    pub wager: Account<'info, Wager>,
    #[account(
    seeds = [
    pda::leader_board::SEED.as_bytes()
    ], bump,
    )]
    pub leader_board: Account<'info, LeaderBoard>,
    #[account(
    seeds = [
    pda::boss::SEED.as_bytes()
    ], bump,
    )]
    pub boss: Account<'info, Boss>,
    #[account(
    address = boss.mint,
    owner = token_program.key()
    )]
    pub mint: Account<'info, Mint>,
    #[account(mut,
    associated_token::mint = mint,
    associated_token::authority = claimer
    )]
    pub ata: Account<'info, TokenAccount>,
    #[account(mut,
    associated_token::mint = mint,
    associated_token::authority = boss
    )]
    pub treasury: Account<'info, TokenAccount>,
    #[account(mut)]
    pub claimer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
}
