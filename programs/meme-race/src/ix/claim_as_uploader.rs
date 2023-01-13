use anchor_lang::prelude::*;
use anchor_spl::token::{transfer, Transfer};
use crate::{ClaimAsUploader, pda};

pub fn ix(ctx: Context<ClaimAsUploader>) -> Result<()> {
    // grab accounts
    let leader_board = &mut ctx.accounts.leader_board;
    let winner = &mut ctx.accounts.winner;
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
    if (!leader_board.open) && !winner.claimed {
        // compute share
        let share = ((leader_board.total as f32) * pda::boss::PER_BOSS_SPLIT) as u64;
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
        winner.claimed = true;
    }
    Ok(())
}
