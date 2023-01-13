import {getPhantom, getPhantomProvider} from "./phantom";
import {getEphemeralPP, getPP} from "./anchor/util/context";
import {initialize} from "./anchor/methods/initialize";
import {addContender} from "./anchor/methods/add-contender";
import {getGlobal} from "./anchor/pda/get-global";
import {deriveDegenPda, getDegenPda} from "./anchor/pda/degen-pda";
import {deriveContenderPda, getContenderPda} from "./anchor/pda/contender-pda";
import {placeWager} from "./anchor/methods/place-wager";
import {PublicKey} from "@solana/web3.js";
import {deriveLeaderBoardPda, getLeaderBoardPda} from "./anchor/pda/leader-board-pda";
import {close} from "./anchor/methods/close";
import {claimWithWager} from "./anchor/methods/claim-with-wager";
import {claimAsUploader} from "./anchor/methods/claim-as-uploader";

// init phantom
let phantom = null;

export async function main(app, json) {
    console.log(json);
    try {
        // parse json as object
        const parsed = JSON.parse(json);
        // match on sender role
        const sender = parsed.sender;
        // listen for connect
        if (sender === "connect") {
            // get phantom
            phantom = await getPhantom(app);
            if (phantom) {
                // get provider & program
                const pp = getPP(phantom);
                // get global
                await getGlobal(
                    app,
                    pp.provider,
                    pp.programs
                );
            }
            // or listen for disconnect
        } else if (sender === "disconnect") {
            // TODO; href to top
            phantom.windowSolana.disconnect();
            phantom = null;
            app.ports.success.send(
                JSON.stringify(
                    {
                        listener: "global-found-wallet-disconnected"
                    }
                )
            );
        } else if (sender === "leader-board-fetch") {
            // get provider & program
            let pp;
            if (phantom) {
                pp = getPP(phantom);
            } else {
                pp = getEphemeralPP();
            }
            // get leader-board
            const leaderBoardPda = deriveLeaderBoardPda(
                pp.programs.meme
            );
            const leaderBoard = await getLeaderBoardPda(
                pp.provider,
                pp.programs.meme,
                leaderBoardPda
            );
            console.log(leaderBoard);
            app.ports.success.send(
                JSON.stringify(
                    {
                        listener: "leader-board-fetched",
                        more: JSON.stringify(
                            leaderBoard
                        )
                    }
                )
            );
            // contender fetch
        } else if (sender === "contender-fetch") {
            // get provider & program
            let pp;
            if (phantom) {
                pp = getPP(phantom);
            } else {
                pp = getEphemeralPP();
            }
            // parse more json
            const more = JSON.parse(parsed.more);
            // fetch contender
            const contender = await getContenderPda(
                pp.provider,
                pp.programs.meme,
                more.pda
            );
            app.ports.success.send(
                JSON.stringify(
                    {
                        listener: "contender-fetched",
                        more: JSON.stringify(
                            contender
                        )
                    }
                )
            );
            // contender place new wager
        } else if (sender === "contender-place-new-wager") {
            // parse more json
            const more = JSON.parse(parsed.more);
            // get phantom
            phantom = await getPhantom(app);
            if (phantom) {
                // get provider & program
                const pp = getPP(phantom);
                // build form
                let form = more;
                form.contender = {
                    pda: new PublicKey(
                        form.contender.pda
                    )
                };
                console.log(form);
                // invoke rpc
                await placeWager(
                    app,
                    pp.provider,
                    pp.programs,
                    more
                );
            } else {
                const browse = "https://phantom.app/ul/browse/";
                const dap = "https://meme-race.com/#/contender/" + more.contender.pda;
                const href = browse + encodeURIComponent(dap);
                app.ports.exception.send(
                    JSON.stringify(
                        {
                            message: "It looks like there's no wallet installed!",
                            href: {
                                url: href,
                                internal: true
                            }
                        }
                    )
                );
            }
            // degen add contender
        } else if (sender === "degen-add-new-contender") {
            // get provider & program
            const pp = getPP(phantom);
            // parse more json
            const more = JSON.parse(parsed.more);
            // invoke rpc
            await addContender(
                app,
                pp.provider,
                pp.programs,
                more
            );
            // degen refresh shadow balance
        } else if (sender === "degen-refresh-shadow-balance") {
            // get provider & program
            const pp = getPP(phantom);
            // get degen
            const degenPda = deriveDegenPda(
                pp.provider,
                pp.programs.meme
            );
            const degen = await getDegenPda(
                pp.provider,
                pp.programs,
                degenPda
            );
            app.ports.success.send(
                JSON.stringify(
                    {
                        listener: "degen-refreshed-shadow-balance",
                        more: JSON.stringify(
                            degen
                        )
                    }
                )
            );
            // leader-board claim with wager
        } else if (sender === "leader-board-claim-with-wager") {
            // get phantom
            phantom = await getPhantom(app);
            // get provider & program
            const pp = getPP(phantom);
            // invoke rpc
            await claimWithWager(
                app,
                pp.provider,
                pp.programs.meme
            );
            // leader-board claim as uploader
        } else if (sender === "leader-board-claim-as-uploader") {
            // get phantom
            phantom = await getPhantom(app);
            // get provider & program
            const pp = getPP(phantom);
            // invoke rpc
            await claimAsUploader(
                app,
                pp.provider,
                pp.programs.meme
            );
            // admin init
        } else if (sender === "admin-init") {
            // get phantom
            phantom = await getPhantom(app);
            // get provider & program
            const pp = getPP(phantom);
            // invoke rpc
            await initialize(
                pp.provider,
                pp.programs.meme
            );
            // admin close
        } else if (sender === "admin-close") {
            // get phantom
            phantom = await getPhantom(app);
            // get provider & program
            const pp = getPP(phantom);
            // invoke rpc
            await close(
                pp.provider,
                pp.programs.meme
            );
            // or throw error
        } else {
            const msg = "invalid role sent to js: " + sender;
            app.ports.exception.send(
                JSON.stringify(
                    {
                        message: msg
                    }
                )
            );
        }
    } catch (error) {
        console.log(error);
        app.ports.exception.send(
            JSON.stringify(
                {
                    message: error.toString()
                }
            )
        );
    }
}

export async function onWalletChange(app) {
    const phantomProvider = getPhantomProvider();
    if (phantomProvider) {
        phantomProvider.on("accountChanged", async () => {
            console.log("wallet changed");
            // fetch state if previously connected
            if (phantom) {
                phantom = await getPhantom(app);
                const pp = getPP(phantom);
                await getGlobal(
                    app,
                    pp.provider,
                    pp.programs
                );
            }
        });
    }
}
