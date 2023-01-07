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
    it("should race memes", async () => {
        // init
        let leaderPda, _;
        [leaderPda,] = web3.PublicKey.findProgramAddressSync(
            [
                Buffer.from("leader")
            ],
            new web3.PublicKey(PROGRAM_ID)
        );
        let contenderPda;
        [contenderPda,] = web3.PublicKey.findProgramAddressSync(
            [
                Buffer.from("contender")
            ],
            new web3.PublicKey(PROGRAM_ID)
        );
        const tx = await program.methods
            .initialize()
            .accounts(
                {
                    leader: leaderPda,
                    contender: contenderPda,
                    payer: provider.wallet.publicKey
                }
            ).transaction()
        console.log(tx);
    });
});
