use anchor_lang::prelude::*;
use crate::pda;

pub const SEED: &str = "leader";

pub const SIZE: usize = 8 // discriminator
    + 32 // authority
    + TOP_CONTENDER_SIZE // leader
    + 4 + (TOP_CONTENDER_SIZE * 10) // top 10 race
    + 1; // is race still open

const TOP_CONTENDER_SIZE: usize = 8 // score
    + 32; // pda

#[account]
pub struct Leader {
    pub authority: Pubkey,
    pub leader: TopContender,
    pub race: Vec<TopContender>,
    pub open: bool,
}

#[derive(AnchorSerialize, AnchorDeserialize, Clone)]
pub struct TopContender {
    pub score: u64,
    pub pda: Pubkey,
}
