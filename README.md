In this project, I designed and implemented four components using Verilog, targeting the DE2 Zynq-7010 development board.
1.Sender Module:
The sender module encodes button presses using NRZ (Non-Return-to-Zero) encoding. Each button generates a unique 4-bit symbol upon being pressed, which serves as the data to be transmitted.
2. Receiver Module (Moore FSM):
This part uses a Moore finite state machine to decode the 4-bit symbol received from the sender. The output is a 3-bit value that identifies which button was pressed.
3. BCD Time Counter with Parental Control:
The console includes a 3-digit BCD timer (0–999) displayed on the 7-segment displays (HEX2–HEX0) to limit playtime. The timer is implemented using three modular components:
•	50 Million Counter: Counts clock cycles from a 50 MHz source to generate a 1-second pulse, with a reset feature.
•	0–9 Counter: A decimal counter that increments from 0 to 9 when enabled, and resets when required.
•	Hex Display Driver: Converts a 4-bit binary input into a 7-segment display output to represent decimal numbers visually.
4. Timer Reset using Mealy FSM:
A Mealy finite state machine is used for sequence detection to trigger the reset functionality of the timer module.
