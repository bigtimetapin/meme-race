import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {deriveLeaderBoardPda, getLeaderBoardPda} from "../pda/leader-board-pda";
import {deriveBossPda} from "../pda/boss-pda";
import {deriveAtaPda} from "../pda/ata-pda";
import {BONK, SPL_TOKEN_PROGRAM_ID} from "../util/constants";

export async function claimAsBoss(app, provider: AnchorProvider, program: Program<MemeRace>): Promise<void> {
    const leaderBoardPda = deriveLeaderBoardPda(
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
    );
    await program
        .methods
        .claimAsBoss()
        .accounts(
            {
                leaderBoard: leaderBoardPda.address,
                boss: bossPda.address,
                mint: BONK,
                ata: ata,
                treasury: treasury,
                claimer: provider.wallet.publicKey,
                tokenProgram: SPL_TOKEN_PROGRAM_ID
            }
        ).rpc();
    const leaderBoard = await getLeaderBoardPda(
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
