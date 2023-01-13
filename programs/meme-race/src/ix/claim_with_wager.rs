use std::ops::Div;
use anchor_lang::prelude::*;
use anchor_spl::token::{transfer, Transfer};
use crate::{ClaimWithWager, pda};

pub fn ix(ctx: Context<ClaimWithWager>) -> Result<()> {
    // grab accounts
    let leader_board = &mut ctx.accounts.leader_board;
    let wager = &mut ctx.accounts.wager;
    let winner = &ctx.accounts.winner;
    // build signer seeds
    let bump = ctx.bumps.get(
        pda::boss::SEED
    ).unwrap();
    let seeds = &[
        pda::boss::SEED.as_bytes(),
        &[*bump]
    ];
    let signer_seeds = &[&seeds[..]];
    // check that race has been closed
    // check that still unclaimed
    if !leader_board.open && !wager.claimed {
        // compute winners pot
        let pot = (leader_board.total as f32) * pda::boss::POT_SPLIT;
        // floor div bc this dog coin has got too many digits anyways
        let share_pct = (wager.wager_size as f32).div(winner.score as f32);
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
        // increment claimed
        leader_board.claimed += share;
        wager.claimed = true;
    }
    Ok(())
}
