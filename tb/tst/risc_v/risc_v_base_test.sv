//***************************************************************************************************************
// Author: Van Le
// This is the base test layer. It instantiates the environment.
//***************************************************************************************************************
class risc_v_base_test extends uvm_test;

   `uvm_component_utils(risc_v_base_test)
   
   string         my_name = "risc_v_base_test";
  
   typedef risc_v_env #(risc_v_tlm,risc_v_tlm) env_t;
   env_t   env_h;
   //risc_cfg     default_cfg;
   //risc_cfg     tb_cfg;
   
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_report_info(my_name,"base build phase");
      //
      // Create TB_CONFIG and save in factory
      //
      //default_cfg = risc_cfg::type_id::create("default_cfg");
      //assert(default_cfg.randomize());
      //uvm_resource_db #(risc_cfg)::set("*","TB_CONFIG",default_cfg);

      env_h = env_t::type_id::create("risc_v_env",this);
   endfunction

   function void start_of_simulation_phase(uvm_phase phase);
   	uvm_report_info(my_name,"start of simulation");
    
      // Get config handle. Note that once the config handle is obtained, the internal fields can be modfied
      // using this handle. There is no need to save the config object back in the resource database.
      //assert(uvm_resource_db #(risc_cfg)::read_by_name(get_full_name(),"TB_CONFIG",tb_cfg));
      //if (!uvm_config_db#(risc_cfg)::get(this,"","TB_CONFIG", tb_cfg))
      //  `uvm_error("get_config_db error","risc_base_test")
        
      set_global_timeout(`GLB_TIMEOUT);
   endfunction
   
endclass
