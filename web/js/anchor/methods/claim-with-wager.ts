import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {deriveLeaderBoardPda, getLeaderBoardPda} from "../pda/leader-board-pda";
import {deriveWagerPda} from "../pda/wager-pda";
import {deriveBossPda} from "../pda/boss-pda";
import {deriveAtaPda} from "../pda/ata-pda";
import {BONK, SPL_TOKEN_PROGRAM_ID} from "../util/constants";

export async function claimWithWager(app, provider: AnchorProvider, program: Program<MemeRace>): Promise<void> {
    const leaderBoardPda = deriveLeaderBoardPda(
        program
    );
    let leaderBoard = await getLeaderBoardPda(
        provider,
        program,
        leaderBoardPda
    );
    const wagerPda = deriveWagerPda(
        leaderBoard.leader.pda,
        provider,
        program
    );
    const bossPda = deriveBossPda(
        program
    );
    const ata = deriveAtaPda(
        provider.wallet.publicKey,
        BONK
    );
    const treasury = deriveAtaPda(
        bossPda.address,
        BONK
    )
    console.log(treasury.toString());
    await program
        .methods
        .claimWithWager()
        .accounts(
            {
                winner: leaderBoard.leader.pda,
                wager: wagerPda.address,
                leaderBoard: leaderBoardPda.address,
                boss: bossPda.address,
                mint: BONK,
                ata: ata,
                treasury: treasury,
                claimer: provider.wallet.publicKey,
                tokenProgram: SPL_TOKEN_PROGRAM_ID
            }
        ).rpc()
    leaderBoard = await getLeaderBoardPda(
        provider,
        program,
        leaderBoardPda
    );
    app.ports.success.send(
        JSON.stringify(
            {
                listener: "leader-board-fetched",
                more: JSON.stringify(
                    leaderBoard
                )
            }
        )
    );
}
