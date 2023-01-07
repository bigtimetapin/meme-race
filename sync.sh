#!/usr/bin/env sh

## copy idl
cp ./target/types/meme_race.ts ./tests/idl.ts

## write program-id
INIT="export const PROGRAM_ID: string = "
PROGRAM_ID=$(solana address --keypair ./target/deploy/meme_race-keypair.json)
OUT="${INIT}\"${PROGRAM_ID}\""
echo $OUT > ./tests/program-id.ts
echo $OUT
