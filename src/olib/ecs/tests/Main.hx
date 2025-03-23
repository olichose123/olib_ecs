package olib.ecs.tests;

import utest.Runner;
import utest.ui.Report;
import olib.ecs.tests.ECSTest;

class Main
{
    static function main()
    {
        var runner = new Runner();
        runner.addCase(new ECSTest());
        Report.create(runner);
        runner.run();
    }
}
