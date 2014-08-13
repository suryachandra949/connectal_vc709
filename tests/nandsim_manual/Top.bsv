// bsv libraries
import SpecialFIFOs::*;
import Vector::*;
import StmtFSM::*;
import FIFO::*;
import BRAM::*;
import DefaultValue::*;

// portz libraries
import Leds::*;
import Directory::*;
import CtrlMux::*;
import Portal::*;
import PortalMemory::*;
import MemTypes::*;
import MemServer::*;

// generated by tool
import NandSimRequestWrapper::*;
import DmaConfigWrapper::*;
import NandSimIndicationProxy::*;
import DmaIndicationProxy::*;

// defined by user
import NandSim::*;

typedef enum {DmaIndication, DmaConfig, NandSimIndication, NandSimRequest} IfcNames deriving (Eq,Bits);

module mkPortalTop(StdPortalDmaTop#(PhysAddrWidth));
   
   DmaIndicationProxy dmaIndicationProxy <- mkDmaIndicationProxy(DmaIndication);
   NandSimIndicationProxy nandSimIndicationProxy <- mkNandSimIndicationProxy(NandSimIndication);
   
   //BRAM1Port#(Bit#(14), Bit#(64)) br <- mkBRAM1Server(defaultValue);
   //NandSim nandSim <- mkNandSim(nandSimIndicationProxy.ifc, br.portA);
   NandSim nandSim <- mkNandSim(nandSimIndicationProxy.ifc);
   NandSimRequestWrapper nandSimRequestWrapper <- mkNandSimRequestWrapper(NandSimRequest,nandSim.request);

   Vector#(1, ObjectReadClient#(64)) readClients = cons(nandSim.readClient, nil);
   Vector#(1, ObjectWriteClient#(64)) writeClients = cons(nandSim.writeClient, nil);
   MemServer#(PhysAddrWidth,64,1) dma <- mkMemServer(dmaIndicationProxy.ifc, readClients, writeClients);

   DmaConfigWrapper dmaRequestWrapper <- mkDmaConfigWrapper(DmaConfig,dma.request);

   Vector#(4,StdPortal) portals;
   portals[0] = nandSimRequestWrapper.portalIfc;
   portals[1] = nandSimIndicationProxy.portalIfc; 
   portals[2] = dmaRequestWrapper.portalIfc;
   portals[3] = dmaIndicationProxy.portalIfc; 
   
   StdDirectory dir <- mkStdDirectory(portals);
   let ctrl_mux <- mkSlaveMux(dir,portals);
   
   interface interrupt = getInterruptVector(portals);
   interface slave = ctrl_mux;
   interface masters = dma.masters;
   interface leds = default_leds;
      
endmodule : mkPortalTop