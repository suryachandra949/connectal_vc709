// bsv libraries
import Vector::*;
import FIFO::*;
import Connectable::*;

// portz libraries
import Portal::*;
import Directory::*;
import CtrlMux::*;
import Portal::*;
import Leds::*;
import AxiMasterSlave::*;
import Dma::*;

// generated by tool
import ImageCaptureIndicationProxy::*;
import ImageCaptureRequestWrapper::*;
import ImageonSerdesIndicationProxy::*;
import HdmiInternalIndicationProxy::*;
//import ImageCaptureRequestInternal::*;
import ImageonSerdesRequestWrapper::*;
import HdmiInternalRequestWrapper::*;
import ImageonSensorRequestWrapper::*;
import ImageCaptureRequestWrapper::*;

// defined by user
import ImageCapture::*;
import GetPut::*;
import Connectable :: *;
import PCIE :: *; // ConnectableWithClocks
import Clocks :: *;
import XbsvSpi :: *;

import GetPutWithClocks :: *;
import Imageon::*;
import IserdesDatadeser::*;
import HDMI::*;
import SensorToVideo::*;
import XilinxCells::*;
import XbsvXilinxCells::*;
import YUV::*;
import PS7LIB :: *;
import Imageon :: *;

typedef enum { ImageCaptureRequest, ImageonSerdesRequest, HdmiInternalRequest, ImageonSensorRequest,
    ImageCaptureIndication, ImageonSerdesIndication, HdmiInternalIndication} IfcNames deriving (Eq,Bits);

module mkPortalTop#(Clock clock200, Clock io_vita_clk)(PortalTop#(addrWidth,64,ImageonVita));
    Clock defaultClock <- exposeCurrentClock();
    Reset defaultReset <- exposeCurrentReset();

   // instantiate user portals
   ImageCaptureIndicationProxy captureIndicationProxy <- mkImageCaptureIndicationProxy(ImageCaptureIndication);
   ImageonSerdesIndicationProxy serdesIndicationProxy <- mkImageonSerdesIndicationProxy(ImageonSerdesIndication);
   HdmiInternalIndicationProxy hdmiIndicationProxy <- mkHdmiInternalIndicationProxy(HdmiInternalIndication);

   //ImageCaptureRequest captureRequestInternal <- mkImageCaptureRequest(captureIndicationProxy.ifc);

//////
    IDELAYCTRL idel <- mkIDELAYCTRL(2, clocked_by clock200);
    Clock imageon_video_clk1_buf_wire <- mkClockIBUFG(clocked_by io_vita_clk);
    MMCMHACK mmcmhack <- mkMMCMHACK(clocked_by imageon_video_clk1_buf_wire);
    Clock hdmi_clock <- mkClockBUFG(clocked_by mmcmhack.mmcmadv.clkout0);
    Clock imageon_clock <- mkClockBUFG(clocked_by mmcmhack.mmcmadv.clkout1);
    Reset hdmi_reset <- mkAsyncReset(2, defaultReset, hdmi_clock);
    Reset imageon_reset <- mkAsyncReset(2, defaultReset, imageon_clock);
    SyncPulseIfc vsyncPulse <- mkSyncHandshake(hdmi_clock, hdmi_reset, imageon_clock);

    ISerdes serdes <- mkISerdes(defaultClock, defaultReset, serdesIndicationProxy.ifc,
        clocked_by imageon_clock, reset_by imageon_reset);
    SPI#(Bit#(26)) spiController <- mkSPI(1000);
    SensorToVideo converter <- mkSensorToVideo(clocked_by hdmi_clock, reset_by hdmi_reset);
    HdmiGenerator hdmiGen <- mkHdmiGenerator(defaultClock, defaultReset,
        vsyncPulse, hdmiIndicationProxy.ifc, clocked_by hdmi_clock, reset_by hdmi_reset);
    ImageonSensor fromSensor <- mkImageonSensor(defaultClock, defaultReset, serdes.data, vsyncPulse.pulse(),
        hdmiGen.control, hdmi_clock, hdmi_reset, clocked_by imageon_clock, reset_by imageon_reset);

    //ImageCaptureRequestWrapper captureRequestWrapper <- mkImageCaptureRequestWrapper(ImageCaptureRequest,captureRequestInternal.ifc);
    ImageonSerdesRequestWrapper serdesRequestWrapper <- mkImageonSerdesRequestWrapper(ImageonSerdesRequest,serdes.control);
    HdmiInternalRequestWrapper hdmiRequestWrapper <- mkHdmiInternalRequestWrapper(HdmiInternalRequest,hdmiGen.control);
    ImageonSensorRequestWrapper sensorRequestWrapper <- mkImageonSensorRequestWrapper(ImageonSensorRequest,fromSensor.control);

//    rule xsviConnection;
//        let xsvi <- fromSensor.get_data();
//        //bsi.dataIn(extend(pack(xsvi)), extend(pack(xsvi)));
//        //converter.in.put(xsvi);
//        //let xvideo <- converter.out.get();
//        //hdmiGen.rgb(xvideo);
//        Bit#(64) pixel = {40'b0, xsvi[9:2], xsvi[9:2], xsvi[9:2]};
//        hdmiGen.request.put(pixel);
//    endrule
//
//    rule spiControllerResponse;
//        Bit#(26) v <- spiController.response.get();
//        indication.coreIndication.spi_response(extend(v));
//    endrule
//
//    method Action get_debugind();
//        indication.coreIndication.debugind(fromSensor.control.get_debugind());
//    endmethod
//    method Action put_spi_request(Bit#(32) v);
//        spiController.request.put(truncate(v));
//    endmethod
///////////
   
   Vector#(4,StdPortal) portals;
   portals[0] = captureIndicationProxy.portalIfc;
   portals[1] = serdesRequestWrapper.portalIfc; 
   portals[2] = hdmiRequestWrapper.portalIfc; 
   portals[3] = sensorRequestWrapper.portalIfc; 
   
   // instantiate system directory
   StdDirectory dir <- mkStdDirectory(portals);
   let ctrl_mux <- mkAxiSlaveMux(dir,portals);
   
   interface interrupt = getInterruptVector(portals);
   interface ctrl = ctrl_mux;
   interface read_client = null_physical_read_client;
   interface write_client = null_physical_write_client;
   //interface leds = captureRequestInternal.leds;

   interface ImageonVita pins;
      // interface ImageonTopPins toppins;
      // 	  method Clock fbbozo();
      // 	     return mmcmhack.mmcmadv.clkfbout;
      // 	  endmethod
      // 	  method Action fbbozoin(Bit#(1) v);
      // 	     mmcmhack.mmcmadv.clkfbin(v);
      // 	  endmethod
      //  endinterface

       interface SpiPins spi = spiController.pins;
       interface ImageonSensorPins pins = fromSensor.pins;
       interface ImageonSerdesPins serpins = serdes.pins;
   endinterface

endmodule : mkPortalTop
