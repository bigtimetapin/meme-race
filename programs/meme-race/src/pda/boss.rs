use anchor_lang::prelude::*;

pub const SEED: &str = "boss";

pub const SIZE: usize = 8 // discriminator
    + 32 // mint
    + 32 // boss one
    + 32 // boss two
    + (1 * 2); // claims

pub const PER_BOSS_SPLIT: f32 = 10.0; // times 3

pub const POT_SPLIT: f32 = 70.0;

#[account]
pub struct Boss {
    // mint
    pub mint: Pubkey,
    // bosses
    pub one: Pubkey,
    pub two: Pubkey,
    // claims
    pub one_claimed: bool,
    pub two_claimed: bool,
}
