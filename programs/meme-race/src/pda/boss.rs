use anchor_lang::prelude::*;

pub const SEED: &str = "boss";

pub const SIZE: usize = 8 // discriminator
    + 32 // mint
    + 32 // boss one
    + 32; // boss two

pub const SPLIT: f64 = 10.0;

#[account]
pub struct Boss {
    // mint
    pub mint: Pubkey,
    // bosses
    pub one: Pubkey,
    pub two: Pubkey,
}
