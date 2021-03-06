----------------------------------------------------------------------------
--
--  Atmel AVR Program Memory
--
--  This component describes a program for the AVR CPU.  It creates the 
--  program in a small (532 x 16) ROM.
--
--  Revision History:
--     11 May 00  Glen George       Initial revision (from 5/9/00 version of 
--                                  progmem.vhd).
--     28 Jul 00  Glen George       Added instructions and made memory return
--                                  NOP when not mapped.
--      7 Jun 02  Glen George       Updated commenting.
--     16 May 04  Glen George       Added more instructions for testing and
--                                  updated commenting.
--     21 Jan 08  Glen George       Updated commenting.
--     17 Jan 18  Glen George       Updated commenting.
--     24 June 19 Sung Hoon Choi    Updated Program Memory with HW2 testcode 
--                                  instructions
----------------------------------------------------------------------------


--
--  PROG_MEMORY
--
--  This is the program memory component.  It is just a 334 word ROM with no
--  timing information.  It is meant to be connected to the AVR CPU.  The ROM
--  is always enabled and may be changed when Reset it active.
--
--  Inputs:
--    ProgAB - address bus (16 bits)
--    Reset  - system reset (active low)
--
--  Outputs:
--    ProgDB - program memory data bus (16 bits)
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity  PROG_MEMORY  is

    port (
        ProgAB  :  in   std_logic_vector(15 downto 0);  -- program address bus
        Reset   :  in   std_logic;                      -- system reset
        ProgDB  :  out  std_logic_vector(15 downto 0)   -- program data bus
    );

end  PROG_MEMORY;


