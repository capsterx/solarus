#include "switch/init.hpp"
#include <switch.h>
#include <cstdio>
#include <unistd.h>

namespace nswitch {

namespace {
Result switch_romfs;
}

void init()
{
  Result nsError = nsInitialize();
  if (R_FAILED(nsError)) {
    return;
  }
  socketInitializeDefault();
  nxlinkConnectToHost(true, false);
  printf("connected to hostd\n");
  switch_romfs = romfsInit();
  printf("init finished\n");
}

void deinit()
{
  if (R_SUCCEEDED(switch_romfs))
  {
    romfsExit();
  }
  socketExit();
  nsExit();
}

}

extern "C" {
  void switch_init()
  {
    nswitch::init();
  }
  void switch_deinit()
  {
    nswitch::deinit();
  }
}
