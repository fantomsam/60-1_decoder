library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity speed_counter_tb is
end speed_counter_tb;

architecture behav of speed_counter_tb is
   --  Declaration of the component that will be instantiated.
   component speed_counter
     port (
        clk : in std_logic;
        rst : in std_logic;
        in_60_1 : in std_logic;
        gap_det : out std_logic;
        low_speed : out std_logic 
       );
   end component;

   --  Specifies which entity is bound with the component.
   --for adder_0: adder use entity work.adder;
   signal clk, rst, in_60_1, gap_det, low_speed : std_logic;
   constant clk_in_t : time := 1000 ns;
   constant speed_of_motor : time := 250 us;
   begin
   --  Component instantiation.
   S_c_0: speed_counter
   port map (
              clk => clk,
              rst => rst,
              in_60_1 => in_60_1,
              gap_det => gap_det,
              low_speed => low_speed 
            );

   --  This process does the real job.
   -- clock 
   entrada_process : process
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
				    wait for speed_of_motor / 2.5;
				    in_60_1<= '1';
				    wait for speed_of_motor / 1.5; 
				  end loop;
				  wait for speed_of_motor;
				end loop;
		  	wait for 120 ms; 
		  end loop;
      assert false report "end of test" severity note;
      --  Wait forever; this will finish the simulation.
      wait;
   end process;
end behav;
