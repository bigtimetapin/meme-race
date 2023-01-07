use anchor_lang::prelude::*;
use crate::pda;
use crate::pda::contender::Contender;

pub const SEED: &str = "leader";

pub const SIZE: usize = 8 // discriminator
    + 8 // score
    + 32; // leader

const RACE_SIZE: usize =
    pda::contender::SIZE // min
        + pda::contender::SIZE // max
        + 4 + (pda::contender::SIZE * 10); // race (top 10)

#[account]
pub struct Leader {
    pub score: u64,
    pub leader: Pubkey,
    pub race: Race,
}

#[derive(AnchorSerialize, AnchorDeserialize, Clone)]
pub struct Race {
    pub min: TopContender,
    pub max: TopContender,
    pub race: Vec<TopContender>,
}

#[derive(AnchorSerialize, AnchorDeserialize, Clone)]
pub struct TopContender {
    pub score: u64,
    pub authority: Pubkey,
}
