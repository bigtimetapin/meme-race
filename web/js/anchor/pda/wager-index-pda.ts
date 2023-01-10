import {Pda} from "./pda";
import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {PublicKey} from "@solana/web3.js";


export interface WagerIndexPda extends Pda {
}

export interface WagerIndex {
    pda: PublicKey
}

export async function getManyWagerIndexPda(program: Program<MemeRace>, pdaArray: WagerIndexPda[]): Promise<WagerIndex[]> {
    return (await program.account.wagerIndex.fetchMultiple(
        pdaArray.map(pda => pda.address)
    )).filter(Boolean) as WagerIndex[]
}

export function deriveWagerIndexPda(
    provider: AnchorProvider,
    program: Program<MemeRace>,
    index: number
): WagerIndexPda {
    let pda, bump;
    [pda, bump] = PublicKey.findProgramAddressSync(
        [
            Buffer.from(SEED),
            provider.wallet.publicKey.toBuffer(),
            Buffer.from([index])
        ],
        program.programId
    );
    return {
        address: pda,
        bump
    }
}

const SEED = "wager-index";
