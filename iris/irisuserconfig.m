function x = irisuserconfig(x)
    global IRIS_USER_CONFIG
    if isstruct(IRIS_USER_CONFIG)
        x.userdata = IRIS_USER_CONFIG.UserData;
        x.freqletters = IRIS_USER_CONFIG.FreqLetters;
    end
end%
