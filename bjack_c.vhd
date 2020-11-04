-- (c) Aldec, Inc.
-- All rights reserved.
--
-- Last modified: $Date: 2013-02-19 12:12:43 +0100 (Tue, 19 Feb 2013) $
-- $Revision: 225781 $

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity bjack_c is
    port (
        CARD: in STD_LOGIC_VECTOR (3 downto 0);
        CLOCK: in STD_LOGIC;
        NEW_C: in STD_LOGIC;
        NEW_G: in STD_LOGIC;
        BUST: out STD_LOGIC;
        HAND: out STD_LOGIC_VECTOR (4 downto 0);
        HOLD: out STD_LOGIC;
        NEXT_C: out STD_LOGIC
    );
end;

architecture bjack_c_arch of bjack_c is

    signal Total: STD_LOGIC_VECTOR (4 downto 0);

-- SYMBOLIC ENCODED state machine: BlackJack
    type BlackJack_type is (Begin_g, BustState, Got_im, Hit_me, HoldState, TenBack, test16, Test21);
    signal BlackJack: BlackJack_type;

begin

-- concurrent signals assignments
HAND <= Total;

BlackJack_machine: process (CLOCK)
-- machine variables declarations
    variable Ace: BOOLEAN;

begin

    if rising_edge(CLOCK) then
        if NEW_G='1' then
            BlackJack <= Begin_g;
            Total <= "00000";
            Ace := false;
        else
            case BlackJack is
                when Begin_g =>
                    BlackJack <= Hit_me;
                when BustState =>
                    null;
                when Got_im =>
                    if NEW_C='0' then
                        BlackJack <= test16;
                    end if;
                when Hit_me =>
                    if NEW_C='1' then
                        BlackJack <= Got_im;
                        Total <= Total + CARD;
                        Ace :=  (CARD=11) or Ace;
                    end if;
                when HoldState =>
                    null;
                when TenBack =>
                    BlackJack <= test16;
                when test16 =>
                    if Total > 16 then
                        BlackJack <= Test21;
                    else
                        BlackJack <= Hit_me;
                    end if;
                when Test21 =>
                    if Total < 22 then
                        BlackJack <= HoldState;
                    elsif Ace then
                        BlackJack <= TenBack;
                        Total <= Total - 10;
                        Ace :=  FALSE;
                    else
                        BlackJack <= BustState;
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end if;
end process;

-- signal assignment statements for combinatorial outputs
NEXT_C_assignment:
NEXT_C <= '1' when (BlackJack = Hit_me) else
          '0';

BUST_assignment:
BUST <= '1' when (BlackJack = BustState) else
        '0';

HOLD_assignment:
HOLD <= '1' when (BlackJack = HoldState) else
        '0';

end;
