import {AnchorProvider, Program, SplToken} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {provision, uploadMultipleFiles} from "../../shdw";
import {deriveContenderPda, encodeMetadata} from "../pda/contender-pda";
import {deriveLeaderBoardPda} from "../pda/leader-board-pda";
import {SystemProgram} from "@solana/web3.js";
import {deriveDegenPda, getDegenPda} from "../pda/degen-pda";

export interface Form {
    dataUrl: string
}

export async function addContender(
    app,
    provider: AnchorProvider,
    programs: {
        meme: Program<MemeRace>;
        token: Program<SplToken>
    },
    form: Form
): Promise<void> {
    const blob = await dataUrlToBlob(
        form.dataUrl
    );
    console.log(blob);
    const file = new File(
        [blob],
        mimeTypeToFileName(blob.type),
        {type: blob.type}
    );
    console.log(file);
    const metadata = encodeMetadata(
        {
            meme: file.name
        }
    );
    console.log(metadata);
    const provisioned = await provision(
        provider.connection,
        provider.wallet,
        file.size
    );
    console.log(provisioned);
    await uploadMultipleFiles(
        [
            file,
            metadata
        ],
        provisioned.drive,
        provisioned.account
    );
    const contenderPda = deriveContenderPda(
        provider,
        programs.meme
    );
    const leaderBoardPda = deriveLeaderBoardPda(
        programs.meme
    );
    await programs.meme
        .methods
        .addContender(
            provisioned.account as any
        ).accounts(
            {
                contender: contenderPda.address,
                leaderBoard: leaderBoardPda.address,
                payer: provider.wallet.publicKey,
                systemProgram: SystemProgram.programId
            }
        ).rpc();
    let degen;
    const degenPda = deriveDegenPda(
        provider,
        programs.meme
    );
    try {
        degen = await getDegenPda(
            provider,
            programs,
            degenPda
        );
    } catch (error) {
        console.log(error);
        // try one more time because the error was likely the rpc being slightly behind
        degen = await getDegenPda(
            provider,
            programs,
            degenPda
        );
    }
    app.ports.success.send(
        JSON.stringify(
            {
                listener: "degen-fetched",
                more: JSON.stringify(
                    degen
                )
            }
        )
    );
}

async function dataUrlToBlob(url: string): Promise<Blob> {
    return fetch(url).then(response => response.blob())
}

function mimeTypeToFileName(mimeType: string): string {
    let fileType;
    if (mimeType === "image/svg+xml") {
        fileType = ".svg";
    } else {
        fileType = mimeType.replace(
            "image/",
            "."
        );
    }
    return "meme" + fileType
}
