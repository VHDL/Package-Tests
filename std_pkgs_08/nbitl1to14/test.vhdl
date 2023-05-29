-- file numeric_bit_tb5.vhd is a simulation testbench for 
-- IEEE 1076.3 numeric_bit package.
-- This is the fifth file in the series, following
-- numeric_bit_tb4.vhd
--
library IEEE;
library not_IEEE;

use IEEE.std_logic_1164.all;
use not_IEEE.numeric_bit.all;

entity test is 
  generic (
    quiet : boolean := false);  -- make the simulation quiet
end entity;

architecture t1 of test is  
begin
  process

    procedure L_1 (LEFT, RESULT: in UNSIGNED) is 
    begin
      assert  (NOT(LEFT)) = (RESULT) 
        severity FAILURE;
    end L_1;

    procedure L_2 (LEFT,RIGHT, RESULT: in UNSIGNED) is 
    begin
      assert  (LEFT AND RIGHT) = (RESULT) 
        severity FAILURE;
    end L_2;

    procedure L_3 (LEFT,RIGHT, RESULT: in UNSIGNED) is 
    begin
      assert  (LEFT OR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_3;

    procedure L_4 (LEFT,RIGHT, RESULT: in UNSIGNED) is 
    begin
      assert  (LEFT NAND RIGHT) = (RESULT) 
        severity FAILURE;
    end L_4;

    procedure L_5 (LEFT,RIGHT, RESULT: in UNSIGNED) is 
    begin
      assert  (LEFT NOR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_5;

    procedure L_6 (LEFT,RIGHT, RESULT: in UNSIGNED) is 
    begin
      assert  (LEFT XOR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_6;

    procedure L_7 (LEFT,RIGHT, RESULT: in UNSIGNED) is 
    begin
      assert  (LEFT XNOR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_7;

    procedure L_8 (LEFT, RESULT: in SIGNED) is 
    begin
      assert  (NOT(LEFT)) = (RESULT) 
        severity FAILURE;
    end L_8;

    procedure L_9 (LEFT,RIGHT, RESULT: in SIGNED) is 
    begin
      assert  (LEFT AND RIGHT) = (RESULT) 
        severity FAILURE;
    end L_9;

    procedure L_10 (LEFT,RIGHT, RESULT: in SIGNED) is 
    begin
      assert  (LEFT OR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_10;

    procedure L_11 (LEFT,RIGHT, RESULT: in SIGNED) is 
    begin
      assert  (LEFT NAND RIGHT) = (RESULT) 
        severity FAILURE;
    end L_11;

    procedure L_12 (LEFT,RIGHT, RESULT: in SIGNED) is 
    begin
      assert  (LEFT NOR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_12;

    procedure L_13 (LEFT,RIGHT, RESULT: in SIGNED) is 
    begin
      assert  (LEFT XOR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_13;

    procedure L_14 (LEFT,RIGHT, RESULT: in SIGNED) is 
    begin
      assert  (LEFT XNOR RIGHT) = (RESULT) 
        severity FAILURE;
    end L_14;

  begin

    assert quiet report "start of tb5 tests" severity note;

    L_1("0","1");
    L_1("1","0");
    L_1("10101","01010");
    L_1("01010","10101");
    L_1("0101001010010100101001010",
        "1010110101101011010110101");
    L_1("0101010101010101","1010101010101010");
    L_1("01010101010101011","10101010101010100");
    L_1("01010101010101010101010101010101",
        "10101010101010101010101010101010");
    L_1("0101010101011010101010101010101",
        "1010101010100101010101010101010");
    L_1("010101010101010101010101010101011",
        "101010101010101010101010101010100");
    L_1("0101010101010101010101010101010101010101010101010101010101010101",
        "1010101010101010101010101010101010101010101010101010101010101010");
    L_1("010101010101010101011010101010101010101010101010101010101010101",
        "101010101010101010100101010101010101010101010101010101010101010");
    L_1("01010101010101010101010101010101101010101010101010101010101010101",
        "10101010101010101010101010101010010101010101010101010101010101010");

    assert quiet report "L_1 tests done" severity note;

    L_2("0","0","0");
    L_2("1","0","0");
    L_2("1","1","1");
    L_2("0","1","0");
    L_2("01","11","01");
    L_2("11","11","11");
    L_2("1111","1111","1111");
    L_2("1011","1111","1011");
    L_2("10111011","11111111","10111011");
    L_2("11111111","10111011","10111011");
    L_2("1111111111111111","1011101110111011","1011101110111011");
    L_2("1011101110111011","1111111111111111","1011101110111011");
    L_2("10111011101110111011101110111011",
        "11111111111111111111111111111111",
        "10111011101110111011101110111011");
    L_2("101110111011101110111011101110111",
        "111111111111111111111111111111110",
        "101110111011101110111011101110110");
    L_2("1011101110111011101110110111011",
        "1111111111111111111111111111111",
        "1011101110111011101110110111011");
    L_2("1011101110111011101110111011101110111011101110111011101110111011",
        "1111111111111111111111111111111111111111111111111111111111111111",
        "1011101110111011101110111011101110111011101110111011101110111011");
    L_2("101110111011101110111011101110111011111101110111011101110111011",
        "111111111111111111111111111111111111111111111111111111111111111",
        "101110111011101110111011101110111011111101110111011101110111011");
    L_2("10111011101110111011101110111011110111011101110111011101110111011",
        "11111111111111111111111111111111101111111111111111111111111111111",
        "10111011101110111011101110111011100111011101110111011101110111011");
    
    assert quiet report "L_2 tests done" severity note;

    L_3("0","0","0");
    L_3("1","0","1");
    L_3("1","1","1");
    L_3("0","1","1");
    L_3("01","10","11");
    L_3("0101","1010","1111");
    L_3("0001","1010","1011");
    L_3("00010001","10101010","10111011");
    L_3("10101010","00010001","10111011");
    L_3("1010101010101010","0001000100010001","1011101110111011");
    L_3("0001000100010001","1010101010101010","1011101110111011");
    L_3("00010001000100010001000100010001",
        "10101010101010101010101010101010",
        "10111011101110111011101110111011");
    L_3("000100010001000100010001000100010",
        "101010101010101010101010101010100",
        "101110111011101110111011101110110");
    L_3("0001000100010001000100100010001",
        "1010101010101010101010010101010",
        "1011101110111011101110110111011");
    L_3("0001000100010001000100010001000100010001000100010001000100010001",
        "1010101010101010101010101010101010101010101010101010101010101010",
        "1011101110111011101110111011101110111011101110111011101110111011");
    L_3("000100010001000100010001000100010001000000100010001000100010001",
        "101010101010101010101010101010101010101101010101010101010101010",
        "101110111011101110111011101110111011101101110111011101110111011");
    L_3("00010001000100010001000100010001000100010001000100010001000100011",
        "10101010101010101010101010101010101010101010101010101010101010101",
        "10111011101110111011101110111011101110111011101110111011101110111");

    assert quiet report "L_3 tests done" severity note;

    L_4("0","0","1");
    L_4("1","0","1");
    L_4("1","1","0");
    L_4("0","1","1");
    L_4("01","11","10");
    L_4("0101","1111","1010");
    L_4("01010101","11111111","10101010");
    L_4("0101010101010101","1111111111111111","1010101010101010");
    L_4("1111111111111111","0101010101010101","1010101010101010");
    L_4("11111111111111111111111111111111",
        "01010101010101010101010101010101",
        "10101010101010101010101010101010");
    L_4("111111111111111111111111111111110",
        "010101010101010101010101010101011",
        "101010101010101010101010101010101");
    L_4("1111111111111111111111111111111",
        "0101010101010101010101010110101",
        "1010101010101010101010101001010");
    L_4("1111111111111111111111111111111111111111111111111111111111111111",
        "0101010101010101010101010101010101010101010101010101010101010101",
        "1010101010101010101010101010101010101010101010101010101010101010");

    assert quiet report "L_4 tests done" severity note;

    L_5("0","0","1");
    L_5("0","1","0");
    L_5("1","1","0");
    L_5("1","0","0");
    L_5("1010","0110","0001");
    L_5("10101010","01100110","00010001");
    L_5("1010101010101010","0110011001100110","0001000100010001");
    L_5("10101010101010101010101010101010",
        "01100110011001100110011001100110",
        "00010001000100010001000100010001");
    L_5("101010101010101010101010101010100",
        "011001100110011001100110011001100",
        "000100010001000100010001000100011");
    L_5("1010101011010101010101010101010",
        "0110011001001100110011001100110",
        "0001000100100010001000100010001");
    L_5("1010101010101010101010101010101010101010101010101010101010101010",
        "0110011001100110011001100110011001100110011001100110011001100110",
        "0001000100010001000100010001000100010001000100010001000100010001");

    assert quiet report "L_5 tests done" severity note;

    L_6("0","0","0");
    L_6("0","1","1");
    L_6("1","1","0");
    L_6("1","0","1");
    L_6("1010","0110","1100");
    L_6("10101010","01100110","11001100");
    L_6("1010101010101010","0110011001100110","1100110011001100");
    L_6("10101010101010101010101010101010",
        "01100110011001100110011001100110",
        "11001100110011001100110011001100");
    L_6("1010101010101010101010101010101010101010101010101010101010101010",
        "0110011001100110011001100110011001100110011001100110011001100110",
        "1100110011001100110011001100110011001100110011001100110011001100");

    assert quiet report "L_6 tests done" severity note;

    L_7("0","0","1");
    L_7("1","0","0");
    L_7("1","1","1");
    L_7("0","1","0");
    L_7("0101","1100","0110");
    L_7("01010101","11001100","01100110");
    L_7("0101010101010101","1100110011001100","0110011001100110");
    L_7("01010101010101010101010101010101",
        "11001100110011001100110011001100",
        "01100110011001100110011001100110");
    L_7("0101010101010101010101010101010101010101010101010101010101010101",
        "1100110011001100110011001100110011001100110011001100110011001100",
        "0110011001100110011001100110011001100110011001100110011001100110");

    assert quiet report "L_7 tests done" severity note;

    L_8("0","1");
    L_8("1","0");
    L_8("10101","01010");
    L_8("01010","10101");
    L_8("0101001010010100101001010",
        "1010110101101011010110101");
    L_8("0101010101010101","1010101010101010");
    L_8("01010101010101011","10101010101010100");
    L_8("01010101010101010101010101010101",
        "10101010101010101010101010101010");
    L_8("0101010101011010101010101010101",
        "1010101010100101010101010101010");
    L_8("010101010101010101010101010101011",
        "101010101010101010101010101010100");
    L_8("0101010101010101010101010101010101010101010101010101010101010101",
        "1010101010101010101010101010101010101010101010101010101010101010");
    L_8("010101010101010101011010101010101010101010101010101010101010101",
        "101010101010101010100101010101010101010101010101010101010101010");
    L_8("01010101010101010101010101010101101010101010101010101010101010101",
        "10101010101010101010101010101010010101010101010101010101010101010");

    assert quiet report "L_8 tests done" severity note;
    
    L_9("0","0","0");
    L_9("1","0","0");
    L_9("1","1","1");
    L_9("0","1","0");
    L_9("01","11","01");
    L_9("11","11","11");
    L_9("1111","1111","1111");
    L_9("1011","1111","1011");
    L_9("10111011","11111111","10111011");
    L_9("11111111","10111011","10111011");
    L_9("1111111111111111","1011101110111011","1011101110111011");
    L_9("1011101110111011","1111111111111111","1011101110111011");
    L_9("10111011101110111011101110111011",
        "11111111111111111111111111111111",
        "10111011101110111011101110111011");
    L_9("101110111011101110111011101110111",
        "111111111111111111111111111111110",
        "101110111011101110111011101110110");
    L_9("1011101110111011101110110111011",
        "1111111111111111111111111111111",
        "1011101110111011101110110111011");
    L_9("1011101110111011101110111011101110111011101110111011101110111011",
        "1111111111111111111111111111111111111111111111111111111111111111",
        "1011101110111011101110111011101110111011101110111011101110111011");
    L_9("101110111011101110111011101110111011111101110111011101110111011",
        "111111111111111111111111111111111111111111111111111111111111111",
        "101110111011101110111011101110111011111101110111011101110111011");
    L_9("10111011101110111011101110111011110111011101110111011101110111011",
        "11111111111111111111111111111111101111111111111111111111111111111",
        "10111011101110111011101110111011100111011101110111011101110111011");
    
    assert quiet report "L_9 tests done" severity note;


    L_10("0","0","0");
    L_10("1","0","1");
    L_10("1","1","1");
    L_10("0","1","1");
    L_10("01","10","11");
    L_10("0101","1010","1111");
    L_10("0001","1010","1011");
    L_10("00010001","10101010","10111011");
    L_10("10101010","00010001","10111011");
    L_10("1010101010101010","0001000100010001","1011101110111011");
    L_10("0001000100010001","1010101010101010","1011101110111011");
    L_10("00010001000100010001000100010001",
         "10101010101010101010101010101010",
         "10111011101110111011101110111011");
    L_10("000100010001000100010001000100010",
         "101010101010101010101010101010100",
         "101110111011101110111011101110110");
    L_10("0001000100010001000100100010001",
         "1010101010101010101010010101010",
         "1011101110111011101110110111011");
    L_10("0001000100010001000100010001000100010001000100010001000100010001",
         "1010101010101010101010101010101010101010101010101010101010101010",
         "1011101110111011101110111011101110111011101110111011101110111011");
    L_10("000100010001000100010001000100010001000000100010001000100010001",
         "101010101010101010101010101010101010101101010101010101010101010",
         "101110111011101110111011101110111011101101110111011101110111011");
    L_10("00010001000100010001000100010001000100010001000100010001000100011",
         "10101010101010101010101010101010101010101010101010101010101010101",
         "10111011101110111011101110111011101110111011101110111011101110111");

    assert quiet report "L_10 tests done" severity note;


    L_11("0","0","1");
    L_11("1","0","1");
    L_11("1","1","0");
    L_11("0","1","1");
    L_11("01","11","10");
    L_11("0101","1111","1010");
    L_11("01010101","11111111","10101010");
    L_11("0101010101010101","1111111111111111","1010101010101010");
    L_11("1111111111111111","0101010101010101","1010101010101010");
    L_11("11111111111111111111111111111111",
         "01010101010101010101010101010101",
         "10101010101010101010101010101010");
    L_11("111111111111111111111111111111110",
         "010101010101010101010101010101011",
         "101010101010101010101010101010101");
    L_11("1111111111111111111111111111111",
         "0101010101010101010101010110101",
         "1010101010101010101010101001010");
    L_11("1111111111111111111111111111111111111111111111111111111111111111",
         "0101010101010101010101010101010101010101010101010101010101010101",
         "1010101010101010101010101010101010101010101010101010101010101010");

    assert quiet report "L_11 tests done" severity note;


    L_12("0","0","1");
    L_12("0","1","0");
    L_12("1","1","0");
    L_12("1","0","0");
    L_12("1010","0110","0001");
    L_12("10101010","01100110","00010001");
    L_12("1010101010101010","0110011001100110","0001000100010001");
    L_12("10101010101010101010101010101010",
         "01100110011001100110011001100110",
         "00010001000100010001000100010001");
    L_12("101010101010101010101010101010100",
         "011001100110011001100110011001100",
         "000100010001000100010001000100011");
    L_12("1010101011010101010101010101010",
         "0110011001001100110011001100110",
         "0001000100100010001000100010001");
    L_12("1010101010101010101010101010101010101010101010101010101010101010",
         "0110011001100110011001100110011001100110011001100110011001100110",
         "0001000100010001000100010001000100010001000100010001000100010001");

    assert quiet report "L_12 tests done" severity note;


    L_13("0","0","0");
    L_13("0","1","1");
    L_13("1","1","0");
    L_13("1","0","1");
    L_13("1010","0110","1100");
    L_13("10101010","01100110","11001100");
    L_13("1010101010101010","0110011001100110","1100110011001100");
    L_13("10101010101010101010101010101010",
         "01100110011001100110011001100110",
         "11001100110011001100110011001100");
    L_13("1010101010101010101010101010101010101010101010101010101010101010",
         "0110011001100110011001100110011001100110011001100110011001100110",
         "1100110011001100110011001100110011001100110011001100110011001100");

    assert quiet report "L_13 tests done" severity note;

    L_14("0","0","1");
    L_14("1","0","0");
    L_14("1","1","1");
    L_14("0","1","0");
    L_14("0101","1100","0110");
    L_14("01010101","11001100","01100110");
    L_14("0101010101010101","1100110011001100","0110011001100110");
    L_14("01010101010101010101010101010101",
         "11001100110011001100110011001100",
         "01100110011001100110011001100110");
    L_14("0101010101010101010101010101010101010101010101010101010101010101",
         "1100110011001100110011001100110011001100110011001100110011001100",
         "0110011001100110011001100110011001100110011001100110011001100110");

    assert quiet report "L_14 tests done" severity note;

    assert FALSE
      report "END OF test suite tb5"
      severity note;

    wait;
  end process;
end architecture; 



