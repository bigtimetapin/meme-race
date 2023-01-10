import {Pda} from "./pda";
import {AnchorProvider, Program} from "@project-serum/anchor";
import {MemeRace} from "../idl/idl";
import {PublicKey} from "@solana/web3.js";
import {deriveWagerPda, RawWager} from "./wager-pda";

export interface ContenderPda extends Pda {
}

export interface Contender {
    score: string
    wager: string | null
    url: string
    authority: PublicKey
    pda: PublicKey
}

export interface RawContender {
    score: any // decoded as BN
    url: PublicKey
    authority: PublicKey
    pda: PublicKey
}

export async function getManyContenderPda(
    provider: AnchorProvider,
    program: Program<MemeRace>,
    pdaArray: ContenderPda[]
): Promise<Contender[]> {
    // fetch raw contender array
    const rawContenders = (await program.account.contender.fetchMultiple(
        pdaArray.map(pda => pda.address)
    )).filter(Boolean) as RawContender[];
    // fetch raw wager array
    const wagerPdaArray = rawContenders.map(rawContender =>
        deriveWagerPda(rawContender.pda, provider, program).address
    );
    const rawWagers = (await program.account.wager.fetchMultiple(
        wagerPdaArray
    )).filter(Boolean) as RawWager[];
    // join
    return await Promise.all(
        rawContenders.map(async (rawContender) => {
                // look for wager
                let wager: string | null;
                const maybeWager = rawWagers.find(
                    w => w.contender.equals(rawContender.pda)
                );
                if (maybeWager) {
                    wager = maybeWager.wagerSize.toNumber().toLocaleString();
                }
                // fetch meme url
                const url = await getMemeUrl(
                    rawContender
                );
                return {
                    score: rawContender.score.toNumber().toLocaleString(),
                    wager,
                    url,
                    authority: rawContender.authority,
                    pda: rawContender.pda
                } as Contender
            }
        )
    )
}

export async function getContenderPda(
    provider: AnchorProvider,
    program: Program<MemeRace>,
    pda: PublicKey
): Promise<Contender> {
    // fetch raw pda
    const fetched = await program.account.contender.fetch(
        pda
    ) as RawContender;
    console.log(fetched);
    return await rawToPolished(
        fetched,
        provider,
        program
    )
}

export async function getMemeUrl(rawContender: RawContender): Promise<string> {
    const baseUrl = buildUrl(
        rawContender.url
    );
    console.log(baseUrl);
    const metadata = await getMetadata(
        baseUrl
    );
    const url = baseUrl + metadata.meme;
    console.log(url)
    return url
}

async function rawToPolished(
    raw: RawContender,
    provider: AnchorProvider,
    program: Program<MemeRace>
): Promise<Contender> {
    // fetch meme url
    const url = await getMemeUrl(
        raw
    );
    // check for wager
    const wagerPda = deriveWagerPda(
        raw.pda,
        provider,
        program
    );
    let wager: string | null;
    try {
        const wager_ = await program.account.wager.fetch(
            wagerPda.address
        ) as RawWager;
        console.log(wager_);
        console.log(wager_.wagerSize);
        wager = (wager_.wagerSize).toNumber().toLocaleString();
    } catch (error) {
        console.log("no wagers placed on this contender");
        wager = null;
    }
    return {
        score: raw.score.toNumber().toLocaleString(),
        wager: wager,
        url: url,
        authority: raw.authority,
        pda: raw.pda
    }
}

export function deriveContenderPda(provider: AnchorProvider, program: Program<MemeRace>): ContenderPda {
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

interface Metadata {
    meme: string // file name
}

function encodeMetadata(metadata: Metadata): File {
    const json = JSON.stringify(metadata);
    const textEncoder = new TextEncoder();
    const bytes = textEncoder.encode(json);
    const blob: Blob = new Blob([bytes], {
        type: "application/json;charset=utf-8"
    });
    return new File([blob], "meta.json");
}

async function getMetadata(url): Promise<Metadata> {
    console.log("fetching meta-data");
    const fetched = await fetch(url + "meta.json")
        .then(response => response.json());
    return {
        meme: fetched.meme
    }
}

const URL_PREFIX = "https://shdw-drive.genesysgo.net/";

function buildUrl(shadowAccount: PublicKey) {
    return (URL_PREFIX + shadowAccount.toString() + "/")
}

const SEED = "contender";
