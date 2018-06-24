library ieee;
use ieee.std_logic_1164.all;

entity speed_counter_tb is
end speed_counter_tb;

architecture behav of speed_counter_tb is
   component speed_counter
     port (
        clk : in std_logic;
        rst : in std_logic;
        in_60_1 : in std_logic;
        gap_det : out std_logic;
        low_speed : out std_logic;
        period_cnt : out std_logic_vector(13 downto 0) 
       );
   end component;
   
   signal clk, rst, in_60_1, gap_det, low_speed : std_logic;
   signal period_cnt : std_logic_vector(13 downto 0);
   constant clk_in_t : time := 1 us;
   constant speed_of_motor : time := 200 us;
   begin
   S_c_0: speed_counter
   port map (
              clk => clk,
              rst => rst,
              in_60_1 => in_60_1,
              gap_det => gap_det,
              low_speed => low_speed,
              period_cnt => period_cnt
            );
   entrada_process : process -- clock 
   begin
        clk<= '0';
        wait for clk_in_t / 2;
        clk<= '1';
        wait for clk_in_t/ 2;
   end process;
   stimuli: process
   begin
      in_60_1 <= '1';
      rst <= '1';
      wait for 100 ns;
      rst <= '0';
      wait for speed_of_motor;
      in_60_1 <= '0';
      for k in 0 to 2 loop
		    for i in 0 to 2 loop
				  for j in 0 to 59 loop
				    in_60_1<= '0';
				    wait for speed_of_motor / 2;
				    in_60_1<= '1';
				    wait for speed_of_motor / 2; 
				  end loop;
				  wait for speed_of_motor;
				end loop;
		  	wait for 20 ms; 
		  end loop;
      assert false report "end of test" severity note;
      wait;
   end process;
end behav;
