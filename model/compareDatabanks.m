function compareDatabanks(actDb, expDb)
    assertTol = @(a) assert(all(a(:)<=1e-14));
    listOfFields = fieldnames(actDb);
    for i = 1 : length(listOfFields)
        ithName = listOfFields{i};
        x = actDb.(ithName);
        y = expDb.(ithName);
        d = max(abs(x(:) - y(:)));
        assertTol(d);
    end
end

