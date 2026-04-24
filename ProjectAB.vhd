library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity ProjectAB is
Port (Clock, Resetn : IN STD_LOGIC;
		Row : IN STD_LOGIC_VECTOR(2 downto 0);
		Col : IN STD_LOGIC_VECTOR(1 downto 0);
		Item_Price : OUT STD_LOGIC_VECTOR(4 downto 0);
		Item_Slot : OUT STD_LOGIC_VECTOR(4 downto 0);
		Hex_Col	: OUT STD_LOGIC_VECTOR(6 downto 0);
		Hex_Row	: OUT STD_LOGIC_VECTOR(6 downto 0);
		Hex_Price1: OUT STD_LOGIC_VECTOR(6 downto 0);
		Hex_Price2: OUT STD_LOGIC_VECTOR(6 downto 0);
		Hex_Price3: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX3: OUT STD_LOGIC_VECTOR(6 downto 0) --USED TO TURN OFF THE HEX3 PROBLEM
		);
END ProjectAB;

Architecture behavior of ProjectAB IS
--Zero  0000001
--One   1001111
--Two   1101101
--Three 0000110
--Four  1001100
--Five  0100100
--Six   0100000
--Seven 1110000
--Eight 0000000
--Nine  0001100

--A 0001000
--B 1100000
--C 0110001
--D 1000010

SIGNAL HEX_ZERO: STD_LOGIC_VECTOR(6 downto 0) :=  "1000000";
SIGNAL HEX_ONE: STD_LOGIC_VECTOR(6 downto 0) :=  "1111001";
SIGNAL HEX_TWO: STD_LOGIC_VECTOR(6 downto 0) :=  "0100100";
SIGNAL HEX_THREE: STD_LOGIC_VECTOR(6 downto 0) := "0110000";
SIGNAL HEX_FOUR: STD_LOGIC_VECTOR(6 downto 0) :=  "0011001";
SIGNAL HEX_FIVE: STD_LOGIC_VECTOR(6 downto 0) :=  "0010010";
SIGNAL HEX_SIX: STD_LOGIC_VECTOR(6 downto 0) :=  "0000010";
SIGNAL HEX_SEVEN: STD_LOGIC_VECTOR(6 downto 0) :=  "1111000";
SIGNAL HEX_EIGHT: STD_LOGIC_VECTOR(6 downto 0) :=  "0000000";
SIGNAL HEX_NINE: STD_LOGIC_VECTOR(6 downto 0) :=  "0011000";

SIGNAL HEX_A: STD_LOGIC_VECTOR(6 downto 0) :=  "0001000";
SIGNAL HEX_B: STD_LOGIC_VECTOR(6 downto 0) :=  "0000011";
SIGNAL HEX_C: STD_LOGIC_VECTOR(6 downto 0) :=  "1000110";
SIGNAL HEX_D: STD_LOGIC_VECTOR(6 downto 0) :=  "0100001";
SIGNAL HEX_E: STD_LOGIC_VECTOR(6 downto 0) :=  "0000110";
SIGNAL HEX_F: STD_LOGIC_VECTOR(6 downto 0) :=  "0001110";
SIGNAL HEX_G: STD_LOGIC_VECTOR(6 downto 0) :=  "0010000";

SIGNAL HEX_OFF: STD_LOGIC_VECTOR(6 downto 0) :=  "1111111";


SIGNAL CATEGORY: STD_LOGIC_VECTOR(2 downto 0);
--000 CANDY
--001 CHIPS
--010 NUTS
--011 SODA
--100 DIET SODA
--101 JUICE 
	
BEGIN

