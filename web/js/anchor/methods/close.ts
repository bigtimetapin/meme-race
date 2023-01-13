import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {deriveLeaderBoardPda} from "../pda/leader-board-pda";

export async function close(provider: AnchorProvider, program: Program<MemeRace>): Promise<void> {
    const leaderBoardPda = deriveLeaderBoardPda(
        program
    );
    await program
        .methods
        .close()
        .accounts(
            {
                leaderBoard: leaderBoardPda.address,
                authority: provider.wallet.publicKey
            }
        ).rpc()
}
