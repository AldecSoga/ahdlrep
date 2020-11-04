-- (c) Aldec, Inc.
-- All rights reserved.
--
-- Last modified: $Date: 2013-02-19 12:12:43 +0100 (Tue, 19 Feb 2013) $
-- $Revision: 225781 $

-- AND2 gate

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity and2 is
    port (
        I0 : in std_logic;
        I1 : in std_logic;
        O : out std_logic
    );
end;

architecture AND2_ARCH of and2 is
begin
    process(I0, I1)
    begin
        O <= I0 and I1;
    end process;
end;

-- OR2 gate

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity or2 is
    port (
        I0 : in std_logic;
        I1 : in std_logic;
        O : out std_logic
    );
end;

architecture OR2_ARCH of or2 is
begin
    process(I0, I1)
    begin
        O <= I0 or I1;
    end process;
end;


-- INV gate

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity inv is
    port (
        I : in std_logic;
        O : out std_logic
    );
end;

architecture INV_ARCH of inv is
begin
    process(I)
    begin
        O <= not I;
    end process;
end;

 -- VHDL model 8 bits Johnson's Counter with Asynchronous Reset

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity johnson8 is
    port (
        CLK: in STD_LOGIC;
        RESET: in STD_LOGIC;
        Q: out STD_LOGIC_VECTOR (7 downto 0)
    );
end;

architecture JOHNSON8_ARCH of johnson8 is

    signal Q_I : STD_LOGIC_VECTOR (7 downto 0);

begin

process (CLK, RESET)
begin
    if RESET='1' then
        -- asynchronous reset
        Q_I <= ( others => '1');
    elsif rising_edge(CLK) then
        -- shifting bits with inverted feedback
        Q_I <= Q_I(6 downto 0) & not Q_I(7);
    end if;
end process;

Q <= Q_I;

end;

-- VHDL Model of 2 to 1 Multiplexer with 5 bits output.
-- Input A is 4-bits, input B is 5-bits
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux is
    port (
        A: in STD_LOGIC_VECTOR (3 downto 0);
        B: in STD_LOGIC_VECTOR (4 downto 0);
        Y: out STD_LOGIC_VECTOR (4 downto 0);
        S: in STD_LOGIC
    );
end;

architecture MUX_ARCH of mux is
begin
    Y <= B when (S='1') else
         '0' & A;    -- bits concatenation
end;

-- VHDL model of Pseudo Random Numbers Generator with Asynchronous Reset
-- and Count Enable, for numbers from 1 to 11
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity gen is
    port (
        CLK: in STD_LOGIC;
        RES: in STD_LOGIC;
        DO: out STD_LOGIC_VECTOR (3 downto 0) ;
        ENC: in STD_LOGIC
    );
end gen;

architecture TOP_LEVEL of gen is

-- auxiliary signal declaration
    signal DOINT: STD_LOGIC_VECTOR (3 downto 0):="0000";

begin

process ( CLK, RES )
begin
    if RES='1' then
        -- asynchronous initialization
        DOINT <= "0001";
    else
        if rising_edge(CLK) then
            -- clock enable
            if ENC = '1' then
                DOINT(3) <= DOINT(2);
                DOINT(2) <= DOINT(1);
                DOINT(1) <= DOINT(0);
                DOINT(0) <= DOINT(0) xor DOINT(3);
            end if;
        end if;
    end if;
end process;

DO(3) <= DOINT(3) and (DOINT(3) nand DOINT(2));
DO(2) <= DOINT(2);
DO(1) <= DOINT(1);
DO(0) <= DOINT(0);

end;
