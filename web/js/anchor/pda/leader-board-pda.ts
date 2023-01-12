import {MemeRace} from "../idl/idl";
import {AnchorProvider, Program} from "@project-serum/anchor";
import {Pda} from "./pda";
import {PublicKey} from "@solana/web3.js";
import {Contender, getContenderPda, getManyContenderPda} from "./contender-pda";
import {BONK_DECIMALS} from "../util/constants";

export interface LeaderBoardPda extends Pda {
}

export interface LeaderBoard {
    authority: PublicKey
    leader: Contender
    race: Contender[]
    total: number
    totalFormatted: string
    open: boolean
}

interface RawLeaderBoard {
    authority: PublicKey
    leader: TopContender
    race: TopContender[]
    total: any // decoded as BN
    open: boolean
}

interface TopContender {
    score: any // decoded as BN
    pda: PublicKey // pda pointer
}

export async function getLeaderBoardPda(
    provider: AnchorProvider,
    program: Program<MemeRace>,
    pda: LeaderBoardPda
): Promise<LeaderBoard> {
    const fetched = await program.account.leaderBoard.fetch(
        pda.address
    ) as RawLeaderBoard;
    const leader = await getContenderPda(
        provider,
        program,
        fetched.leader.pda
    );
    const race = await getManyContenderPda(
        provider,
        program,
        fetched.race.map(c => c.pda)
    );
    return {
        authority: fetched.authority,
        leader,
        race,
        total: fetched.total.toNumber(),
        totalFormatted: (fetched.total.toNumber() * BONK_DECIMALS).toLocaleString(),
        open: fetched.open
    }
}

export function deriveLeaderBoardPda(program: Program<MemeRace>): LeaderBoardPda {
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

const SEED = "leader";
