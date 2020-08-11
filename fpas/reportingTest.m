
this = matlab.unittest.FunctionTestCase.fromFunction(@(x)x);

% Set up Once
    % ranges
    rngPlot = qq(2000, 1) : qq(2015, 4);
    this.TestData.rngPlot = rngPlot;
    this.TestData.hlight = rngPlot(end-8) : rngPlot(end);
    % temporary folder
    this.TestData.outFolder = fullfile(fileparts(mfilename('fullpath')),...
      'fpas_report_results');
    if exist(this.TestData.outFolder,'dir')
      rmdir(this.TestData.outFolder,'s');
    end
    mkdir(this.TestData.outFolder);
    % data
    db = struct();
    db.x = hpf2(cumsum(tseries(rngPlot, @randn)));
    db.y = hpf2(cumsum(tseries(rngPlot, @randn)));
    db.z = hpf2(cumsum(tseries(rngPlot, @randn)));
    db.a = hpf2(cumsum(tseries(rngPlot, @randn)));
    db.b = hpf2(cumsum(tseries(rngPlot, @randn)));
    this.TestData.db = db;
    % styles
    sty = struct();
    sty.line.linewidth = 2;
    sty.line.linestyle = {'-';'--'};
    sty.axes.box = 'off';
    sty.legend.location = 'best';
    decompsty = sty;
    decompsty.legend.location = 'northOutside';
    decompsty.legend.orientation = 'horizontal';
    tblOptions = {...
      'range', rngPlot(end-16) : rngPlot(end), ...
      'long', false, ...
      };
    tblOptionsLong = {...
      'range', rngPlot(end-16) : rngPlot(end), ...
      'long', true, ...
      'longFoot', 'See next page...', ...
      'longFootPosition', 'center', ...
      };
    this.TestData.sty = sty;
    this.TestData.decompsty = decompsty;
    this.TestData.tblOptions = tblOptions;
    this.TestData.tblOptionsLong = tblOptionsLong;
    % display pdflatex version
    [stat,outStr] = system([irisget('pdflatexpath'),' --version']);
    if stat == 0
      fprintf('Version of PdfLaTeX is:\n==\n%s\n==\n',outStr);
    else
      disp('Unable to get the version of PdfLaTeX.');
    end
    close all



%% Test Generate Empty Report
    % generate report
    rep = report.new('Testing Report');
    fileName = fullfile(this.TestData.outFolder ,'report_empty.pdf');
    rep.publish(fileName,'maketitle',true,'papersize','a4paper',...
      'display',true,'echo',true);
    % check if the file exists
    if (~exist(fileName,'file'))
      error('IrisTestSuite:customException',['Unable to generate PDF report.',...
        ' If the last warning is of any help, it was:\n%s\n'],lastwarn);
    end
    close all



%% Test User Figure Report
    % load data
    rngPlot = this.TestData.rngPlot;
    hlight = this.TestData.hlight;
    db = this.TestData.db;
    % generate report
    rep = report.new('Testing User Figure Report');
    % user figure
    figure('visible','off');
      subplot(221);
        g=plot(rngPlot,[db.x,db.y], 'dateformat','YYFP'); hold on;
        set(g,{'linewidth'},{2;2});
        set(g,{'linestyle'},{'-';'-'}); 
        title('x and y');
        legend('x','y');
        highlight(hlight);
      subplot(222);
        g=plot(rngPlot,[db.x,db.z], 'dateformat','YYFP'); hold on;
        set(g,{'linewidth'},{2;2});
        set(g,{'linestyle'},{'-';'-'}); 
        title('x and z');
        legend('x','z');
        highlight(hlight);
      subplot(223);
        g=plot(rngPlot,[db.a,db.b], 'dateformat','YYFP'); hold on;
        set(g,{'linewidth'},{2;2});
        set(g,{'linestyle'},{'-';'-'}); 
        title('a and b');
        legend('a','b');
        highlight(hlight);
      subplot(224);
        g=plot(rngPlot,[db.x,db.y], 'dateformat','YYFP'); hold on;
        set(g,{'linewidth'},{2;2});
        set(g,{'linestyle'},{'-';'-'});
        zeroline('color','k','linewidth',0.75);
        title('x and y');
        highlight(hlight);
    rep.userfigure('Testing User Figure',gcf,'figurescale',0.9);
    fileName = fullfile(this.TestData.outFolder ,'report_user_figure.pdf');
    rep.publish(fileName,'maketitle',false,'papersize','a4paper',...
      'display',true,'echo',true);
    % check if the file exists
    if (~exist(fileName,'file'))
      error('IrisTestSuite:customException',['Unable to generate PDF report.',...
        ' If the last warning is of any help, it was:\n%s\n'],lastwarn);
    end
    close all


