import {Pda} from "./pda";
import {PublicKey} from "@solana/web3.js";
import {getMemeUrl, RawContender} from "./contender-pda";
import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {BONK_DECIMALS} from "../util/constants";

export interface WagerPda extends Pda {
}

export interface Wager {
    wagerSize: number
    wagerSizeFormatted: string
    wagerPercentage: string
    wagerCount: number
    contender: {
        pda: PublicKey,
        uploader: PublicKey,
        url: string
    }
}

export interface RawWager {
    wagerSize: any // decoded as BN
    wagerCount: number
    contender: PublicKey // pda pointer
    claimed: boolean
}

export async function getManyWagerPda(
    provider: AnchorProvider,
    program: Program<MemeRace>,
    pdaArray: PublicKey[]
): Promise<Wager[]> {
    // fetch raw wager array
    const fetchedWagers = (await program.account.wager.fetchMultiple(
        pdaArray
    )).filter(Boolean) as RawWager[];
    // fetch raw contender array
    const fetchedContenders = (await program.account.contender.fetchMultiple(
        fetchedWagers.map(f => f.contender)
    )).filter(Boolean) as RawContender[];
    // join
    return await Promise.all(
        fetchedWagers.map(async (wager) => {
            const contender_ = fetchedContenders.find(contender =>
                contender.pda.equals(wager.contender)
            ) as RawContender;
            const memeUrl = await getMemeUrl(
                contender_
            );
            return {
                wagerSize: wager.wagerSize.toNumber(),
                wagerSizeFormatted: (wager.wagerSize.toNumber() / BONK_DECIMALS).toLocaleString(),
                wagerPercentage: (100 * (wager.wagerSize.toNumber() / contender_.score.toNumber())).toString() + "%",
                wagerCount: wager.wagerCount,
                contender: {
                    pda: contender_.pda,
                    uploader: contender_.authority,
                    url: memeUrl
                }
            } as Wager
        })
    )
}

export async function getWagerPda(
    provider: AnchorProvider,
    program: Program<MemeRace>,
    pda: WagerPda
): Promise<Wager> {
    const fetchedWager = await program.account.wager.fetch(
        pda.address
    ) as RawWager;
    const fetchedContender = await program.account.contender.fetch(
        fetchedWager.contender
    ) as RawContender;
    const memeUrl = await getMemeUrl(
        fetchedContender
    );
    return {
        wagerSize: fetchedWager.wagerSize.toNumber(),
        wagerSizeFormatted: (fetchedWager.wagerSize.toNumber() / BONK_DECIMALS).toLocaleString(),
        wagerPercentage: (100 * (fetchedWager.wagerSize.toNumber() / fetchedContender.score.toNumber())).toString() + "%",
        wagerCount: fetchedWager.wagerCount,
        contender: {
            pda: fetchedWager.contender,
            uploader: fetchedContender.authority,
            url: memeUrl
        }
    }
}

export function deriveWagerPda(contender: PublicKey, provider: AnchorProvider, program: Program<MemeRace>): WagerPda {
    let pda, bump;
    [pda, bump] = PublicKey.findProgramAddressSync(
        [
            Buffer.from(SEED),
            contender.toBuffer(),
            provider.wallet.publicKey.toBuffer()
        ],
        program.programId
    );
    return {
        address: pda,
        bump
    }
}

const SEED = "wager";
