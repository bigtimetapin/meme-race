import {AnchorProvider, Program, web3} from "@project-serum/anchor";
import {PROGRAM_ID} from "./program-id";
import {IDL, MemeRace} from "./idl";

describe("meme-race", () => {
    // Configure the client to use the local cluster.
    const provider: AnchorProvider = AnchorProvider.local();
    const program = new Program<MemeRace>(
        IDL,
        PROGRAM_ID,
        provider
    );
    const SPL_TOKEN_PROGRAM_ID = new web3.PublicKey('TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA');
    const SPL_ASSOCIATED_TOKEN_PROGRAM_ID = new web3.PublicKey('ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL');
    it("should race memes", async () => {
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // init ////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // derive leader pda
        let leaderPda, _;
        [leaderPda,] = web3.PublicKey.findProgramAddressSync(
            [
                Buffer.from("leader")
            ],
            new web3.PublicKey(PROGRAM_ID)
        );
        // derive boss pda
        let bossPda;
        [bossPda,] = web3.PublicKey.findProgramAddressSync(
            [
                Buffer.from("boss")
            ],
            new web3.PublicKey(PROGRAM_ID)
        );
        // derive new keypair as two
        const two = new web3.Keypair();
        // derive new keypair as mint
        const mint = new web3.Keypair();
        // invoke rpc
        // TODO; these tests gonna fail 'cause local host . . . accounts not init, etc . . . devnet??
        await program.methods
            .initialize()
            .accounts(
                {
                    leader: leaderPda,
                    mint: mint.publicKey,
                    boss: bossPda,
                    payer: provider.wallet.publicKey,
                    two: two.publicKey,
                    tokenProgram: SPL_TOKEN_PROGRAM_ID,
                }
            ).rpc()
    });
});
