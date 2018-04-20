function Tests = x13Test()
Tests = functiontests(localfunctions);
end


%**************************************************************************


function This = setupOnce(This) %#ok<*DEFNU>
rng('default');
range = qq(2000,1:40);
x = tseries(range, @rand);
x = cumsumk(x, range);
This.TestData.X = x;
This.TestData.Range = range;
end % setupOnce()


%**************************************************************************


function testSeasonalDummy(This)
range = qq(2000,1):qq(2004,4);
x = tseries(range,[ ...
    6.0985
    0.5765
   -1.9609
    1.5728
    5.4119
    1.5889
   -2.5513
    2.2960
    4.5191
    2.5234
   -2.9608
   -0.5687
    3.7091
    3.6797
   -1.4803
   -0.9348
    2.6326
    3.9374
   -0.8797
    0.6971 ]);

d1 = tseries(range,0);
d1(qq(2002,1):end) = d1(qq(2002,1):end) + 1;

d2 = tseries(range,0);
d2(qq(2004,1):end) = d2(qq(2004,1):end) + 1;

x = x + d1 + d2;

actS = x12(x);
actS1 = x12(x,Inf,'dummy=',d1);
actS12 = x12(x,Inf,'dummy=',[d1,d2]);

expS = tseries(range,[ ...
   2.968901775236990
  -0.708463891097696
   1.502236858538930
   2.501352984514320
   2.346065048453710
   0.248166179439485
   0.883874708741181
   3.264488349769070
   2.535508805159890
   2.076166260061090
   1.444294607817820
   1.453200707777400
   1.807708398109820
   3.133148334573050
   2.904644889333820
   1.123876304548180
   1.790331561359420
   4.321420736785250
   4.496503722313180
   3.797603323823550
   ]);

expS1 = tseries(range,[ ...
   3.003035565891980
  -0.698917012165891
   1.497532012210730
   2.464109009504800
   2.377442008015950
   0.258818278756571
   0.878969673139568
   3.229300851738920
   2.220770020081840
   1.746637903015820
   1.096103676579400
   1.076597785107200
   1.493981632245740
   2.803123426594050
   2.555681698566440
   0.746818716940020
   1.478341481239680
   3.990662022086780
   4.146464230107800
   3.422435953834720]);

expS12 = tseries(range,[ ...
   3.091817870668350
  -0.640946119595630
   1.453388392452170
   2.352565480893320
   2.479114600471000
   0.314885567293178
   0.834489000618375
   3.100207138336400
   2.621725526936560
   2.066723351971110
   1.323411326217440
   1.210624119053900
   1.896818293715720
   3.127475751351280
   2.788385336167070
   0.869109197988527
   0.484709447921649
   2.919912476525220
   2.982451512496400
   2.136182829967600]);

assertEqual(This,actS(range),expS(range), ...
    'absTol',1e-6);
assertEqual(This,actS1(range),expS1(range), ...
    'absTol',1e-6);
assertEqual(This,actS12(range),expS12(range), ...
    'absTol',1e-6);
end % testSeasonalDummy()


%**************************************************************************


function testBackcastForecast(This)
x = This.TestData.X;
range = This.TestData.Range;
range3 = range(5:end-5);
[sa1,~,~,~,bf1] = x12(x,'forecast=',8,'backcast=',8);
[sa2,~,~,~,bf2] = x12(x,range,'forecast=',8,'backcast=',8);
[sa3,~,~,~,bf3] = x12(x,range3,'forecast=',8,'backcast=',8);
[sa4,~,~,~,bf4] = x12(x{range3},'forecast=',8,'backcast=',8);
assertEqual(This,sa1(:),sa2(:));
assertEqual(This,bf1(:),bf2(:));
assertEqual(This,bf1(range3),bf3(range3));
assertEqual(This,sa3(:),sa4(:));
assertEqual(This,bf3(:),bf4(:));
end % testBackcastForecast()


%**************************************************************************


function testMultiOutp(This)
x = This.TestData.X;
range = This.TestData.Range;
range = range(5:end-5);
[sa1,sf1,tc1,ir1] = x12(x,'output=','sa,sf,tc,ir','mode=','add');
[sa2,sf2,tc2,ir2] = x12(x{range},'output=','sa,sf,tc,ir','mode=','add');
[sa3,sf3,tc3,ir3] = x12(x,range,'output=','sa,sf,tc,ir','mode=','add');
assertEqual(This,sa1(:)+sf1(:),x(:),'AbsTol',1e-8);
assertEqual(This,tc1(:)+ir1(:),sa1(:),'AbsTol',1e-8);
assertEqual(This,sa2(:)+sf2(:),x(range),'AbsTol',1e-8);
assertEqual(This,tc3(:)+ir2(:),sa2(:),'AbsTol',1e-8);
assertEqual(This,sa3(:)+sf3(:),sa2(:)+sf2(:),'AbsTol',1e-8);
assertEqual(This,tc3(:)+ir3(:),tc2(:)+ir2(:),'AbsTol',1e-8);
end % testMultiOutp()
