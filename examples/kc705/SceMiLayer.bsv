////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2013  Bluespec, Inc.  ALL RIGHTS RESERVED.
////////////////////////////////////////////////////////////////////////////////
//  Filename      : SceMiLayer.bsv
//  Description   : 
////////////////////////////////////////////////////////////////////////////////
package SceMiLayer;

// Notes :

////////////////////////////////////////////////////////////////////////////////
/// Imports
////////////////////////////////////////////////////////////////////////////////
import SceMi             ::*;
import GetPut            ::*;
import DefaultValue      ::*;
import CommitIfc         ::*;
import ClientServer      ::*;
import Connectable       ::*;
import Vector            ::*;
import Clocks            ::*;
import FIFO              ::*;
import SpecialFIFOs      ::*;
import Memory            ::*;

////////////////////////////////////////////////////////////////////////////////
/// Types
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// Interfaces
////////////////////////////////////////////////////////////////////////////////
interface SceMiLayer;
   interface Clock uclk;
   interface Reset urst;
endinterface

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
///
/// Implementation
///
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
module [SceMiModule] mkSceMiLayer(SceMiLayer);

   ////////////////////////////////////////////////////////////////////////////////
   /// Clocks & Resets
   ////////////////////////////////////////////////////////////////////////////////
   Clock                           uclock              <- sceMiGetUClock;
   Reset                           ureset              <- sceMiGetUReset;
   
   ////////////////////////////////////////////////////////////////////////////////
   /// Control Clock
   ////////////////////////////////////////////////////////////////////////////////
   SceMiClockConfiguration         clkcfg               = defaultValue;
   clkcfg.clockNum       = 0;
   clkcfg.resetCycles    = 8;
   SceMiClockPortIfc               clk_port            <- mkSceMiClockPort( clkcfg );
   let cclock = clk_port.cclock;
   let creset = clk_port.creset;
      
   ////////////////////////////////////////////////////////////////////////////////
   /// Interface Connections / Methods
   ////////////////////////////////////////////////////////////////////////////////
   interface Clock uclk = uclock;
   interface Reset urst = ureset;
endmodule: mkSceMiLayer   

endpackage: SceMiLayer