architecture  ROM  of  PROG_MEMORY  is

    -- define the type for the ROM (an array)
    type  ROMtype  is array(0 to 531) of std_logic_vector(15 downto 0);

    -- define the actual ROM, which is initialized with the program data 
    -- generated by compiling the hw2 test code and feeding it through lst2test
    -- (with some manual corrections)
    signal  ROMbits  :  ROMtype  :=  (
        X"9488", X"94F8", X"94C8", X"94B8", X"9498", 
        X"94D8", X"94A8", X"94E8", X"E70E", X"EF18", 
        X"E22C", X"930F", X"931F", X"932F", X"912F", 
        X"911F", X"910F", X"EFBF", X"E0A0", X"930C", 
        X"EFDF", X"E8C0", X"8318", X"EFFF", X"EBE0", 
        X"8320", X"932D", X"931D", X"930D", X"9329", 
        X"9319", X"9309", X"9321", X"9311", X"9301", 
        X"932E", X"931E", X"930E", X"931A", X"930A", 
        X"932A", X"9302", X"9322", X"9312", X"913C", 
        X"933F", X"913F", X"8148", X"934F", X"914F", 
        X"8150", X"935F", X"915F", X"913D", X"913D", 
        X"9149", X"9149", X"9151", X"9151", X"913E", 
        X"913E", X"914A", X"914A", X"9152", X"9152", 
        X"834A", X"8352", X"8149", X"8151", X"9330", 
        X"FF02", X"9130", X"FF01", X"E101", X"E318", 
        X"2F01", X"930F", X"910F", X"9408", X"B6AF", 
        X"92AF", X"90AF", X"F008", X"0000", X"9488", 
        X"B6AF", X"92AF", X"90AF", X"F408", X"0000", 
        X"9418", X"B6AF", X"92AF", X"90AF", X"F009", 
        X"0000", X"9498", X"B6AF", X"92AF", X"90AF", 
        X"F409", X"0000", X"9428", X"B6AF", X"92AF", 
        X"90AF", X"F00A", X"0000", X"94A8", X"B6AF", 
        X"92AF", X"90AF", X"F40A", X"0000", X"9438", 
        X"B6AF", X"92AF", X"90AF", X"F00B", X"0000", 
        X"94B8", X"B6AF", X"92AF", X"90AF", X"F40B", 
        X"0000", X"9448", X"B6AF", X"92AF", X"90AF", 
        X"F00C", X"0000", X"94C8", X"B6AF", X"92AF", 
        X"90AF", X"F40C", X"0000", X"9458", X"B6AF", 
        X"92AF", X"90AF", X"F00D", X"0000", X"94D8", 
        X"B6AF", X"92AF", X"90AF", X"F40D", X"0000", 
        X"9468", X"B6AF", X"92AF", X"90AF", X"F00E", 
        X"0000", X"94E8", X"B6AF", X"92AF", X"90AF", 
        X"F40E", X"0000", X"9478", X"B6AF", X"92AF", 
        X"90AF", X"F00F", X"0000", X"94F8", X"B6AF", 
        X"92AF", X"90AF", X"F40F", X"0000", X"E10E", 
        X"E14B", X"9408", X"1F04", X"930F", X"910F", 
        X"B74F", X"934F", X"914F", X"E10E", X"E14B", 
        X"9488", X"1F04", X"930F", X"910F", X"B74F", 
        X"934F", X"914F", X"E70F", X"E74F", X"9488", 
        X"1F04", X"930F", X"910F", X"B74F", X"934F", 
        X"914F", X"9408", X"E304", X"E049", X"0F04", 
        X"930F", X"910F", X"B74F", X"934F", X"914F", 
        X"9488", X"E800", X"E840", X"0F04", X"930F", 
        X"910F", X"B74F", X"934F", X"914F", X"EF90", 
        X"EE80", X"9603", X"939F", X"919F", X"938F", 
        X"918F", X"B6AF", X"92AF", X"90AF", X"E695", 
        X"EAAC", X"239A", X"939F", X"919F", X"B6AF", 
        X"92AF", X"90AF", X"E637", X"E041", X"2334", 
        X"933F", X"913F", X"B6AF", X"92AF", X"90AF", 
        X"E49D", X"7693", X"939F", X"919F", X"B6AF", 
        X"92AF", X"90AF", X"7090", X"939F", X"919F", 
        X"B6AF", X"92AF", X"90AF", X"9488", X"E307", 
        X"9505", X"B6AF", X"92AF", X"90AF", X"E090", 
        X"9468", X"F993", X"939F", X"919F", X"94E8", 
        X"EF1F", X"FB12", X"B6AF", X"92AF", X"90AF", 
        X"E017", X"FB13", X"B6AF", X"92AF", X"90AF", 
        X"9488", X"E14E", X"9540", X"B6AF", X"92AF", 
        X"90AF", X"EF81", X"EF91", X"1789", X"B6AF", 
        X"92AF", X"90AF", X"E085", X"E09F", X"1789", 
        X"B6AF", X"92AF", X"90AF", X"E083", X"E093", 
        X"9408", X"0789", X"938F", X"918F", X"B6AF", 
        X"92AF", X"90AF", X"EA7F", X"3371", X"937F", 
        X"917F", X"B6AF", X"92AF", X"90AF", X"E071", 
        X"3071", X"B6AF", X"92AF", X"90AF", X"E062", 
        X"956A", X"936F", X"916F", X"B6AF", X"92AF", 
        X"90AF", X"956A", X"936F", X"916F", X"B6AF", 
        X"92AF", X"90AF", X"EB43", X"E459", X"2745", 
        X"B6AF", X"92AF", X"90AF", X"E17A", X"9573", 
        X"B6AF", X"92AF", X"90AF", X"9488", X"E17F", 
        X"9576", X"B6AF", X"92AF", X"90AF", X"E253", 
        X"9551", X"935F", X"915F", X"B6AF", X"92AF", 
        X"90AF", X"EC5F", X"E16A", X"2B56", X"935F", 
        X"915F", X"B6AF", X"92AF", X"90AF", X"EA51", 
        X"635A", X"935F", X"915F", X"B6AF", X"92AF", 
        X"90AF", X"9408", X"E652", X"9557", X"935F", 
        X"915F", X"B6AF", X"92AF", X"90AF", X"9408", 
        X"EA5B", X"E360", X"0B56", X"935F", X"915F", 
        X"B6AF", X"92AF", X"90AF", X"9488", X"EC5D", 
        X"EC6D", X"0B56", X"935F", X"915F", X"B6AF", 
        X"92AF", X"90AF", X"9408", X"EB5C", X"4450", 
        X"935F", X"915F", X"B6AF", X"92AF", X"90AF", 
        X"9488", X"EE5F", X"4E5F", X"935F", X"915F", 
        X"B6AF", X"92AF", X"90AF", X"E39F", X"E58A", 
        X"970C", X"938F", X"918F", X"B6AF", X"92AF", 
        X"90AF", X"EB73", X"E182", X"1B78", X"937F", 
        X"917F", X"B6AF", X"92AF", X"90AF", X"E071", 
        X"E08A", X"1B78", X"937F", X"917F", X"B6AF", 
        X"92AF", X"90AF", X"EC2A", X"5A21", X"932F", 
        X"912F", X"B6AF", X"92AF", X"90AF", X"E820", 
        X"5420", X"932F", X"912F", X"B6AF", X"92AF", 
        X"90AF", X"E12F", X"512F", X"932F", X"912F", 
        X"B6AF", X"92AF", X"90AF", X"EA9D", X"9592", 
        X"939F", X"919F", X"940C", X"01D1", X"E140", 
        X"C001", X"E140", X"E0F1", X"EDE7", X"9409", 
        X"E140", X"E050", X"940E", X"01DC", X"940C", 
        X"01DE", X"E051", X"9508", X"E050", X"D002", 
        X"940C", X"01E4", X"E051", X"9508", X"E0F1", 
        X"EEE9", X"9509", X"940C", X"01EB", X"EF5F", 
        X"9508", X"94F8", X"940E", X"01F3", X"B6AF", 
        X"92AF", X"90AF", X"940C", X"01F4", X"9518", 
        X"E170", X"E180", X"1378", X"940C", X"01F4", 
        X"1378", X"EC4C", X"E140", X"FD44", X"E545", 
        X"FD43", X"940C", X"01FB", X"E040", X"FD44", 
        X"940C", X"01FB", X"EF5F", X"FF53", X"940C", 
        X"0205", X"EF57", X"FF53", X"EF5F", X"9488", 
        X"9498", X"94A8", X"94B8", X"94C8", X"94D8", 
        X"94E8", X"94F8"
    );


begin


    -- always read the value at the current address
    ProgDB <= ROMbits(CONV_INTEGER(ProgAB)) when (CONV_INTEGER(ProgAB) <= ROMbits'high)  else
              X"E0C0";    -- NOP instruction


    -- process to handle Reset
    process(Reset)
    begin

        -- check if Reset is low now
        if  (Reset = '0')  then
            -- reset is active - initialize the ROM (nothing for now)
        end if;

    end process;

end  ROM;