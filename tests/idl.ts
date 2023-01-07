export type MemeRace = {
  "version": "0.1.0",
  "name": "meme_race",
  "instructions": [
    {
      "name": "initialize",
      "accounts": [
        {
          "name": "leader",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "contender",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    }
  ],
  "accounts": [
    {
      "name": "boss",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "mint",
            "type": "publicKey"
          },
          {
            "name": "one",
            "type": "publicKey"
          },
          {
            "name": "two",
            "type": "publicKey"
          }
        ]
      }
    },
    {
      "name": "contender",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "score",
            "type": "u64"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    },
    {
      "name": "leader",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "score",
            "type": "u64"
          },
          {
            "name": "leader",
            "type": "publicKey"
          },
          {
            "name": "race",
            "type": {
              "defined": "Race"
            }
          }
        ]
      }
    },
    {
      "name": "wager",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "wager",
            "type": "u64"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    }
  ],
  "types": [
    {
      "name": "Race",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "min",
            "type": {
              "defined": "TopContender"
            }
          },
          {
            "name": "max",
            "type": {
              "defined": "TopContender"
            }
          },
          {
            "name": "race",
            "type": {
              "vec": {
                "defined": "TopContender"
              }
            }
          }
        ]
      }
    },
    {
      "name": "TopContender",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "score",
            "type": "u64"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    }
  ]
};

export const IDL: MemeRace = {
  "version": "0.1.0",
  "name": "meme_race",
  "instructions": [
    {
      "name": "initialize",
      "accounts": [
        {
          "name": "leader",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "contender",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    }
  ],
  "accounts": [
    {
      "name": "boss",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "mint",
            "type": "publicKey"
          },
          {
            "name": "one",
            "type": "publicKey"
          },
          {
            "name": "two",
            "type": "publicKey"
          }
        ]
      }
    },
    {
      "name": "contender",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "score",
            "type": "u64"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    },
    {
      "name": "leader",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "score",
            "type": "u64"
          },
          {
            "name": "leader",
            "type": "publicKey"
          },
          {
            "name": "race",
            "type": {
              "defined": "Race"
            }
          }
        ]
      }
    },
    {
      "name": "wager",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "wager",
            "type": "u64"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    }
  ],
  "types": [
    {
      "name": "Race",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "min",
            "type": {
              "defined": "TopContender"
            }
          },
          {
            "name": "max",
            "type": {
              "defined": "TopContender"
            }
          },
          {
            "name": "race",
            "type": {
              "vec": {
                "defined": "TopContender"
              }
            }
          }
        ]
      }
    },
    {
      "name": "TopContender",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "score",
            "type": "u64"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    }
  ]
};
