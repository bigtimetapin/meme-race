use anchor_lang::prelude::*;

pub const SEED: &str = "contender";

pub const SIZE: usize = 8 // discriminator
    + 8 // score
    + 32; // authority

#[account]
pub struct Contender {
    pub score: u64,
    pub authority: Pubkey,
}
