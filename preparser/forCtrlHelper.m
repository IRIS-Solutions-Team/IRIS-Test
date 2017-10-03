function forCtrlHelper(inpCode, expCode, assign)
    import parser.Preparser;
    try
        assign; 
    catch
        assign = struct( ); 
    end %#ok<VUNUS, NOCOM>
    actCode = Preparser.parse([ ], inpCode, assign);
    actCode = Preparser.removeInsignificantWhs(actCode);
    expCode = Preparser.removeInsignificantWhs(expCode);
    Assert.equal(actCode, expCode);
end
