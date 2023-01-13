use anchor_lang::prelude::*;

pub const SEED: &str = "contender";

pub const SIZE: usize = 8 // discriminator
    + 8 // score
    + 32 // url
    + 32 // authority
    + 32 // pda
    + 1; // claimed

#[account]
pub struct Contender {
    pub score: u64,
    pub url: Pubkey,
    pub authority: Pubkey,
    pub pda: Pubkey,
    pub claimed: bool,
}