PROCESS(Clock, Resetn)
	BEGIN 
		IF Resetn = '0' THEN
			
		ELSIF (Rising_Edge(Clock)) THEN
				--First Column	
			IF (Row = "000" and Col = "00") THEN
				Item_Slot <= "00000"; --M AND M'S
				HEX_COL <= HEX_ZERO;
				HEX_ROW <= HEX_A;
				CATEGORY <= "000";
			ELSIF (Row = "001" and Col = "00") THEN
				Item_Slot <= "00001"; --BBQ CHIPS 
				HEX_COL <= HEX_ZERO;
				HEX_ROW <= HEX_B;
				CATEGORY <= "001";
			ELSIF (Row = "010" and Col = "00") THEN
				Item_Slot <= "00010"; --COOL RANCH DORITOS
				HEX_COL <= HEX_ZERO;
				HEX_ROW <= HEX_C;
				CATEGORY <= "001";
			ELSIF (Row = "011" and Col = "00") THEN
				Item_Slot <= "00011"; --ROASTED ALMOND NUTS
				HEX_COL <= HEX_ZERO;
				HEX_ROW <= HEX_D;
				CATEGORY <= "010";
			ELSIF (Row = "100" and Col = "00") THEN
				Item_Slot <= "00100"; --COCA COLA
			   HEX_COL <= HEX_ZERO;
				HEX_ROW <= HEX_E;
				CATEGORY <= "011";
			ELSIF (Row = "101" and Col = "00") THEN
				Item_Slot <= "00101"; --DIET MOUNTAIN DEW
				HEX_COL <= HEX_ZERO;
				HEX_ROW <= HEX_F;
				CATEGORY <= "100";
			ELSIF (Row = "110" and Col = "00") THEN
				Item_Slot <= "00110"; --FRUIT PUNCH
				HEX_COL <= HEX_ZERO;
				HEX_ROW <= HEX_G;
				CATEGORY <= "101";
				--Second Column
			ELSIF (Row = "000" and Col = "01") THEN
				Item_Slot <= "01000"; --SKITTLES
				HEX_COL <= HEX_ONE;
				HEX_ROW <= HEX_A;
				CATEGORY <= "000";
			ELSIF (Row = "001" and Col = "01") THEN
				Item_Slot <= "01001"; --SOUR CREAM & ONION CHIPS
				HEX_COL <= HEX_ONE;
				HEX_ROW <= HEX_B;
				CATEGORY <= "001";
			ELSIF (Row = "010" and Col = "01") THEN
				Item_Slot <= "01010"; --SPICY NACHO DORITOS
				HEX_COL <= HEX_ONE;
				HEX_ROW <= HEX_C;
				CATEGORY <= "001";
			ELSIF (Row = "011" and Col = "01") THEN
				Item_Slot <= "01011"; --TRAIL MIX
			   HEX_COL <= HEX_ONE;
				HEX_ROW <= HEX_D;
				CATEGORY <= "010";	
			ELSIF (Row = "100" and Col = "01") THEN
				Item_Slot <= "01100"; --SPRITE
				HEX_COL <= HEX_ONE;
				HEX_ROW <= HEX_E;
				CATEGORY <= "011";
			ELSIF (Row = "101" and Col = "01") THEN
				Item_Slot <= "01101"; --DIET COKE
				HEX_COL <= HEX_ONE;
				HEX_ROW <= HEX_F;
				CATEGORY <= "100";
			ELSIF (Row = "110" and Col = "01") THEN
				Item_Slot <= "01110"; --LEMONADE
				HEX_COL <= HEX_ONE;
				HEX_ROW <= HEX_G;
				CATEGORY <= "101";
				--Third Column
			ELSIF (Row = "000" and Col = "10") THEN
				Item_Slot <= "10000"; --HERSHEYS CHOCOLATE BAR
			   HEX_COL <= HEX_TWO;
				HEX_ROW <= HEX_A;	
				CATEGORY <= "000";
			ELSIF (Row = "001" and Col = "10") THEN
				Item_Slot <= "10001"; --SALT & VINEGAR CHIPS
				HEX_COL <= HEX_TWO;
				HEX_ROW <= HEX_B;
				CATEGORY <= "001";
			ELSIF (Row = "010" and Col = "10") THEN
				Item_Slot <= "10010"; --SWEET CHILI DORITOS
				HEX_COL <= HEX_TWO;
				HEX_ROW <= HEX_C;
				CATEGORY <= "001";
			ELSIF (Row = "011" and Col = "10") THEN
				Item_Slot <= "10011"; --GRONOLA BAR
				HEX_COL <= HEX_TWO;
				HEX_ROW <= HEX_D;
				CATEGORY <= "010";
			ELSIF (Row = "100" and Col = "10") THEN
				Item_Slot <= "10100"; --DR PEPPER
				HEX_COL <= HEX_TWO;
				HEX_ROW <= HEX_E;
				CATEGORY <= "011";
			ELSIF (Row = "101" and Col = "10") THEN
				Item_Slot <= "10101"; --DIET DR PEPPER
				HEX_COL <= HEX_TWO;
				HEX_ROW <= HEX_F;
				CATEGORY <= "100";
			ELSIF (Row = "110" and Col = "10") THEN
				Item_Slot <= "10110"; --APPLE JUICE 
				HEX_COL <= HEX_TWO;
				HEX_ROW <= HEX_G;
				CATEGORY <= "101";
				--Fourth Column 
			ELSIF (Row = "000" and Col = "11") THEN
				Item_Slot <= "11000"; --PROTEIN BAR 
				HEX_COL <= HEX_THREE;
				HEX_ROW <= HEX_A;
				CATEGORY <= "000";
			ELSIF (Row = "001" and Col = "11") THEN
				Item_Slot <= "11001"; --CLASSIC POTATO CHIPS
				HEX_COL <= HEX_THREE;
				HEX_ROW <= HEX_B;
				CATEGORY <= "001";
			ELSIF (Row = "010" and Col = "11") THEN
				Item_Slot <= "11010"; --NACHO CHEESE DORITOS
				HEX_COL <= HEX_THREE;
				HEX_ROW <= HEX_C;
				CATEGORY <= "001";
			ELSIF (Row = "011" and Col = "11") THEN
				Item_Slot <= "11011"; --SALTED PEANUTS
				HEX_COL <= HEX_THREE;
				HEX_ROW <= HEX_D;
				CATEGORY <= "010";
			ELSIF (Row = "100" and Col = "11") THEN
				Item_Slot <= "11100"; --ORANGE FANTA
				HEX_COL <= HEX_THREE;
				HEX_ROW <= HEX_E;
			CATEGORY <= "011";	
			ELSIF (Row = "101" and Col = "11") THEN
				Item_Slot <= "11101"; --DIET SPRITE
				HEX_COL <= HEX_THREE;
				HEX_ROW <= HEX_F;	
			ELSIF (Row = "100" and Col = "11") THEN
				Item_Slot <= "11110"; --ORANGE JUICE
				HEX_COL <= HEX_THREE;
				HEX_ROW <= HEX_G;
				CATEGORY <= "101";
			END IF;
		END IF;
		
	CASE CATEGORY IS
		WHEN "000" =>
			HEX_PRICE1 <= HEX_ONE;
			HEX_PRICE2 <= HEX_FIVE;
			HEX_PRICE3 <= HEX_ZERO;
		WHEN "001" =>
			HEX_PRICE1 <= HEX_THREE;
			HEX_PRICE2 <= HEX_ZERO;
			HEX_PRICE3 <= HEX_ZERO;
		WHEN "010" =>
			HEX_PRICE1 <= HEX_TWO;
			HEX_PRICE2 <= HEX_FIVE;
			HEX_PRICE3 <= HEX_ZERO;
		WHEN "011" =>
			HEX_PRICE1 <= HEX_ONE;
			HEX_PRICE2 <= HEX_SEVEN;
			HEX_PRICE3 <= HEX_FIVE;
		WHEN "100" =>
			HEX_PRICE1 <= HEX_ONE;
			HEX_PRICE2 <= HEX_TWO;
			HEX_PRICE3 <= HEX_FIVE;
		WHEN "101" =>
			HEX_PRICE1 <= HEX_TWO;
			HEX_PRICE2 <= HEX_ONE;
			HEX_PRICE3 <= HEX_ZERO;
		WHEN OTHERS =>
			HEX_PRICE1 <= HEX_ZERO;
			HEX_PRICE2 <= HEX_ZERO;
			HEX_PRICE3 <= HEX_ZERO;
	END CASE;
	
	HEX3 <= HEX_OFF;
		
END PROCESS;

--HEX_PRICE1

--HEX_PRICE2

--HEX_PRICE3

END behavior;