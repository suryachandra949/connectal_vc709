import Clocks::*;

interface Dsp48E1;
   method Bit#(48) p();
// Control: 4-bit (each) input: Control Inputs/Status Bits
   method Action alumode(Bit#(4) v);		// 4-bit input: ALU control input
   method Action carryinsel(Bit#(3) v);		// 3-bit input: Carry select input
   method Action inmode(Bit#(5) v);		// 5-bit input: INMODE control input
   method Action opmode(Bit#(7) v);		// 7-bit input: Operation mode input
   method Action a(Bit#(30) v);
   method Action b(Bit#(18) v);
   method Action c(Bit#(48) v);
   method Action d(Bit#(25) v);
   method Action last(Bit#(1) v);
endinterface

(* always_ready, always_enabled *)
interface PRIM_DSP48E1;
   method Bit#(48) p();
// Control: 4-bit (each) input: Control Inputs/Status Bits
   method Action alumode(Bit#(4) v);		// 4-bit input: ALU control input
   method Action carryinsel(Bit#(3) v);		// 3-bit input: Carry select input
   method Action inmode(Bit#(5) v);		// 5-bit input: INMODE control input
   method Action opmode(Bit#(7) v);		// 7-bit input: Operation mode input
   method Action a(Bit#(30) v);
   method Action b(Bit#(18) v);
   method Action c(Bit#(48) v);
   method Action d(Bit#(25) v);
   method Action acin(Bit#(30) v);
   method Action bcin(Bit#(18) v);
   method Action carrycascin(Bit#(1) v);
   method Action carryin(Bit#(1) v);
   method Action multsignin(Bit#(1) v);
   method Action pcin(Bit#(48) v);

   method Action cea1(Bit#(1) en);		// 1-bit input: Clock enable input for 1st stage AREG
   method Action cea2(Bit#(1) en);		// 1-bit input: Clock enable input for 2nd stage AREG
   method Action cead(Bit#(1) en);		// 1-bit input: Clock enable input for ADREG
   method Action ceb1(Bit#(1) en);		// 1-bit input: Clock enable input for 1st stage BREG
   method Action ceb2(Bit#(1) en);		// 1-bit input: Clock enable input for 2nd stage BREG
   method Action cealumode(Bit#(1) en);		// 1-bit input: Clock enable input for ALUMODE
   method Action cec(Bit#(1) en);		// 1-bit input: Clock enable input for CREG
   method Action cecarryin(Bit#(1) en);		// 1-bit input: Clock enable input for CARRYINREG
   method Action cectrl(Bit#(1) en);		// 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
   method Action ced(Bit#(1) en);		// 1-bit input: Clock enable input for DREG
   method Action ceinmode(Bit#(1) en);		// 1-bit input: Clock enable input for INMODEREG
   method Action cem(Bit#(1) en);		// 1-bit input: Clock enable input for MREG
   method Action cep(Bit#(1) en);		// 1-bit input: Clock enable input for PREG
endinterface

import "BVI" DSP48E1 =
module vmkDSP48E1(PRIM_DSP48E1);
   let currentClock <- exposeCurrentClock;
   let currentReset <- exposeCurrentReset;
   let invertedReset0 <- mkResetInverter(currentReset);
   let invertedReset <- mkAsyncReset(1, invertedReset0, currentClock);
   default_clock clk(CLK);

   default_reset rsta(RSTA) = invertedReset;
   input_reset rstb(RSTB) = invertedReset;
   input_reset rstc(RSTC) = invertedReset;
   input_reset rstd(RSTD) = invertedReset;
   input_reset rstallcarryin(RSTALLCARRYIN) = invertedReset;
   input_reset rstalumode(RSTALUMODE) = invertedReset;
   input_reset rstctrl(RSTCTRL) = invertedReset;
   input_reset rstinmode(RSTINMODE) = invertedReset;
   input_reset rstm(RSTM) = invertedReset;
   input_reset rstp(RSTP) = invertedReset;

   method P p();
   method alumode(ALUMODE) enable ((*inhigh*)EN_alumode);
   method carryinsel(CARRYINSEL) enable ((*inhigh*)EN_carryinsel);
   method inmode(INMODE) enable ((*inhigh*)EN_inmode);
   method opmode(OPMODE) enable ((*inhigh*)EN_opmode);
   method a(A) enable ((*inhigh*)EN_a);
   method b(B) enable ((*inhigh*)EN_b);
   method c(C) enable ((*inhigh*)EN_c);
   method d(D) enable ((*inhigh*)EN_d);
   method acin(ACIN) enable ((*inhigh*)EN_acin);
   method bcin(BCIN) enable ((*inhigh*)EN_bcin);
   method carrycascin(CARRYCASCIN) enable ((*inhigh*)EN_carrycascin);
   method carryin(CARRYIN) enable ((*inhigh*)EN_carryin);
   method multsignin(MULTSIGNIN) enable ((*inhigh*)EN_multsignin);
   method pcin(PCIN) enable ((*inhigh*)EN_pcin);

   method cea1(CEA1) enable ((*inhigh*)EN_cea1);
   method cea2(CEA2) enable ((*inhigh*)EN_cea2);
   method cead(CEAD) enable ((*inhigh*)EN_cead);
   method ceb1(CEB1) enable ((*inhigh*)EN_ceb1);
   method ceb2(CEB2) enable ((*inhigh*)EN_ceb2);
   method cealumode(CEALUMODE) enable ((*inhigh*)EN_cealumode);
   method cec(CEC) enable ((*inhigh*)EN_cec);
   method cecarryin(CECARRYIN) enable ((*inhigh*)EN_cecarryin);
   method cectrl(CECTRL) enable ((*inhigh*)EN_cectrl);
   method ced(CED) enable ((*inhigh*)EN_ced);
   method ceinmode(CEINMODE) enable ((*inhigh*)EN_ceinmode);
   method cem(CEM) enable ((*inhigh*)EN_cem);
   method cep(CEP) enable ((*inhigh*)EN_cep);
   schedule (alumode,carryinsel,inmode,opmode,a,b,c,d,acin,bcin,carrycascin,carryin,multsignin,pcin,cea1,cea2,cead,ceb1,ceb2,cealumode,cec,cecarryin,cectrl,ced,ceinmode,cem,cep,p)
      CF (alumode,carryinsel,inmode,opmode,a,b,c,d,acin,bcin,carrycascin,carryin,multsignin,pcin,cea1,cea2,cead,ceb1,ceb2,cealumode,cec,cecarryin,cectrl,ced,ceinmode,cem,cep,p);
endmodule

(* synthesize *)
module mkDsp48E1(Dsp48E1);
   let dsp <- vmkDSP48E1();
   let defaultReset <- exposeCurrentReset;
   let optionalReset = defaultReset; // noReset
   Wire#(Bit#(4)) alumodeWire <- mkDWire(0);
   Reg#(Bit#(4)) alumodeReg <- mkReg(0);
   Wire#(Bit#(3)) carryinselWire <- mkDWire(0);
   Wire#(Bit#(5)) inmodeWire <- mkDWire(0);
   Wire#(Bit#(7)) opmodeWire <- mkDWire(7'h20);
   Reg#(Bit#(7)) opmode1Reg <- mkReg(0);
   Reg#(Bit#(7)) opmode2Reg <- mkReg(0);
   Reg#(Bit#(7)) opmode3Reg <- mkReg(0);
   Reg#(Bit#(7)) opmode4Reg <- mkReg(0);

   Wire#(Bit#(30)) aWire <- mkDWire(0);
   Wire#(Bit#(18)) bWire <- mkDWire(0);
   Wire#(Bit#(48)) cWire <- mkDWire(0);
   Wire#(Bit#(25)) dWire <- mkDWire(0);
   Reg#(Bit#(48))  c1Reg <- mkReg(0);
   Reg#(Bit#(48))  c2Reg <- mkReg(0);
   Reg#(Bit#(48))  c3Reg <- mkReg(0);

   Wire#(Bit#(1)) ce1Wire <- mkDWire(0);
   Reg#(Bit#(1)) ce2Reg <- mkReg(0, reset_by optionalReset);
   Reg#(Bit#(1)) cepReg <- mkReg(0, reset_by optionalReset);
   Wire#(Bit#(1)) lastWire <- mkDWire(0);
   Reg#(Bit#(1))  last1Reg  <- mkReg(0, reset_by optionalReset);
   Reg#(Bit#(1))  last2Reg  <- mkReg(0, reset_by optionalReset);
   Reg#(Bit#(1))  last3Reg  <- mkReg(0, reset_by optionalReset);
   Reg#(Bit#(1))  last4Reg  <- mkReg(0, reset_by optionalReset);
   Reg#(Bit#(1))  last5Reg  <- mkReg(0, reset_by optionalReset);

   Reg#(Bit#(32)) cycles <- mkReg(0);
   rule cyclesRule;
      cycles <= cycles+1;
   endrule

   rule clock_enable_and_reset;
      ce2Reg <= ce1Wire;
      cepReg <= ce2Reg;

      last1Reg <= lastWire;
      last2Reg <= last1Reg;
      last3Reg <= last2Reg;
      last4Reg <= last3Reg;
      last5Reg <= last4Reg;

      dsp.cea1(1); // (ce1Wire);
      dsp.cea2(1); // (ce2Reg);
      dsp.cead(1);
      dsp.ceb1(1); // (ce1Wire);
      dsp.ceb2(1); // (ce2Reg);
      dsp.cealumode(1); // (ce1Wire);
      dsp.cec(1);
      dsp.cecarryin(1);
      dsp.cectrl(1);
      dsp.ced(1);
      dsp.ceinmode(1);
      dsp.cem(1);
      dsp.cep(1); // (cepReg);

   endrule

   rule driveInputs;
      opmode1Reg <= opmodeWire;
      opmode2Reg <= opmode1Reg;
      opmode3Reg <= opmode2Reg;
      opmode4Reg <= opmode3Reg;

      alumodeReg <= alumodeWire;

      c1Reg <= cWire;
      c2Reg <= c1Reg;
      c3Reg <= c2Reg;

      //if (lastWire == 1 || last1Reg == 1 || last2Reg == 1 || last3Reg == 1 || last4Reg == 1 || last5Reg == 1)
	 $display("%d: a=%h b=%h c=%h p=%h", cycles, aWire, bWire, c3Reg, dsp.p());

      dsp.alumode(alumodeReg);
      dsp.carryinsel(carryinselWire);
      dsp.inmode(inmodeWire);
      dsp.opmode(opmode1Reg);
      dsp.a(aWire);
      dsp.b(bWire);
      dsp.c(c1Reg);
      //dsp.d(dWire);

      dsp.acin(0);
      dsp.bcin(0);
      dsp.carrycascin(0);
      dsp.carryin(0);
      dsp.pcin(0);
   endrule

   method Action alumode(Bit#(4) v);
      alumodeWire <= v;
   endmethod
   method Action carryinsel(Bit#(3) v);
      carryinselWire <= v;
   endmethod
   method Action inmode(Bit#(5) v);
      inmodeWire <= v;
   endmethod
   method Action opmode(Bit#(7) v);
      opmodeWire <= v;
   endmethod
   method Action a(Bit#(30) v);
      ce1Wire <= 1;
      aWire <= v;
   endmethod
   method Action b(Bit#(18) v);
      bWire <= v;
   endmethod
   method Action c(Bit#(48) v);
      cWire <= v;
   endmethod
   method Action d(Bit#(25) v);
      dsp.d(v);
   endmethod
   method Bit#(48) p() if (last5Reg == 1);
      return dsp.p();
   endmethod
   method Action last(Bit#(1) v);
      lastWire <= v;
   endmethod
endmodule