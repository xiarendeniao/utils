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

static time_t GetNextZeroClock(time_t unixtime)
{
    time_t ut = GetZeroClock(unixtime);
    ut = ut + 86400;
    tm lt = *localtime(&ut);
    if (lt.tm_hour != 0) {
        if (lt.tm_hour == 1) return ut - 3600;
        else if (lt.tm_hour == 23) return ut + 3600;
        else assert(false);
    }
    else {
        return ut;
    }
}

static time_t GetNextSixClock(time_t unixtime)
{
    time_t ut = GetSixClock(unixtime);
    ut = ut + 86400;
    tm lt = *localtime(&ut);
    if (lt.tm_hour != 6) {
        if (lt.tm_hour == 7) return ut - 3600;
        else if (lt.tm_hour == 5) return ut + 3600;
        else { assert(false);}
    }
    else {
        return ut;
    }
}

static time_t GetMondayZeroClock(time_t unixtime)
{
    time_t ut = GetZeroClock(unixtime);
    tm lt = *localtime(&ut);
    uint32 wday = (lt.tm_wday==0 ? 7 : lt.tm_wday) - 1;
    ut = (time_t)((uint32)ut - wday * 86400);
    lt = *localtime(&ut);
    if (lt.tm_hour != 0) {
        if (lt.tm_hour == 1) return ut - 3600;
        else if (lt.tm_hour == 23) return ut + 3600;
        else assert(false);
    }
    else {
        return ut;
    }
}

static time_t GetMondaySixClock(time_t unixtime)
{
    time_t ut = GetSixClock(unixtime);
    tm lt = *localtime(&ut);
    uint32 wday = (lt.tm_wday==0 ? 7 : lt.tm_wday) - 1;
    ut = (time_t)((uint32)ut - wday * 86400);
    lt = *localtime(&ut);
    if (lt.tm_hour != 6) {
        if (lt.tm_hour == 7) return ut - 3600;
        else if (lt.tm_hour == 5) return ut + 3600;
        else { assert(false);}
    }
    else {
        return ut;
    }
}

static time_t GetNextMondayZeroClock(time_t unixtime)
{
    time_t ut = GetMondayZeroClock(unixtime);
    ut = ut + 604800;
    tm lt = *localtime(&ut);
    if (lt.tm_hour != 0) {
        if (lt.tm_hour == 1) return ut - 3600;
        else if (lt.tm_hour == 23) return ut + 3600;
        else assert(false);
    }
    else {
        return ut;
    }
}

static time_t GetNextMondaySixClock(time_t unixtime)
{
    time_t ut = GetMondaySixClock(unixtime);
    ut = ut + 604800;
    tm lt = *localtime(&ut);
    if (lt.tm_hour != 6) {
        if (lt.tm_hour == 7) return ut - 3600;
        else if (lt.tm_hour == 5) return ut + 3600;
        else { assert(false);}
    }
    else {
        return ut;
    }
}

static const string ts(time_t ut)
{
    static char buff[200] = {0};
    tm lt = *localtime(&ut);
    sprintf(buff, "%d/%02d/%02d %02d:%02d:%02d isdst(%d)", 1900+lt.tm_year, 1+lt.tm_mon, lt.tm_mday, lt.tm_hour, lt.tm_min, lt.tm_sec, lt.tm_isdst);
    return buff;
}

static void test(uint32 year, uint32 mon, uint32 day, uint32 hour = 0, uint32 min = 0, uint32 sec = 0)
{
#define show(flag,ut) printf("%20s %d %s\n", flag, ut, ts(ut).c_str());
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
    show("input", ut);
    time_t rut = GetZeroClock(ut);
    show("zero", rut);
    rut = GetSixClock(ut);
    show("six", rut);
    rut = GetNextZeroClock(ut);
    show("next zero", rut);
    rut = GetNextSixClock(ut);
    show("next six", rut);
    rut = GetMondayZeroClock(ut);
    show("mon zero", rut);
    rut = GetMondaySixClock(ut);
    show("mon six", rut);
    rut = GetNextMondayZeroClock(ut);
    show("next mon zero", rut);
    rut = GetNextMondaySixClock(ut);
    show("next mon six", rut);
    printf("\n");
}

//+0200: 3.27 2:00 dst start; 10.30 3:00 dst end.
int main(int argc, char** argv)
{
    for (uint32 hour = 1; hour < 6; hour++) {
        test(2016, 3, 27, hour);
        test(2016, 3, 27, hour, 30);
    }
    for (uint32 hour = 2; hour < 6; hour++) {
        test(2016, 10, 30, hour);
        test(2016, 10, 30, hour, 30);
    }
        return 0;
}
