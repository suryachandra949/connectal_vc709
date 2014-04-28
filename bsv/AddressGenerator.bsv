// Copyright (c) 2013 Quanta Research Cambridge, Inc.

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import FIFOF::*;
import FIFO::*;
import GetPut::*;
import Connectable::*;
import RegFile::*;
import Dma::*;

typedef struct {
   Bit#(addrWidth) addr;
   Bit#(8) bc;
   Bit#(6) tag;
   Bool    last;
   } AddrBeat#(numeric type addrWidth) deriving (Bits);

interface AddressGenerator#(numeric type addrWidth);
   interface Put#(MemRequest#(addrWidth)) request;
   interface Get#(AddrBeat#(addrWidth)) addrBeat;
endinterface

module mkAddressGenerator(AddressGenerator#(addrWidth));
   FIFOF#(MemRequest#(addrWidth)) requestFifo <- mkFIFOF();
   FIFOF#(AddrBeat#(addrWidth)) addrBeatFifo <- mkFIFOF();
   Reg#(Bit#(addrWidth)) addrReg <- mkReg(0);
   Reg#(Bit#(8)) burstCountReg <- mkReg(0);
   Reg#(Bool) isLastReg <- mkReg(False);

   rule addrBeatRule;
      let req = requestFifo.first();
      let addr = addrReg;
      let burstCount = burstCountReg;
      let isLast = isLastReg;

      let nextIsLast = burstCount == 2;
      let nextBurstCount = burstCount - 1;

      addrReg <= addr + 1;
      burstCountReg <= nextBurstCount;
      isLastReg <= nextIsLast;
      if (isLast) begin
	 requestFifo.deq();
      end
      addrBeatFifo.enq(AddrBeat { addr: addr, bc: burstCount, last: isLast, tag: req.tag});
   endrule

   interface Put request;
      method Action put(MemRequest#(addrWidth) req);
	 requestFifo.enq(req);
	 addrReg <= req.addr;
	 burstCountReg <= req.burstLen;
	 isLastReg <= (req.burstLen == 1);
      endmethod
   endinterface
   interface Get addrBeat;
      method ActionValue#(AddrBeat#(addrWidth)) get();
	 addrBeatFifo.deq();
	 return addrBeatFifo.first();
      endmethod
   endinterface
endmodule


