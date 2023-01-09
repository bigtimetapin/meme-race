export type MemeRace = {
  "version": "0.1.0",
  "name": "meme_race",
  "instructions": [
    {
      "name": "initialize",
      "accounts": [
        {
          "name": "leaderBoard",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "boss",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "treasury",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "two",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    },
    {
      "name": "addContender",
      "accounts": [
        {
          "name": "contender",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "leaderBoard",
          "isMut": false,
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
      "args": [
        {
          "name": "url",
          "type": "publicKey"
        }
      ]
    },
    {
      "name": "addDegen",
      "accounts": [
        {
          "name": "degen",
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
    },
    {
      "name": "placeWager",
      "accounts": [
        {
          "name": "contender",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "wager",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "wagerIndex",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "degen",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "leaderBoard",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "boss",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "ata",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "treasury",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "wager",
          "type": "u64"
        }
      ]
    },
    {
      "name": "close",
      "accounts": [
        {
          "name": "leaderBoard",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "authority",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    },
    {
      "name": "claimFromPot",
      "accounts": [
        {
          "name": "winner",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "wager",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "leaderBoard",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "boss",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "ata",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "treasury",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "claimer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "tokenProgram",
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
            "name": "url",
            "type": "publicKey"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    },
    {
      "name": "degen",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "totalWagersPlaced",
            "type": "u8"
          }
        ]
      }
    },
    {
      "name": "leaderBoard",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "authority",
            "type": "publicKey"
          },
          {
            "name": "leader",
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
          },
          {
            "name": "total",
            "type": "u64"
          },
          {
            "name": "open",
            "type": "bool"
          }
        ]
      }
    },
    {
      "name": "wagerIndex",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "pda",
            "type": "publicKey"
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
            "name": "wagerSize",
            "type": "u64"
          },
          {
            "name": "wagerCount",
            "type": "u8"
          },
          {
            "name": "contender",
            "type": "publicKey"
          }
        ]
      }
    }
  ],
  "types": [
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
            "name": "pda",
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
          "name": "leaderBoard",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "boss",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "treasury",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "two",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    },
    {
      "name": "addContender",
      "accounts": [
        {
          "name": "contender",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "leaderBoard",
          "isMut": false,
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
      "args": [
        {
          "name": "url",
          "type": "publicKey"
        }
      ]
    },
    {
      "name": "addDegen",
      "accounts": [
        {
          "name": "degen",
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
    },
    {
      "name": "placeWager",
      "accounts": [
        {
          "name": "contender",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "wager",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "wagerIndex",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "degen",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "leaderBoard",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "boss",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "ata",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "treasury",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "payer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "tokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "associatedTokenProgram",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "systemProgram",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": [
        {
          "name": "wager",
          "type": "u64"
        }
      ]
    },
    {
      "name": "close",
      "accounts": [
        {
          "name": "leaderBoard",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "authority",
          "isMut": false,
          "isSigner": false
        }
      ],
      "args": []
    },
    {
      "name": "claimFromPot",
      "accounts": [
        {
          "name": "winner",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "wager",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "leaderBoard",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "boss",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "mint",
          "isMut": false,
          "isSigner": false
        },
        {
          "name": "ata",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "treasury",
          "isMut": true,
          "isSigner": false
        },
        {
          "name": "claimer",
          "isMut": true,
          "isSigner": true
        },
        {
          "name": "tokenProgram",
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
            "name": "url",
            "type": "publicKey"
          },
          {
            "name": "authority",
            "type": "publicKey"
          }
        ]
      }
    },
    {
      "name": "degen",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "totalWagersPlaced",
            "type": "u8"
          }
        ]
      }
    },
    {
      "name": "leaderBoard",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "authority",
            "type": "publicKey"
          },
          {
            "name": "leader",
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
          },
          {
            "name": "total",
            "type": "u64"
          },
          {
            "name": "open",
            "type": "bool"
          }
        ]
      }
    },
    {
      "name": "wagerIndex",
      "type": {
        "kind": "struct",
        "fields": [
          {
            "name": "pda",
            "type": "publicKey"
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
            "name": "wagerSize",
            "type": "u64"
          },
          {
            "name": "wagerCount",
            "type": "u8"
          },
          {
            "name": "contender",
            "type": "publicKey"
          }
        ]
      }
    }
  ],
  "types": [
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
            "name": "pda",
            "type": "publicKey"
          }
        ]
      }
    }
  ]
};
