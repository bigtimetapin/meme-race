import {AnchorProvider, BN, Program, SplToken} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {PublicKey, SystemProgram} from "@solana/web3.js";
import {Degen, DegenPda, deriveDegenPda, getDegenPda} from "../pda/degen-pda";
import {deriveWagerPda} from "../pda/wager-pda";
import {deriveWagerIndexPda} from "../pda/wager-index-pda";
import {deriveLeaderBoardPda} from "../pda/leader-board-pda";
import {deriveBossPda} from "../pda/boss-pda";
import {deriveAtaPda} from "../pda/ata-pda";
import {BONK, SPL_ASSOCIATED_TOKEN_PROGRAM_ID, SPL_TOKEN_PROGRAM_ID} from "../util/constants";
import {getContenderPda} from "../pda/contender-pda";

export interface Form {
    wager: number
    contender: {
        pda: PublicKey
    }
}

export async function placeWager(
    app,
    provider: AnchorProvider,
    programs: {
        meme: Program<MemeRace>,
        token: Program<SplToken>
    },
    form: Form
): Promise<void> {
    const degenPda = deriveDegenPda(
        provider,
        programs.meme
    );
    let degen: Degen
    try {
        await programs.meme.account.degen.fetch(
            degenPda.address
        );
        degen = await getDegenPda(
            provider,
            programs,
            degenPda
        );
    } catch (error) {
        degen = await addDegen(
            provider,
            programs,
            degenPda
        );
    }
    const wagerPda = deriveWagerPda(
        form.contender.pda,
        provider,
        programs.meme
    );
    const wagerIndexPda = deriveWagerIndexPda(
        provider,
        programs.meme,
        degen.totalWagersPlaced + 1
    );
    const leaderBoardPda = deriveLeaderBoardPda(
        programs.meme
    );
    const bossPda = deriveBossPda(
        programs.meme
    );
    const ata = deriveAtaPda(
        provider.wallet.publicKey,
        BONK
    );
    const treasury = deriveAtaPda(
        bossPda.address,
        BONK
    );
    await programs
        .meme
        .methods
        .placeWager(
            new BN(form.wager)
        )
        .accounts(
            {
                contender: form.contender.pda,
                wager: wagerPda.address,
                wagerIndex: wagerIndexPda.address,
                degen: degenPda.address,
                leaderBoard: leaderBoardPda.address,
                boss: bossPda.address,
                mint: BONK,
                ata: ata,
                treasury: treasury,
                payer: provider.wallet.publicKey,
                tokenProgram: SPL_TOKEN_PROGRAM_ID,
                associatedTokenProgram: SPL_ASSOCIATED_TOKEN_PROGRAM_ID,
                systemProgram: SystemProgram.programId
            }
        ).rpc()
    const contender = await getContenderPda(
        provider,
        programs.meme,
        form.contender.pda
    );
    app.ports.success.send(
        JSON.stringify(
            {
                listener: "contender-fetched",
                more: JSON.stringify(
                    contender
                )
            }
        )
    );
}

async function addDegen(
    provider: AnchorProvider,
    programs: {
        meme: Program<MemeRace>;
        token: Program<SplToken>
    },
    pda: DegenPda
): Promise<Degen> {
    console.log("initializing degen account")
    await programs
        .meme
        .methods
        .addDegen()
        .accounts(
            {
                degen: pda.address,
                payer: provider.wallet.publicKey,
                systemProgram: SystemProgram.programId
            }
        ).rpc();
    let degen;
    try {
        degen = await getDegenPda(
            provider,
            programs,
            pda
        );
    } catch (error) {
        console.log(error);
        // try again because the error was likely the rpc slightly behind
        degen = await getDegenPda(
            provider,
            programs,
            pda
        );
    }
    return degen
}
