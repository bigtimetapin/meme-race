import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {deriveLeaderBoardPda} from "../pda/leader-board-pda";
import {deriveBossPda} from "../pda/boss-pda";
import {deriveAtaPda} from "../pda/ata-pda";
import {BONK, BOSS_TWO, SPL_ASSOCIATED_TOKEN_PROGRAM_ID, SPL_TOKEN_PROGRAM_ID} from "../util/constants";
import {SystemProgram} from "@solana/web3.js";

export async function initialize(provider: AnchorProvider, program: Program<MemeRace>): Promise<void> {
    const leaderBoardPda = deriveLeaderBoardPda(
        program
    );
    const bossPda = deriveBossPda(
        program
    );
    const treasuryAtaPda = deriveAtaPda(
        bossPda.address,
        BONK
    );
    await program
        .methods
        .initialize()
        .accounts(
            {
                leaderBoard: leaderBoardPda.address,
                mint: BONK,
                boss: bossPda.address,
                treasury: treasuryAtaPda,
                two: BOSS_TWO,
                payer: provider.wallet.publicKey,
                tokenProgram: SPL_TOKEN_PROGRAM_ID,
                associatedTokenProgram: SPL_ASSOCIATED_TOKEN_PROGRAM_ID,
                systemProgram: SystemProgram.programId
            }
        ).rpc()
    const boss = await program.account.boss.fetch(
        bossPda.address
    );
    console.log(boss.mint.toString());
    console.log(boss.one.toString());
    console.log(boss.two.toString());
}
