Config = {}

Config.Debug = true
Config.DetectRange = 6.0
Config.CheckInterval = 15000
Config.NPCCooldown = 00

-- Safe rumor lines with voice speech keys
Config.RumorVoices = {
    {
        line = "INTERESTING_SITUATION",
        param = "SPEECH_PARAMS_FORCE",
        text = "Sunaicha, manche haru le chest bhitra gift card haru khojdaichan!"
    },
    {
        line = "GENERIC_CURSE_HIGH",
        param = "SPEECH_PARAMS_FORCE",
        text = "Kura cha re, euta naya jenis ko ganja aako cha — sabai tyahi khojdaichan!"
    },
    {
        line = "GREET_GENERAL",
        param = "SPEECH_PARAMS_FORCE",
        text = "chest kholna G thichnu pardo raixa!"
    },
    {
        line = "OFFER_GENERIC",
        param = "SPEECH_PARAMS_FORCE",
        text = "gift card gau gau ma xa rey aaile!"
    },
    {
        line = "RESPONSE_A",
        param = "SPEECH_PARAMS_FORCE",
        text = "gift card chai khojnu parcha hai!"
    },
    {
        line = "GENERIC_INSULT_HIGH",
        param = "SPEECH_PARAMS_FORCE",
        text = "Feri 5 ota steam gift card halya xa rey!"
    }
}

-- Only these models will be allowed to talk
Config.AllowedModels = {
    [104062879] = true,          -- u_m_m_valdeputy_01
    [2133848994] = true,         -- cs_valentinebartender
    [1124384604] = true,         -- cs_strsheriff_01
    [-1789856687] = true,        -- u_m_m_bht_skinner
    [-1234234638] = true,        -- u_m_m_unicorpse_01
    -- continue for rest
}


