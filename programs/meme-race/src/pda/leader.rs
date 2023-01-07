use anchor_lang::prelude::*;
use crate::pda;

pub const SEED: &str = "leader";

pub const SIZE: usize = 8 // discriminator
    + TOP_CONTENDER_SIZE // leader
    + 4 + (TOP_CONTENDER_SIZE * 10); // top 10 race

const TOP_CONTENDER_SIZE: usize = 8 // score
    + 32; // pda

#[account]
pub struct Leader {
    pub leader: TopContender,
    pub race: Vec<TopContender>,
}

#[derive(AnchorSerialize, AnchorDeserialize, Clone)]
pub struct TopContender {
    pub score: u64,
    pub pda: Pubkey,
}
