//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
`define HALF_CLK				50

`define ADDR_WIDTH      16
`define DATA_WIDTH      8
`define HALF_PERIOD     50
`define USB_ADDR_MIN    32'h0000_1000
`define USB_ADDR_MAX    32'h0000_1fff
`define RESET_LENGTH    5
`define ADDR_ARR_SIZE   50
`define GEN_SOURCE_NUM  3
`define GENERATE_SIZE   5
`define COUNT_THRESHOLD 7
`define START_WAIT      1
`define MEM_REGION_SEL  0
`define SEQ_LOOP_COUNT  25  
`define DRAIN_TIME      1000
`define NUM_TRANS       20
`define NUM_WRITE       50
`define GLB_TIMEOUT     100000000
