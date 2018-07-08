library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity speed_counter_and_gap_detector is
  port (
        clk : in std_logic;--2Mhz clock 
        rst : in std_logic;
        in_60_1 : in std_logic;
        gap_det : out std_logic;
        low_speed : out std_logic;
        half_period_cnt : out std_logic_vector(13 downto 0) 
       );
end speed_counter_and_gap_detector;

architecture behavioral of speed_counter_and_gap_detector is
signal s_in_60_1: std_logic_vector(1 downto 0) := (others=>'0');
signal pulse_cnt, n_pulse_cmp : std_logic_vector(half_period_cnt'range) := (others=>'0');
begin
    process(clk,rst)
    begin
      if(rst='1')then
        s_in_60_1<=(others=>'0');
        gap_det <= '0';
        low_speed <= '0';
        half_period_cnt <= (others=>'1');
        n_pulse_cmp <= (others=>'0');
        pulse_cnt <= (others=>'0');
      elsif (clk'event and clk ='1') then
        s_in_60_1<=s_in_60_1 sll 1;
        s_in_60_1(0)<=in_60_1;
        if(s_in_60_1="10" or s_in_60_1="01") then
        	pulse_cnt <= (others=>'0');
        	if (not gap_det) then
        		half_period_cnt <= pulse_cnt;
        	end if;
        	if (s_in_60_1="01") then
        		n_pulse_cmp <= pulse_cnt + (pulse_cnt srl 1);
        	end if;
        else
        	if(pulse_cnt = (pulse_cnt'range => '1')) then
        		low_speed <= '1';
        	else
        		pulse_cnt <= pulse_cnt + 1;
        		low_speed <= '0';
        	end if;
        end if;
        
        if(pulse_cnt > n_pulse_cmp) then
					gap_det <= '1';
				else
					gap_det <= '0';
				end if;
      end if;
    end process;
end behavioral;

