use anchor_lang::prelude::*;

pub const SEED: &str = "wager-index";

pub const SIZE: usize = 8 // discriminator
    + 32; // pda

#[account]
pub struct WagerIndex {
    pub pda: Pubkey, // address of wager
}
