library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity ProjectAB is
Port (Clock, Resetn : IN STD_LOGIC;
		Row : IN STD_LOGIC_VECTOR(2 downto 0);
		Col : IN STD_LOGIC_VECTOR(1 downto 0);
		Adjust_Up: IN STD_LOGIC;
		Adjust_Down: IN STD_LOGIC;
		Next_State: IN STD_LOGIC;
		Item_Price : OUT STD_LOGIC_VECTOR(4 downto 0);
		Item_Slot : OUT STD_LOGIC_VECTOR(4 downto 0);
		Hex_COL	: OUT STD_LOGIC_VECTOR(6 downto 0);
		Hex_ROW	: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX_COUNTER1: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX_COUNTER2: OUT STD_LOGIC_VECTOR(6 downto 0);
		HEX_COUNTER3: OUT STD_LOGIC_VECTOR(6 downto 0);
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

TYPE STATETYPE IS (STATE0, STATE1, STATE2);
SIGNAL STATE : STATETYPE;

--Allows us to quickly reference hex assignment for the 7seg display
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

--Each category will get a unique 3 bit assignment
SIGNAL CATEGORY: STD_LOGIC_VECTOR(2 downto 0);

--integers for doing transaction math
VARIABLE PRICE 				: INTEGER RANGE 0 TO 999;
VARIABLE TENDER				: INTEGER RANGE 0 TO 999 := 0;
VARIABLE CHANGE				: INTEGER RANGE 0 TO 999;

VARIABLE PRICE_ONES			: INTEGER RANGE 0 TO 9;
VARIABLE PRICE_TENTHS		: INTEGER RANGE 0 TO 9;
VARIABLE PRICE_HUNDREDTHS	: INTEGER RANGE 0 TO 9;

VARIABLE TENDER_ONES		: INTEGER RANGE 0 TO 9;
VARIABLE TENDER_TENTHS		: INTEGER RANGE 0 TO 9;
VARIABLE TENDER_HUNDREDTHS: INTEGER RANGE 0 TO 9;

VARIABLE CHANGE_ONES		: INTEGER RANGE 0 TO 9;
VARIABLE CHANGE_TENTHS		: INTEGER RANGE 0 TO 9;
VARIABLE CHANGE_HUNDREDTHS: INTEGER RANGE 0 TO 9;

--Temporary hex values
SIGNAL TEMP_HEX_COUNTER1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL TEMP_HEX_COUNTER2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL TEMP_HEX_COUNTER3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL TEMP_HEX_ROW : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL TEMP_HEX_COL : STD_LOGIC_VECTOR(6 DOWNTO 0);

--Variables that set how much each items in a category costs values will always be x10^2 of actual displayed price
--default values
SIGNAL PRICE_CANDY    : INTEGER RANGE 0 TO 999 := 150;  -- $1.50
SIGNAL PRICE_CHIPS    : INTEGER RANGE 0 TO 999 := 300;  -- $3.00
SIGNAL PRICE_NUTS     : INTEGER RANGE 0 TO 999 := 250;  -- $2.50
SIGNAL PRICE_SODA     : INTEGER RANGE 0 TO 999 := 175;  -- $1.75
SIGNAL PRICE_DIETSODA : INTEGER RANGE 0 TO 999 := 125;  -- $1.25
SIGNAL PRICE_JUICE    : INTEGER RANGE 0 TO 999 := 210;  -- $2.10



--000 CANDY
--001 CHIPS
--010 NUTS
--011 SODA
--100 DIET SODA
--101 JUICE 

--Function to convert from an integer digit to the 7seg hex digit assignment
--ex: 8 -> "0000000"
FUNCTION convertToHex(digit : INTEGER) RETURN STD_LOGIC_VECTOR IS
		BEGIN
		CASE digit IS
		  WHEN 0 => RETURN "1000000";
		  WHEN 1 => RETURN "1111001";
		  WHEN 2 => RETURN "0100100";
		  WHEN 3 => RETURN "0110000";
		  WHEN 4 => RETURN "0011001";
		  WHEN 5 => RETURN "0010010";
		  WHEN 6 => RETURN "0000010";
		  WHEN 7 => RETURN "1111000";
		  WHEN 8 => RETURN "0000000";
		  WHEN 9 => RETURN "0011000";
		  WHEN OTHERS => RETURN "1111111";
		END CASE;
END FUNCTION;
	
BEGIN

PROCESS(Clock, Resetn)
	BEGIN 
		IF Resetn = '0' THEN
			STATE <= STATE0;
		ELSIF (Rising_Edge(Clock)) THEN
			CASE STATE IS
				WHEN STATE0 =>
					TENDER <= 0;
					IF (Next_State = '1') THEN
						STATE <= STATE1;
					END IF;
					--First Column	
					IF (Row = "000" and Col = "00") THEN    --SLOT A0
						Item_Slot <= "00000"; --M AND M'S
						CATEGORY <= "000";
					ELSIF (Row = "001" and Col = "00") THEN --SLOT B0
						Item_Slot <= "00001"; --BBQ CHIPS 
						CATEGORY <= "001";
					ELSIF (Row = "010" and Col = "00") THEN --SLOT C0
						Item_Slot <= "00010"; --COOL RANCH DORITOS
						CATEGORY <= "001";
					ELSIF (Row = "011" and Col = "00") THEN --SLOT D0
						Item_Slot <= "00011"; --ROASTED ALMOND NUTS
						CATEGORY <= "010";
					ELSIF (Row = "100" and Col = "00") THEN --SLOT E0
						Item_Slot <= "00100"; --COCA COLA
						CATEGORY <= "011";
					ELSIF (Row = "101" and Col = "00") THEN --SLOT F0
						Item_Slot <= "00101"; --DIET MOUNTAIN DEW
						CATEGORY <= "100";
					ELSIF (Row = "110" and Col = "00") THEN --SLOT G0
						Item_Slot <= "00110"; --FRUIT PUNCH
						CATEGORY <= "101";
						--Second Column
					ELSIF (Row = "000" and Col = "01") THEN --SLOT A1
						Item_Slot <= "01000"; --SKITTLES
						CATEGORY <= "000";
					ELSIF (Row = "001" and Col = "01") THEN --SLOT B1
						Item_Slot <= "01001"; --SOUR CREAM & ONION CHIPS
						CATEGORY <= "001";
					ELSIF (Row = "010" and Col = "01") THEN --SLOT C1
						Item_Slot <= "01010"; --SPICY NACHO DORITOS
						CATEGORY <= "001";
					ELSIF (Row = "011" and Col = "01") THEN --SLOT D1
						Item_Slot <= "01011"; --TRAIL MIX
						CATEGORY <= "010";	
					ELSIF (Row = "100" and Col = "01") THEN --SLOT E1
						Item_Slot <= "01100"; --SPRITE
						CATEGORY <= "011";
					ELSIF (Row = "101" and Col = "01") THEN --SLOT F1
						Item_Slot <= "01101"; --DIET COKE
						CATEGORY <= "100";
					ELSIF (Row = "110" and Col = "01") THEN --SLOT G1
						Item_Slot <= "01110"; --LEMONADE
						CATEGORY <= "101";
						--Third Column
					ELSIF (Row = "000" and Col = "10") THEN --SLOT A2
						Item_Slot <= "10000"; --HERSHEYS CHOCOLATE BAR	
						CATEGORY <= "000";
					ELSIF (Row = "001" and Col = "10") THEN --SLOT B2
						Item_Slot <= "10001"; --SALT & VINEGAR CHIPS
						CATEGORY <= "001";
					ELSIF (Row = "010" and Col = "10") THEN --SLOT C2
						Item_Slot <= "10010"; --SWEET CHILI DORITOS
						CATEGORY <= "001";
					ELSIF (Row = "011" and Col = "10") THEN --SLOT D2
						Item_Slot <= "10011"; --GRONOLA BAR
						CATEGORY <= "010";
					ELSIF (Row = "100" and Col = "10") THEN --SLOT E2
						Item_Slot <= "10100"; --DR PEPPER
						CATEGORY <= "011";
					ELSIF (Row = "101" and Col = "10") THEN --SLOT F2
						Item_Slot <= "10101"; --DIET DR PEPPER
						CATEGORY <= "100";
					ELSIF (Row = "110" and Col = "10") THEN --SLOT G2
						Item_Slot <= "10110"; --APPLE JUICE 
						CATEGORY <= "101";
						--Fourth Column 
					ELSIF (Row = "000" and Col = "11") THEN --SLOT A3
						Item_Slot <= "11000"; --PROTEIN BAR 
						CATEGORY <= "000";
					ELSIF (Row = "001" and Col = "11") THEN --SLOT B3
						Item_Slot <= "11001"; --CLASSIC POTATO CHIPS
						CATEGORY <= "001";
					ELSIF (Row = "010" and Col = "11") THEN --SLOT C3
						Item_Slot <= "11010"; --NACHO CHEESE DORITOS
						CATEGORY <= "001";
					ELSIF (Row = "011" and Col = "11") THEN --SLOT D3
						Item_Slot <= "11011"; --SALTED PEANUTS
						CATEGORY <= "010";
					ELSIF (Row = "100" and Col = "11") THEN --SLOT E3
						Item_Slot <= "11100"; --ORANGE FANTA
						CATEGORY <= "011";	
					ELSIF (Row = "101" and Col = "11") THEN --SLOT F3
						Item_Slot <= "11101"; --DIET SPRITE
						CATEGORY <= "100";
					ELSIF (Row = "100" and Col = "11") THEN --SLOT G3
						Item_Slot <= "11110"; --ORANGE JUICE
						CATEGORY <= "101";
					END IF;
					
					CASE Col IS
						WHEN "00" => TEMP_HEX_COL <= HEX_ZERO;
						WHEN "01" => TEMP_HEX_COL <= HEX_ONE;
						WHEN "10" => TEMP_HEX_COL <= HEX_TWO;
						WHEN "11" => TEMP_HEX_COL <= HEX_THREE;
						WHEN OTHERS => TEMP_HEX_COL <= HEX_OFF;
					END CASE;

					CASE Row IS
						WHEN "000" => TEMP_HEX_ROW <= HEX_A;
						WHEN "001" => TEMP_HEX_ROW <= HEX_B;
						WHEN "010" => TEMP_HEX_ROW <= HEX_C;
						WHEN "011" => TEMP_HEX_ROW <= HEX_D;
						WHEN "100" => TEMP_HEX_ROW <= HEX_E;
						WHEN "101" => TEMP_HEX_ROW <= HEX_F;
						WHEN "110" => TEMP_HEX_ROW <= HEX_G;
						WHEN OTHERS => TEMP_HEX_ROW <= HEX_OFF;
					END CASE;
					
					--000 CANDY
					--001 CHIPS
					--010 NUTS
					--011 SODA
					--100 DIET SODA
					--101 JUICE 
					CASE CATEGORY IS
						WHEN "000" => PRICE <= PRICE_CANDY;
						WHEN "001" => PRICE <= PRICE_CHIPS;
						WHEN "010" => PRICE <= PRICE_NUTS;
						WHEN "011" => PRICE <= PRICE_SODA;
						WHEN "100" => PRICE <= PRICE_DIETSODA;
						WHEN "101" => PRICE <= PRICE_JUICE;
						WHEN OTHERS => PRICE <= 0;
					END CASE;
					
					--grab each digit of PRICE
					PRICE_ONES <= PRICE / 100;
					PRICE_TENTHS <= (PRICE MOD 100) / 10;
					PRICE_HUNDREDTHS <= PRICE MOD 10;
					--convert each digit to hex and send to 7 segment display
					TEMP_HEX_COUNTER1 <= convertToHex(PRICE_ONES);
					TEMP_HEX_COUNTER2 <= convertToHex(PRICE_TENTHS);
					TEMP_HEX_COUNTER3 <= convertToHex(PRICE_HUNDREDTHS);
					
				WHEN STATE1 => 
					IF (Next_State = '1') THEN
						STATE <= STATE2;
					END IF;
					IF (Adjust_Up = '1' AND Adjust_Down = '0') THEN
						IF (TENDER < 995) THEN
							TENDER <= TENDER + 5;
						END IF;
						
					ELSIF (Adjust_Down = '1' AND Adjust_Down = '0') THEN
						IF (TENDER >= 5) THEN
							TENDER <= TENDER - 5;
						END IF;
					END IF;
					
					--grab each digit of TENDER
					TENDER_ONES <= TENDER / 100;
					TENDER_TENTHS <= (TENDER MOD 100) / 10;
					TENDER_HUNDREDTHS <= TENDER MOD 10;
					--convert each digit to hex and send to 7 segment display
					TEMP_HEX_COUNTER1 <= convertToHex(TENDER_ONES);
					TEMP_HEX_COUNTER2 <= convertToHex(TENDER_TENTHS);
					TEMP_HEX_COUNTER3 <= convertToHex(TENDER_HUNDREDTHS);
				WHEN STATE2 =>
					IF (Next_State = '1') THEN
						STATE <= STATE0;
					END IF;
					
					CHANGE <= TENDER - PRICE;
					
					CHANGE_ONES <= CHANGE / 100;
					CHANGE_TENTHS <= (CHANGE MOD 100) / 10;
					CHANGE_HUNDREDTHS <= CHANGE MOD 10;
					--convert each digit to hex and send to 7 segment display
					TEMP_HEX_COUNTER1 <= convertToHex(CHANGE_ONES);
					TEMP_HEX_COUNTER2 <= convertToHex(CHANGE_TENTHS);
					TEMP_HEX_COUNTER3 <= convertToHex(CHANGE_HUNDREDTHS);
			END CASE;	
					
		END IF;
	
	HEX3 <= HEX_OFF;
		
END PROCESS;

	HEX_COUNTER1 <= TEMP_HEX_COUNTER1;
	HEX_COUNTER2 <= TEMP_HEX_COUNTER2;
	HEX_COUNTER3 <= TEMP_HEX_COUNTER3;

	HEX_ROW <= TEMP_HEX_ROW;
	HEX_COL <= TEMP_HEX_COL;

END behavior;
