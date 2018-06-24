library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity speed_counter is
  port (
        clk : in std_logic;--1Mhz clock 
        rst : in std_logic;
        in_60_1 : in std_logic;
        gap_det : out std_logic;
        low_speed : out std_logic;
        period_cnt : out std_logic_vector(13 downto 0) 
       );
end speed_counter;

architecture behavioral of speed_counter is
signal s_in_60_1: std_logic_vector(2 downto 0);
signal p_pulse_cnt, n_pulse_cnt, n_pulse_cmp : std_logic_vector(period_cnt'range);
signal p_counter_fl, n_counter_fl : std_logic;
begin
    process(clk,rst)
    begin
      if(rst='1')then
      	p_counter_fl<='0';
      	n_counter_fl<='0';
        s_in_60_1<=(others=>'0');
        n_pulse_cnt <= (others=>'0');
        p_pulse_cnt <= (others=>'0');
        gap_det <= '0';
        low_speed <= '0';
        period_cnt <= (others=>'1');
        n_pulse_cmp <= (others=>'0');
      elsif (clk'event and clk ='1') then
        s_in_60_1<=s_in_60_1 sll 1;
        s_in_60_1(0)<=in_60_1;
        if (s_in_60_1="110" and gap_det = '0') then
        	period_cnt <= n_pulse_cnt+p_pulse_cnt+3;
        elsif(s_in_60_1="100") then
          n_pulse_cnt <= (others=>'0');
          p_pulse_cnt <= (others=>'0');
          n_counter_fl <= '1';
          p_counter_fl<='0';
          low_speed <= '0';
        elsif(s_in_60_1="001") then
          n_counter_fl <= '0';
          p_counter_fl<='1';
          n_pulse_cmp <= n_pulse_cnt + (n_pulse_cnt srl 1);
        else 
        	if(n_counter_fl='1' and p_counter_fl='0') then
				 		if n_pulse_cnt = (n_pulse_cnt'range => '1') then
				 			n_pulse_cnt <= (others=>'1');
				 			low_speed <= '1';
				 			period_cnt <= (others=>'1');
				 		else
				 			n_pulse_cnt <= n_pulse_cnt + 1;
				 		end if;
				  elsif(n_counter_fl='0' and p_counter_fl='1')then
						if p_pulse_cnt = (p_pulse_cnt'range => '1') then
				 			p_pulse_cnt <= (others=>'1');
				 			low_speed <= '1';
				 			period_cnt <= (others=>'1');
				 		else
				 			p_pulse_cnt <= p_pulse_cnt + 1;
				 		end if;
				  end if;
        end if;
        if(p_pulse_cnt > n_pulse_cmp) then
					gap_det <= '1';
				else
					gap_det <= '0';
				end if;
      end if;
    end process;
end behavioral;

