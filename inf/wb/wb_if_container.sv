//***************************************************************************************************************
// This class is used as a wrapper of the interface. Its sole use is to enable the testbench to pass the wrapper,
// and hence the interface, as an object using set_config_object and get_config_object methods.
//***************************************************************************************************************
class wb_if_container extends ovm_object;

	virtual wb_if	vif;
	
	function new(virtual wb_if if0);
		vif = if0;
	endfunction
	
endclass
