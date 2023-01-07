use anchor_lang::prelude::*;

pub const SEED: &str = "wager";

pub const SIZE: usize = 8 // discriminator
    + 8 // wager
    + 32 // contender
    + 32; // authority

#[account]
pub struct Wager {
    pub wager: u64,
    pub contender: Pubkey,
    pub authority: Pubkey,
}
