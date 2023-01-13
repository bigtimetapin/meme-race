import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {deriveLeaderBoardPda, getLeaderBoardPda} from "../pda/leader-board-pda";
import {deriveBossPda} from "../pda/boss-pda";
import {deriveAtaPda} from "../pda/ata-pda";
import {BONK, SPL_TOKEN_PROGRAM_ID} from "../util/constants";

export async function claimAsUploader(app, provider: AnchorProvider, program: Program<MemeRace>): Promise<void> {
    const leaderBoardPda = deriveLeaderBoardPda(
        program
    );
    let leaderBoard = await getLeaderBoardPda(
        provider,
        program,
        leaderBoardPda
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
    );
    await program
        .methods
        .claimAsUploader()
        .accounts(
            {
                winner: leaderBoard.leader.pda,
                leaderBoard: leaderBoardPda.address,
                boss: bossPda.address,
                mint: BONK,
                ata: ata,
                treasury: treasury,
                claimer: provider.wallet.publicKey,
                tokenProgram: SPL_TOKEN_PROGRAM_ID
            }
        ).rpc();
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
