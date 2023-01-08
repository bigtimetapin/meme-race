use anchor_lang::prelude::*;

pub const SEED: &str = "degen";

pub const SIZE: usize = 8 // discriminator
    + 1; // total-wagers-placed

#[account]
pub struct Degen {
    pub total_wagers_placed: u8,
}
