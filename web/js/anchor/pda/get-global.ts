import {AnchorProvider, Program, SplToken} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {deriveDegenPda, getDegenPda} from "./degen-pda";

export async function getGlobal(
    app,
    provider: AnchorProvider,
    programs: {
        meme: Program<MemeRace>,
        token: Program<SplToken>
    }
): Promise<void> {
    const degenPda = deriveDegenPda(
        provider,
        programs.meme
    );
    const degen = await getDegenPda(
        provider,
        programs,
        degenPda
    );
    app.ports.success.send(
        JSON.stringify(
            {
                listener: "global-found-degen",
                more: JSON.stringify(
                    degen
                )
            }
        )
    );
}
