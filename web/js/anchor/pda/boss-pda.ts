import {Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {Pda} from "./pda";
import {PublicKey} from "@solana/web3.js";

export interface BossPda extends Pda {
}

export function deriveBossPda(program: Program<MemeRace>): BossPda {
    let pda, bump;
    [pda, bump] = PublicKey.findProgramAddressSync(
        [
            Buffer.from(SEED)
        ],
        program.programId
    );
    return {
        address: pda,
        bump
    }
}

const SEED = "boss";
