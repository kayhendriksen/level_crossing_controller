--  University Of Brighton
--  School of Architecture, Technology and Engineering
--  BEng (Hons) Electronic and Computer Engineering BEng
--  Academic Year 2022-23
--  Second Year – Semester 1

--  Title:               Train Crossing Test Bench
--  Designers:           Kay Hendriksen & Isaiah Frederick Damion Jacobs
--  Student ID’s:        20810204 & 21849451
--  Module name & code:  Digital Systems Design EO528
--  Module leader:       Dr. S. Busbridge
--  Module teacher:      Mr. G. C. Denman    
--  Date:                20 January 2023
--  Version No:          1
--  Target:              DE0 Board - EP4CE22F17C6

library ieee;
use ieee.std_logic_1164.all;

entity light_controller_tb is
end light_controller_tb;

architecture testbench of light_controller_tb is
   signal clkin : std_logic;
   signal clkout : std_logic;
   signal reset : std_logic;
   signal start : std_logic;
   signal led_amber_car : std_logic;
   signal led_red_car_1 : std_logic;
   signal led_red_car_2 : std_logic;
   signal led_red_ped : std_logic;
   signal led_green_ped : std_logic;
   signal led_red_train : std_logic;
   signal led_green_train : std_logic;
begin
   -- Instantiate the design under test
   uut: entity work.light_controller
       generic map (
           divide_ratio => 25000000
       )
       port map (
           clkin => clkin,
           clkout => clkout,
           reset => reset,
           start => start,
           led_amber_car => led_amber_car,
           led_red_car_1 => led_red_car_1,
           led_red_car_2 => led_red_car_2,
           led_red_ped => led_red_ped,
           led_green_ped => led_green_ped,
           led_red_train => led_red_train,
           led_green_train => led_green_train
       );

   -- Clock process
   clock_process : process
   begin
       clkin <= '1';
       wait for 10 ns;
       clkin <= '0';
       wait for 10 ns;
   end process;

   -- Stimulus process
   stim_process : process
   begin
       wait for 50 ns; -- Wait for the reset to take effect
       reset <= '1';
       wait for 50 ns;
       start <= '1'; -- Press the start button
       wait for 500 ns;
       start <= '0'; -- Release the start button
       wait; -- Wait for the simulation to finish
   end process;
end testbench;
