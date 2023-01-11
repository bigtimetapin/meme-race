use std::ops::Div;
use anchor_lang::prelude::*;
use anchor_spl::token::{burn, transfer, Burn, Transfer};
use crate::pda::leader_board::TopContender;
use crate::{pda, PlaceWager};

pub fn ix(ctx: Context<PlaceWager>, wager: u64) -> Result<()> {
    // grab accounts
    let contender = &mut ctx.accounts.contender;
    let wager_pda = &mut ctx.accounts.wager;
    let wager_index = &mut ctx.accounts.wager_index;
    let degen = &mut ctx.accounts.degen;
    let leader_pda = &mut ctx.accounts.leader_board;
    // build signer seeds
    let bump = ctx.bumps.get(
        pda::boss::SEED
    ).unwrap();
    let seeds = &[
        pda::boss::SEED.as_bytes(),
        &[*bump]
    ];
    let signer_seeds = &[&seeds[..]];
    // check that race is still open
    if leader_pda.open {
        // build transfer ix
        let transfer_accounts = Transfer {
            from: ctx.accounts.ata.to_account_info(),
            to: ctx.accounts.treasury.to_account_info(),
            authority: ctx.accounts.payer.to_account_info(),
        };
        let transfer_cpi_context = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            transfer_accounts,
        );
        // build burn ix
        let burn_accounts = Burn {
            mint: ctx.accounts.mint.to_account_info(),
            from: ctx.accounts.treasury.to_account_info(),
            authority: ctx.accounts.boss.to_account_info(),
        };
        let burn_cpi_context = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            burn_accounts,
        );
        // invoke transfer ix
        transfer(
            transfer_cpi_context,
            wager,
        )?;
        // invoke burn ix for half the wager amount
        let burn_amount = wager.div(2);
        burn(
            burn_cpi_context.with_signer(
                signer_seeds
            ),
            burn_amount,
        )?;
        // bump contender
        contender.score += burn_amount;
        // bump wager
        wager_pda.wager_size += burn_amount;
        // bump leader board
        // add this contender to leader board
        let this_contender = TopContender {
            score: contender.score,
            pda: contender.key(),
        };
        // but filter previous occurrence of this contender
        let race: &Vec<TopContender> = &leader_pda.race.clone();
        let top_contenders = &mut race
            .iter()
            .filter(|&contender|
                !(*contender).pda.eq(&this_contender.pda)
            ).collect::<Vec<&TopContender>>();
        top_contenders.push(&this_contender);
        // sort leader board by score with highest score as first element
        top_contenders.sort_by(|left, right|
            right.score.cmp(&left.score)
        );
        // grab first 10 elements which is now the top 10
        let sorted = top_contenders.clone()
            .iter()
            .map(|&tc|
                tc.clone()
            ).collect::<Vec<TopContender>>();
        if sorted.len() > 10 {
            leader_pda.race = sorted[..10].to_vec();
        } else {
            leader_pda.race = sorted;
        }
        // grab first element which is now the leader
        leader_pda.leader = leader_pda.race.first().unwrap().clone();
        // increment global wager count
        leader_pda.total += burn_amount;
    }
    // check wager-count
    if wager_pda.wager_count == 0 {
        degen.total_wagers_placed += 1;
        wager_pda.contender = contender.key();
        wager_index.pda = wager_pda.key();
    }
    // bump wager-count
    wager_pda.wager_count += 1;
    Ok(())
}
