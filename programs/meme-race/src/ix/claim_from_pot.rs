use std::ops::Div;
use anchor_lang::prelude::*;
use anchor_spl::token::{transfer, Transfer};
use crate::{ClaimFromPot, pda};

pub fn ix(ctx: Context<ClaimFromPot>) -> Result<()> {
    // grab accounts
    let leader_board = &ctx.accounts.leader;
    let winner = &ctx.accounts.contender;
    let wager = &ctx.accounts.wager;
    // build signer seeds
    let bump = ctx.bumps.get(
        pda::boss::SEED
    ).unwrap();
    let seeds = &[
        pda::boss::SEED.as_bytes(),
        &[*bump]
    ];
    let signer_seeds = &[&seeds[..]];
    // check that wager was placed on winner
    if wager.contender.key().eq(&winner.key()) {
        // compute winners pot
        let pot = ((leader_board.total - winner.score) as f32) * pda::boss::POT_SPLIT;
        // floor div bc this dog coin has got too many digits anyways
        let share_pct = wager.wager.div(winner.score) as f32;
        let share = (pot * share_pct) as u64;
        // build transfer ix
        let transfer_accounts = Transfer {
            from: ctx.accounts.treasury.to_account_info(),
            to: ctx.accounts.ata.to_account_info(),
            authority: ctx.accounts.boss.to_account_info(),
        };
        let transfer_cpi_context = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            transfer_accounts,
        );
        // invoke transfer ix
        transfer(
            transfer_cpi_context.with_signer(
                signer_seeds
            ),
            share,
        )?;
    }
    Ok(())
}
