pragma solidity ^0.4.6;

/// @title Strig Return - Fails
contract ReturnsDynamicVariable {
    string private demoString;

		function getStringExternal() external returns(string) {
			return demoString;
		}
}

contract ReceivesDynamicVariable {
		ReturnsDynamicVariable test;

		function Fail() {
			test = new ReturnsDynamicVariable();
		}

    function getString() returns(string) {
				string str = test.getStringExternal(); // Type inaccessible dynamic type is not implicitly convertible to expected type string storage pointer.
		}
}


/// @title Dynamic Array Return - Fails
contract Test {
    address[] forms;

    function addForm(address form){
        forms.push(form);
    }

    function getForms() public returns(address[]){
        return forms;
    }
}

contract Fail {

    function getForms() returns(uint) {
        Test t = new Test();
        t.addForm(address(0x1));
        var forms = t.getForms();

        return forms.length; // Member "length" not found or not visible after argument-dependent lookup in inaccessible dynamic type
    }
}
