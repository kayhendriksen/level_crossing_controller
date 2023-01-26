--  University Of Brighton
--  School of Architecture, Technology and Engineering
--  BEng (Hons) Electronic and Computer Engineering BEng
--  Academic Year 2022-23
--  Second Year – Semester 1

--  Title:               Train Crossing
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
use ieee.numeric_std.all;

-- Entity Declarations
entity light_controller is
    generic (
        divide_ratio: integer := 25000000  -- Parameter for setting the frequency of the clkout signal to 2hz
    );
    Port (
        clkin           : in  std_logic;    -- Input used to generate the clkout signal
        clkout          : inout  std_logic; -- Output for the 2hz clock signal
        reset           : in  std_logic;    -- Input for resetting the circuit
        start           : in  std_logic;    -- Input for starting the traffic light sequence (train sensor)
        led_amber_car   : out std_logic;    -- Output for the car amber light
        led_red_car_1   : out std_logic;    -- Output for first set of blinking red car lights
        led_red_car_2   : out std_logic;    -- Output for second set of blinking red car lights
        led_red_ped     : out std_logic;    -- Output for the red pedestrian light
        led_green_ped   : buffer std_logic; -- Output for the green pedestrian light
        led_red_train   : buffer std_logic; -- Output for the red train light
        led_green_train : buffer std_logic  -- Output for the green train light
    );        
end light_controller;

-- Architecture Declarations
architecture Behavioral of light_controller is
    -- Counter to keep track of time in the state machine process (54 cycles = 27 seconds because of 2hz frequency)
    signal count : integer range 0 to 54;
    
    -- Declaring a state variable to keep track of the current state
    type state_type is (
        state_1,    -- initial state : led_green_ped on, led_red_train on
        state_2,    -- second state : led_green_ped on, led_red_train on, led_amber_car on
        state_3,    -- third state : led_red_train on, led_red_car_1 on, led_red_car_2 on, led_red_ped on
        state_4,    -- fourth state : led_red_car_1 on, led_red_car_2 on, led_red_ped on, led_green_train on, 
        state_5     -- fifth state : led_red_train on, led_red_car_1 on, led_red_car_2 on, led_red_ped on
    ); 
    signal state : state_type;
 
begin
    -- Clock Generation Process
    clock_generation: process (clkin)
    variable count : integer range 0 to divide_ratio; -- Variable for counting clkout cycles to generate the clkout signal
    begin
        if rising_edge(clkin) then          -- If the clkin signal is rising edge
            count := count + 1;             -- Increment the counter
            if count < divide_ratio/2 then  -- If the counter is less than half the divide ratio
                clkout <= '0';              -- If the counter is less than half the divide ratio, set the clkout to '0'
            elsif count < divide_ratio then -- If the counter is less than divide ratio
                clkout <= '1';              -- If the counter is less than divide ratio, set the clkout to '1'
            else                            -- If the counter is greater than divide ratio
                count := 0;                 -- Reset the counter back to 0
            end if;
        end if;
    end process clock_generation;
    
    -- State machine process
    process(clkout)                         -- The process is triggered by the clkout signal
    begin
        if rising_edge(clkout) then         -- If the clkout signal is rising edge
            if reset = '0' then             -- If the reset button is pressed
                -- Reset the counter and state
                count <= 0;                 -- Reset the counter to 0
                state <= state_1;           -- Reset the state to state_1
            else
                -- Increment the count and update the state
                count <= count + 1;
                case state is
                    when state_1 =>
                        if start = '0' then     -- when the start button is pressed (train sensor) the state_2 is iniated
                            state <= state_2;
                        end if;
                    when state_2 =>
                        if count = 6 then       -- after 6 cycles (3 seconds) the state_3 is initiated
                            state <= state_3;
                        end if;
                    when state_3 =>
                        if count = 22 then      -- after 22 cycles (11 seconds) the state_4 is initiated
                            state <= state_4;
                        end if;
                    when state_4 =>
                        if count = 38 then      -- after 38 cycles (19 seconds) the state_5 is initiated
                            state <= state_5;
                        end if;
                    when state_5 =>
                        if count = 54 then      -- after 54 cycles (27 seconds) the state_1 is initiated
                            state <= state_1;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- Train crossing light sequence output logic
    led_green_ped <= '1' when state = state_1 or state = state_2 else '0';
    led_red_train <= '1' when state = state_1 or state = state_2 or state = state_3 or state = state_5 else '0';
    led_amber_car <= '1' when state = state_2 else '0';
    led_green_train <= '1' when state = state_4 else '0';
    led_red_car_1 <= '1' when (state = state_3 or state = state_4 or state = state_5) and count mod 2 = 0 else '0';
    led_red_car_2<= '1' when (state = state_3 or state = state_4 or state = state_5) and count mod 2 = 1 else '0';
    led_red_ped <= '1' when state = state_3 or state = state_4 or state = state_5 else '0';

end Behavioral;
