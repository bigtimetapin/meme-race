import {AnchorProvider, Program, SplToken} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {Pda} from "./pda";
import {PublicKey} from "@solana/web3.js";
import {Contender, deriveContenderPda, getContenderPda} from "./contender-pda";
import {getManyWagerPda, Wager} from "./wager-pda";
import {deriveWagerIndexPda, getManyWagerIndexPda} from "./wager-index-pda";
import {SHDW} from "../util/constants";
import {deriveAtaPda} from "./ata-pda";

export interface DegenPda extends Pda {
}

export interface Degen {
    wallet: PublicKey
    contender: Contender | null
    wagers: Wager[]
    totalWagersPlaced: number
    shadow: {
        balance: number
    }
}

interface RawDegen {
    totalWagersPlaced: number
}

interface RawSplToken {
    mint: PublicKey
    amount: any // encoded as BN
}

export async function getDegenPda(
    provider: AnchorProvider,
    programs: {
        meme: Program<MemeRace>;
        token: Program<SplToken>
    },
    pda: DegenPda
): Promise<Degen> {
    // fetch wagers
    let wagers;
    let totalWagersPlaced;
    try {
        const fetchedDegen = await programs.meme.account.degen.fetch(
            pda.address
        ) as RawDegen;
        const wagerIndexPdaArray = Array.from(new Array(fetchedDegen.totalWagersPlaced), (_, ix) => {
                const index = ix + 1;
                return deriveWagerIndexPda(provider, programs.meme, index)
            }
        );
        const fetchedWagerIndexArray = await getManyWagerIndexPda(
            programs.meme,
            wagerIndexPdaArray
        );
        wagers = await getManyWagerPda(
            provider,
            programs.meme,
            fetchedWagerIndexArray.map(w => w.pda)
        );
        totalWagersPlaced = fetchedDegen.totalWagersPlaced;
    } catch (error) {
        console.log("no wagers found for this degen");
        wagers = [];
        totalWagersPlaced = 0;
    }
    // fetch contender
    const contenderPda = deriveContenderPda(
        provider,
        programs.meme
    );
    let maybeContender: Contender | null
    try {
        maybeContender = await getContenderPda(
            provider,
            programs.meme,
            contenderPda.address
        );
    } catch (error) {
        console.log("no contender found for this degen");
    }
    // fetch shadow balance
    const shdwAtaPda = deriveAtaPda(
        provider.wallet.publicKey,
        SHDW
    );
    let balance;
    try {
        const shdwAta = await programs.token.account.token.fetch(
            shdwAtaPda
        ) as RawSplToken;
        balance = shdwAta.amount.toNumber();
    } catch (error) {
        console.log("no existing balance found for $shdw token");
        balance = 0;
    }
    return {
        wallet: provider.wallet.publicKey,
        contender: maybeContender,
        wagers,
        totalWagersPlaced,
        shadow: {
            balance: balance
        }
    }
}

export function deriveDegenPda(provider: AnchorProvider, program: Program<MemeRace>): DegenPda {
    let pda, bump;
    [pda, bump] = PublicKey.findProgramAddressSync(
        [
            Buffer.from(SEED),
            provider.wallet.publicKey.toBuffer()
        ],
        program.programId
    );
    return {
        address: pda,
        bump
    }
}

const SEED = "degen";
