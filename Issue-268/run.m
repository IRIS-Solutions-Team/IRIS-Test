
close all
clear

m = Model("basic.model", "Growth", true);

m = steady(m, "NaNInit", 1);
checkSteady(m)