%% Test Regular Line Figure Report
    % load data
    rngPlot = this.TestData.rngPlot;
    hlight = this.TestData.hlight;
    sty = this.TestData.sty;
    db = this.TestData.db;
    % generate report
    rep = report.new('Testing Regular Line Figure Report');
    % regular figure 2x2 with lines
    rep.figure('Testing 2x2 Figure with Regular Lines','subplot',[2 2],...
      'range',rngPlot);
      rep.graph('x and y', 'style', sty, 'legend', true);
        rep.series('x', db.x);
        rep.series('y', db.y);
        rep.highlight('', hlight);
      rep.graph('x and z', 'style', sty, 'legend', true);
        rep.series('x', db.x);
        rep.series('z', db.z);
        rep.highlight('', hlight);
      rep.graph('a and b', 'style', sty, 'legend', true);
        rep.series('a', db.a);
        rep.series('b', db.b);
        rep.highlight('', hlight);
      rep.graph('x and y', 'style', sty, 'legend', false, 'zeroline', true);
        rep.series('x', db.x);
        rep.series('y', db.y);
        rep.highlight('', hlight);
    fileName = fullfile(this.TestData.outFolder ,'report_regular_line.pdf');
    rep.publish(fileName,'maketitle',false,'papersize','a4paper',...
      'display',true,'echo',true);
    % check if the file exists
    if (~exist(fileName,'file'))
      error('IrisTestSuite:customException',['Unable to generate PDF report.',...
        ' If the last warning is of any help, it was:\n%s\n'],lastwarn);
    end
    close all



%% Test Line and Conbar Figure Report
    % load data
    rngPlot = this.TestData.rngPlot;
    hlight = this.TestData.hlight;
    sty = this.TestData.sty;
    decompsty = this.TestData.decompsty;
    db = this.TestData.db;
    % generate report
    rep = report.new('Testing Line and Conbar Figure Report Report');
    % regular figure 2x1
    rep.figure('Testing 2x1 Figure with Lines and Conbars', ...
      'dateFormat','YYfP','range',rngPlot);
      rep.graph('a and b', 'style', sty, 'legend', true);
        rep.series('a', db.a);
        rep.series('b', db.b);
        rep.highlight('', hlight);
      rep.graph('testing conbar', 'style', decompsty, 'legend', true);
        rep.series('', [db.x, db.y, db.z, db.a-(db.x+db.y+db.z)],...
          'legend', {'x','y','z','res a'},...
          'plotfunc', @conbar);
        rep.series('a', db.a);
        rep.highlight('', hlight);
    fileName = fullfile(this.TestData.outFolder ,'report_line_and_conbar.pdf');
    rep.publish(fileName,'maketitle',false,'papersize','a4paper',...
      'display',true,'echo',true);
    % check if the file exists
    if (~exist(fileName,'file'))
      error('IrisTestSuite:customException',['Unable to generate PDF report.',...
        ' If the last warning is of any help, it was:\n%s\n'],lastwarn);
    end
    close all


%% Test Short Table Report
    % load data
    hlight = this.TestData.hlight;
    db = this.TestData.db;
    tblOptions = this.TestData.tblOptions;
    % generate report
    rep = report.new('Testing Short Table Report');
    % short table
    rep.table('Testing Short Table', tblOptions{:});
      rep.subheading('');
      rep.subheading('x, y and z');
      rep.series('x', db.x, 'units', '% p.a.', 'highlight', hlight);
      rep.series('y', db.y, 'units', 'p.p.',   'highlight', hlight);
      rep.series('z', db.z, 'units', '% YoY',  'highlight', hlight);
      rep.subheading('');
      rep.subheading('a and b');
      rep.series('a', db.a, 'units', '% p.a.', 'highlight', hlight);
      rep.series('b', db.b, 'units', '% p.a.', 'highlight', hlight);
    fileName = fullfile(this.TestData.outFolder ,'report_short_table.pdf');
    rep.publish(fileName,'maketitle',false,'papersize','a4paper',...
      'display',true,'echo',true);
    % check if the file exists
    if (~exist(fileName,'file'))
      error('IrisTestSuite:customException',['Unable to generate PDF report.',...
        ' If the last warning is of any help, it was:\n%s\n'],lastwarn);
    end
    close all



%% Test Long Table Report
    % load data
    hlight = this.TestData.hlight;
    db = this.TestData.db;
    tblOptions = this.TestData.tblOptionsLong;
    % generate report
    rep = report.new('Testing Long Table Report');
    % long table
    rep.table('Testing Long Table', tblOptions{:});
      rep.subheading('');
      rep.subheading('x, y and many zs');
      rep.series('x', db.x, 'units', '% p.a.', 'highlight', hlight);
      rep.series('y', db.y, 'units', 'p.p.',   'highlight', hlight);
    for ix = 1 : 30
      rep.series('z', db.z, 'units', '% YoY',  'highlight', hlight);
    end
    fileName = fullfile(this.TestData.outFolder ,'report_long_table.pdf');
    rep.publish(fileName,'maketitle',false,'papersize','a4paper',...
      'display',true,'echo',true);
    % check if the file exists
    if (~exist(fileName,'file'))
      error('IrisTestSuite:customException',['Unable to generate PDF report.',...
        ' If the last warning is of any help, it was:\n%s\n'],lastwarn);
    end
    close all

