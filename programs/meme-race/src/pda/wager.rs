use anchor_lang::prelude::*;

pub const SEED: &str = "wager";

pub const SIZE: usize = 8 // discriminator
    + 8 // wager-size
    + 1 // wager-count
    + 32; // contender


#[account]
pub struct Wager {
    pub wager_size: u64,
    pub wager_count: u8, // how many wagers this degen has placed on this contender
    pub contender: Pubkey,
}
