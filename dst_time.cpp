#include<iostream>
#include<string>
#include<stdio.h>
#include<assert.h>

using namespace std;
typedef unsigned int uint32;

static time_t GetZeroClock(time_t ut)
{
    tm lt = *localtime(&ut);
    time_t zut = (time_t)((uint32)ut - (lt.tm_hour * 3600 + lt.tm_min * 60 + lt.tm_sec));
    tm zlt = *localtime(&zut);
    if (zlt.tm_hour != 0) {
        if (zlt.tm_hour == 1) return zut - 3600;
        else if (zlt.tm_hour == 23) return zut + 3600;
        else assert(false);
    }
    else {
        return zut;
    }
}

static time_t GetSixClock(time_t ut)
{
    tm lt = *localtime(&ut);
    time_t sut = 0;
    if (lt.tm_hour < 6)
        sut = (time_t)((uint32)ut - ((18 + lt.tm_hour) * 3600 + lt.tm_min * 60 + lt.tm_sec));
    else if (lt.tm_hour >= 6)
        sut = (time_t)((uint32)ut - ((lt.tm_hour - 6) * 3600 + lt.tm_min * 60 + lt.tm_sec));
    tm slt = *localtime(&sut);
    if (slt.tm_hour != 6) {
        if (slt.tm_hour == 7) return sut - 3600;
        else if (slt.tm_hour == 5) return sut + 3600;
        else { assert(false);}
    }
    else {
        return sut;
    }
}

static time_t GetMondayZeroClock(time_t ut)
{
    time_t zut = GetZeroClock(ut);
    tm lt = *localtime(&zut);
    uint32 wday = (lt.tm_wday==0 ? 7 : lt.tm_wday) - 1;
    time_t wzut = (time_t)((uint32)zut - wday * 86400);
    tm wzlt = *localtime(&wzut);
    if (wzlt.tm_hour != 0) {
        if (wzlt.tm_hour == 1) return wzut - 3600;
        else if (wzlt.tm_hour == 23) return wzut + 3600;
        else assert(false);
    }
    else {
        return wzut;
    }
}

static time_t GetMondaySixClock(time_t ut)
{
    time_t sut = GetSixClock(ut);
    tm lt = *localtime(&sut);
    uint32 wday = (lt.tm_wday==0 ? 7 : lt.tm_wday) - 1;
    time_t wsut = (time_t)((uint32)sut - wday * 86400);
    tm wslt = *localtime(&wsut);
    if (wslt.tm_hour != 6) {
        if (wslt.tm_hour == 7) return wsut - 3600;
        else if (wslt.tm_hour == 5) return wsut + 3600;
        else { assert(false);}
    }
    else {
        return wsut;
    }
}


static const string ts(time_t ut)
{
    static char buff[200] = {0};
    tm lt = *localtime(&ut);
    sprintf(buff, "%d/%02d/%02d %02d:%02d:%02d isdst(%d)", 1900+lt.tm_year, 1+lt.tm_mon, lt.tm_mday, 
    							lt.tm_hour, lt.tm_min, lt.tm_sec, lt.tm_isdst);
    return buff;
}

static void test(uint32 year, uint32 mon, uint32 day, uint32 hour = 0, uint32 min = 0, uint32 sec = 0)
{
    assert(mon>=1 and mon<=12);
    assert(day>=1 and day<=31);
    assert(hour>=0 and hour<=23);
    tm lt;
    memset(&lt, 0, sizeof(struct tm));
    lt.tm_year = year - 1900;
    lt.tm_mon = mon - 1;
    lt.tm_mday = day;
    lt.tm_hour = hour;
    lt.tm_min = min;
    lt.tm_sec = sec;
    time_t ut = mktime(&lt);
    if (lt.tm_isdst == 1) ut = ut - 3600;
    time_t zut = GetZeroClock(ut);
    time_t sut = GetSixClock(ut);
    time_t wzut = GetMondayZeroClock(ut);
    time_t wsut = GetMondaySixClock(ut);
    printf("----(%d,%s)\n---0(%d,%s)\n---6(%d,%s)\nmon0(%d,%s)\nmon6(%d,%s)\n\n", ut, ts(ut).c_str(), zut, ts(zut).c_str(), sut, ts(sut).c_str(), wzut, ts(wzut).c_str(), wsut, ts(wsut).c_str());
}

// +0200: 3.27 2:00 dst start; 10.30 3:00 dst end.
int main(int argc, char** argv)
{
    for (uint32 hour = 0; hour < 12; hour++) {
        test(2016, 3, 27, hour);
        test(2016, 3, 27, hour, 30);
    }
    for (uint32 hour = 0; hour < 12; hour++) {
        test(2016, 10, 30, hour);
        test(2016, 10, 30, hour, 30);
    }
	return 0;
}
